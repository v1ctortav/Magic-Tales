shader_type canvas_item;

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);
    float alpha = step(dist, 0.5);
    COLOR = texture(TEXTURE, UV);
    COLOR.a *= alpha;
}