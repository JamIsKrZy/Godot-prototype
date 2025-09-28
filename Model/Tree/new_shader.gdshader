shader_type spatial;
render_mode blend_mix, cull_disabled, diffuse_burley, specular_schlick_ggx;

// Texture and visual control
uniform sampler2D foliage_texture : source_color, filter_linear, repeat_enable;
uniform vec2 texture_scale = vec2(1.0, 1.0);
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.1;

// Color control
uniform vec3 foliage_colour : source_color = vec3(0.13, 0.33, 0.25);
uniform float color_strength : hint_range(0.0, 2.0) = 1.0;

// Fresnel blend
uniform vec3 fresnel_colour : source_color = vec3(0.5, 0.7, 0.4);
uniform float fresnel_strength : hint_range(0.0, 1.0) = 0.3;
uniform float fresnel_power : hint_range(0.1, 5.0) = 1.5;

// Billboard effect control
uniform float billboard_strength : hint_range(0.0, 1.0) = 1.0;
uniform vec2 vertex_offset_scale = vec2(1.0, 1.0);
uniform bool flip_normal = true;

// Wind sway control
uniform bool use_wind = true;
uniform float wind_strength : hint_range(0.0, 1.0) = 0.1;
uniform float wind_speed : hint_range(0.1, 5.0) = 1.0;
uniform vec3 wind_direction = vec3(1.0, 0.0, 0.0);

// PBR controls
uniform float roughness : hint_range(0.0, 1.0) = 0.8;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float specular : hint_range(0.0, 1.0) = 0.5;

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
    vec2 scaled_uv = UV * texture_scale;
    vec4 tex = texture(foliage_texture, scaled_uv);

    float alpha = tex.g;
    if (alpha < alpha_threshold) {
        discard;
    }

    // Fresnel effect
    vec3 view_dir = normalize(-NORMAL);
    float fresnel = pow(1.0 - dot(NORMAL, view_dir), fresnel_power);
    vec3 base_color = mix(foliage_colour, fresnel_colour, fresnel * fresnel_strength);

    ALBEDO = base_color * tex.rgb * color_strength;
    ALPHA = alpha;

    METALLIC = metallic;
    ROUGHNESS = roughness;
    SPECULAR = specular;
}
