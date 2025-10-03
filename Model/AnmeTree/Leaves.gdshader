shader_type spatial;
render_mode blend_mix, cull_disabled, unshaded, depth_prepass_alpha;

uniform sampler2D tex : source_color;
uniform vec4 leaf_color : source_color = vec4(0.2, 0.8, 0.2, 1.0);

varying float depth_factor;

void vertex() {
    // Billboard that always faces the camera
    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]
    );
    MODELVIEW_MATRIX = modified_model_view;

    // Camera-space position of this vertex
    vec3 cam_pos = (VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Normalize depth factor (closer = 1.0, farther = 0.0)
    // Adjust divisor to control fade strength (e.g. 50.0 for more subtle effect)
    depth_factor = clamp(1.0 - abs(cam_pos.z) / 50.0, 0.0, 1.0);

}

void fragment() {
    vec4 tex_color = texture(tex, UV);
    float mask = tex_color.r;

    ALBEDO = leaf_color.rgb * mask;
    ALPHA = mask * leaf_color.a;
}