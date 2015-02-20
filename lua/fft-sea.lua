-- Visualize FFT data as a texture from the HackRF
-- Calculate normals and lighting

VERTEX_SHADER = [[
#version 400
layout (location = 0) in vec3 vp;
layout (location = 1) in vec3 vn;
layout (location = 2) in vec2 vt;
flat out vec4 color;
out vec2 texCoord;
uniform mat4 uViewMatrix, uProjectionMatrix;
uniform float uTime;
uniform sampler2D uTexture;
void main() {
    float d = 0.01;
    float cell_size = 0.0005;
    float r1 = texture(uTexture, vt).r;
    float g1 = texture(uTexture, vt).g;
    float r2 = texture(uTexture, vt + vec2(cell_size, 0)).r;
    float g2 = texture(uTexture, vt + vec2(cell_size, 0)).g;
    float r3 = texture(uTexture, vt + vec2(0, cell_size)).r;
    float g3 = texture(uTexture, vt + vec2(0, cell_size)).g;
    float t1 = sqrt(r1 * r1 + g1 * g1);
    float t2 = sqrt(r2 * r2 + g2 * g2);
    float t3 = sqrt(r3 * r3 + g3 * g3);
    if (r1 > 1) {
        t1 = 0.0;
    }
    if (r2 > 1) {
        t2 = 0.0;
    }
    if (r3 > 1) {
        t3 = 0.0;
    }
    t1 = abs(t1);
    t2 = abs(t2);
    t3 = abs(t3);
    t1 *= d;
    t2 *= d;
    t3 *= d;
    vec3 v1 = vec3(vp.x, t1, vp.z);
    vec3 v2 = vec3(vp.x + cell_size, t2, vp.z);
    vec3 v3 = vec3(vp.x, t3, vp.z + cell_size);

    vec3 u = v2 - v1;
    vec3 v = v3 - v1;
    float x = (u.y * v.z) - (u.z * v.y);
    float y = (u.z * v.x) - (u.x * v.z);
    float z = (u.x * v.y) - (u.y * v.x);
    vec3 n = vec3(x, y, z);

    color = vec4(1.0, 1.0, 1.0, 0.95) * dot(normalize(v1), normalize(n)) * 0.9;
    color += vec4(0.2, 0.2, 0.1, 1.0);

    texCoord = vt;
    gl_Position = uProjectionMatrix * uViewMatrix * vec4(v1, 1.0);
    gl_PointSize = 5;
}
]]

FRAGMENT_SHADER = [[
#version 400
flat in vec4 color;
in vec2 texCoord;
layout (location = 0) out vec4 fragColor;
void main() {
    fragColor = color;
}
]]


function setup()
    freq = 97
    device = nrf_device_new(freq, "../rfdata/rf-200.500-big.raw", 0.1)
    fft = nrf_fft_new(128, 128)
    nrf_block_connect(device, fft)
    camera = ngl_camera_new_look_at(0, 0.01, 0.1)
    shader = ngl_shader_new(GL_TRIANGLES, VERTEX_SHADER, FRAGMENT_SHADER)
    texture = ngl_texture_new(shader, "uTexture")
    model = ngl_model_new_grid_triangles(512, 512, 0.0005, 0.0005)
    ngl_model_translate(model, -0.01, -0.02, 0)
end

function draw()
    ngl_clear(0.2, 0.2, 0.2, 1.0)
    buffer = nrf_fft_get_buffer(fft)
    ngl_texture_update(texture, buffer, 128, 128)
    ngl_draw_model(camera, model, shader)
end

function on_key(key, mods)
    keys_frequency_handler(key, mods)
end
