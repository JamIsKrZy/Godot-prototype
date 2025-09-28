// NOTE: Shader automatically converted from Godot Engine 4.4.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx, depth_prepass_alpha;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

// Billboard effect control
uniform float billboard_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec2 vertex_offset_scale = vec2(1.0, 1.0);
uniform bool flip_normal = true;


// Wind sway control
uniform bool use_wind = true;
uniform float wind_strength : hint_range(0.0, 1.0) = 0.1;
uniform float wind_speed : hint_range(0.1, 5.0) = 1.0;
uniform vec3 wind_direction = vec3(1.0, 0.0, 0.0);



void vertex() {
    if (flip_normal) {
        NORMAL = -NORMAL;
    }

    // Billboard positioning
    vec2 viewspace_offset = (UV - vec2(0.5)) * vertex_offset_scale;
    vec4 modelspace_offset = inverse(MODELVIEW_MATRIX) * vec4(viewspace_offset, 0.0, 0.0);
    VERTEX += modelspace_offset.xyz * billboard_strength;

    // Wind sway
    if (use_wind) {
        float sway = sin(TIME * wind_speed + UV.x * 5.0) * wind_strength;
        VERTEX.xyz += wind_direction * sway;
    }
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);

	// Vertex Color Use as Albedo: Enabled
	albedo_tex *= COLOR;

	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	ALPHA *= albedo.a * albedo_tex.a;
}
