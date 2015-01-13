-- Display a static scene with a diffuse shader.

VERTEX_SHADER = [[
#version 400
layout (location = 0) in vec3 vp;
layout (location = 1) in vec3 vn;
out vec3 color = vec3(.41,.3,.2);
uniform mat4 uViewMatrix, uProjectionMatrix, NormalMatrix;
uniform float uTime;

void main() {
float roughness = .0025;
float innertexture = 50;
float yflow = 4.50;
vec3 pt = vec3(vp.x + noise1(uTime/10.0-vp.y),vp.y+noise1(vp.x * (roughness* 30.0) + noise1(vp.z * roughness) + uTime * 0.5) *yflow,vp.z);

color = vec3(0.8-noise1(vp.z*innertexture), 1.0-noise1(vp.z*innertexture), 1.0-(noise1(vp.x*innertexture)));
    gl_Position = uProjectionMatrix * uViewMatrix * vec4(pt, 0.25);
}
]]

FRAGMENT_SHADER = [[
#version 400
in vec3 color;
layout (location = 0) out vec4 fragColor;
void main() {
    fragColor = vec4(color, 0.95);
}
]]

function setup()
    camera = ngl_camera_init_look_at(-20, 18, 20)
    model = ngl_load_obj("../obj/c004.obj")
    shader = ngl_shader_init(GL_TRIANGLES, VERTEX_SHADER, FRAGMENT_SHADER)
end

function draw()
    camera_x = math.sin(nwm_get_time() * 0.3) * 50
    camera_z = -100
    camera_y = math.cos(nwm_get_time() * 0.3) * 50

    camera = ngl_camera_init_look_at(camera_x-10, camera_y, camera_z)
    ngl_clear(0.2, 0.2, 0.2, 1)
    ngl_draw_model(camera, model, shader)
end
