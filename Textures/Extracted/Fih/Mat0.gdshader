//this is vibecoded since i have no idea how to program shaders
shader_type spatial;
// Usa render_mode unshaded se vuoi l'illuminazione retro come abbiamo fatto prima
render_mode unshaded, cull_disabled; 

uniform sampler2D albedo_texture;
uniform float swim_speed = 2.0; // Quanto velocemente sbatte la coda
uniform float swim_amount = 0.1; // Quanto si piega la coda

void vertex() {
    // Perché VERTEX.z? Calcoliamo quanto è "lontano" il vertice dal centro (la testa).
    // La testa non si muove, la punta della coda si piega al massimo.
    // Usiamo la funzione matematica del Seno (sin) basata sul tempo (TIME) per l'oscillazione.
    float wave = sin(TIME * swim_speed + VERTEX.z * 5.0);
    
    // Spostiamo i vertici sull'asse X (sinistra-destra)
    // Più il vertice è indietro (VERTEX.z alto), più viene spostato dall'onda.
    VERTEX.x += wave * swim_amount * VERTEX.z;
}

void fragment() {
    // Applichiamo la texture originale pixelata
    vec4 tex = texture(albedo_texture, UV);
    ALBEDO = tex.rgb;
    
    // Per il taglio netto della trasparenza (Alpha Scissor) che usava il N64
    ALPHA = tex.a;
    ALPHA_SCISSOR_THRESHOLD = 0.5;
}
