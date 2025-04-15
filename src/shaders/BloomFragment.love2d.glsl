//-- BloomShader.glsl (LÖVE2D compatible)
#pragma language glsl

#define MIN_TRANSITION_RATE 0.05
#define DECAY_TRANSITION_RATIO 0.1
#define BOOST 0.5

// Main texture is current bloom
uniform sampler2D u_previousBloom; // bloom map from previous frame

uniform float u_transition;

vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords) {
    float transition = max(MIN_TRANSITION_RATE, u_transition);
    float decay = transition * DECAY_TRANSITION_RATIO;
    float boost = 1.0 + (DECAY_TRANSITION_RATIO / decay / (1.0 / MIN_TRANSITION_RATE)) * BOOST;

    // Current bloom
    vec4 currentColor = Texel(texture, texture_coords);
    // Previous bloom
    vec4 previousColor = Texel(u_previousBloom, texture_coords);
    previousColor = max(vec4(0.0), previousColor - vec4(decay));

    return mix(previousColor, currentColor * boost, transition);
}
