#version 300 es
// Vibrance screen shader — Himal (docs/THEME.md)
// Gently saturates muted colors while leaving already-vivid pixels alone
// (vibrance, not raw saturation — skin tones and pastels stay natural).
// Wired via decoration:screen_shader in dotfiles/hypr/hyprland.conf.
// Tune STRENGTH (0.0 = off, 0.3 = punchy); reload with `hyprctl reload`.
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float STRENGTH = 0.15;

void main() {
    vec4 color = texture(tex, v_texcoord);

    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    float maxc = max(color.r, max(color.g, color.b));
    float minc = min(color.r, min(color.g, color.b));
    float sat = maxc - minc;

    // boost fades out as saturation rises — protects vivid accents
    float boost = STRENGTH * (1.0 - sat);
    color.rgb = mix(vec3(luma), color.rgb, 1.0 + boost);

    fragColor = color;
}
