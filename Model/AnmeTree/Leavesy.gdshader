shader_type spatial;
render_mode blend_mix, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

//vec4 tex_color = texture(tex, UV);
    //float mask = tex_color.r;
    //ALBEDO = leaf_color.rgb * mask;
    //ALPHA = mask * leaf_color.a;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;

	// Billboard Mode: Enabled
	//MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			//MAIN_CAM_INV_VIEW_MATRIX[0],
			//MAIN_CAM_INV_VIEW_MATRIX[1],
			//MAIN_CAM_INV_VIEW_MATRIX[2],
			//MODEL_MATRIX[3]);
	//MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}


void fragment() {
    vec4 tex_color = texture(texture_albedo, UV);
    float mask = tex_color.r;

	SPECULAR = 0.5;
	ROUGHNESS = 0.8;
    ALBEDO = albedo.rgb * mask;
    ALPHA = mask * albedo.a;
	EMISSION = ALBEDO * 0.5 ;
}
