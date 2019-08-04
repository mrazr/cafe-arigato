shader_type spatial;
render_mode unshaded, cull_front, skip_vertex_transform, depth_test_disable;

void vertex() {
	VERTEX = (MODELVIEW_MATRIX * vec4(1.03 * VERTEX, 1.0)).xyz;
}

void fragment() {
	ALBEDO = vec3(0.8, 0.6, 0.1);
}