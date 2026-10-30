
shader_type canvas_item;

uniform float intensidad_brillo : hint_range(0.0, 0.5) = 0.2;
uniform float velocidad_brillo : hint_range(0.1, 5.0) = 2.0;

void fragment() {
	vec4 color_original = texture(TEXTURE, UV);

	float pulso = (sin(TIME * velocidad_brillo) + 1.0) / 2.0;

	vec3 color_final = color_original.rgb +
		vec3(pulso * intensidad_brillo);

	COLOR = vec4(color_final, color_original.a);
}

