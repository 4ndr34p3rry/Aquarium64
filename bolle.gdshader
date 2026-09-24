//this is vibecoded since i have no idea how to program shaders
//UNUSED
shader_type spatial;
// Ignoriamo le luci (unshaded) e disattiviamo il culling per vedere sempre la bolla
render_mode unshaded, cull_disabled;

uniform sampler2D albedo_texture : source_color;
uniform float wobble_speed = 8.0;    // Quanto velocemente pulsa la bolla
uniform float wobble_intensity = 0.3; // 0.3 significa che si deforma del 30%

void vertex() {
    // 1. PARTICLE BILLBOARD NATIVO DI GODOT
    // Ricostruiamo la matrice di mondo leggendo INSTANCE_CUSTOM per non perdere scala e rotazione
    mat4 mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
    mat_world = mat_world * mat4(
        vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), 
        vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), 
        vec4(0.0, 0.0, 1.0, 0.0), 
        vec4(0.0, 0.0, 0.0, 1.0)
    );
    // Applichiamo la matrice alla telecamera
    MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;
    MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);

    // 2. DEFORMAZIONE SQUASH & STRETCH
    // Usiamo la coordinata X e Z di nascita per sfalsare l'onda, così ogni bolla pulsa diversamente
    float phase_offset = MODEL_MATRIX[3].x + MODEL_MATRIX[3].z;
    float wave = sin(TIME * wobble_speed + phase_offset);

    // Modifichiamo le dimensioni locali del quadrato
    VERTEX.y *= 1.0 + (wave * wobble_intensity);
    VERTEX.x *= 1.0 - (wave * wobble_intensity);
}

void fragment() {
    // Disegniamo la texture con il tipico taglio netto (Alpha Scissor) stile N64
    vec4 tex = texture(albedo_texture, UV);
    ALBEDO = tex.rgb;
    ALPHA = tex.a;
    ALPHA_SCISSOR_THRESHOLD = 1.0; 
}