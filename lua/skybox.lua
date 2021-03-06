-- Load a static scene

VERTEX_SHADER = [[
#version 400
layout (location = 0) in vec3 vp;
layout (location = 1) in vec3 vn;
out vec3 color;
uniform mat4 uViewMatrix, uProjectionMatrix;
uniform float uTime;
void main() {
    color = vec3(1.0, 1.0, 1.0) * dot(normalize(vp), normalize(vn)) * 0.5;
    color += vec3(0.2, 0.5, 0.8);
    gl_Position = uProjectionMatrix * uViewMatrix * vec4(vp, 1.0);
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

camera_x = -20
camera_y = 18
camera_z = 50

function setup()
    model = ngl_model_load_obj("../obj/c004.obj")
    skybox = ngl_skybox_new("../img/negz.jpg", "../img/posz.jpg", "../img/posy.jpg", "../img/negy.jpg", "../img/negx.jpg", "../img/posx.jpg")
    shader = ngl_shader_new(GL_TRIANGLES, VERTEX_SHADER, FRAGMENT_SHADER)
    camera = ngl_camera_new_look_at(camera_x, camera_y, camera_z)
end

function draw()
    ngl_clear(0.2, 0.2, 0.2, 1)
    camera = ngl_camera_new_look_at(camera_x, camera_y, camera_z)
    ngl_skybox_draw(skybox, camera)
    ngl_draw_model(camera, model, shader)
end

function on_key(key, mods)
    keys_camera_handler(key, mods)
end
