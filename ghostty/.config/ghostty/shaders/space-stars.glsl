// Space Stars Shader for Ghostty
// Creates a realistic starfield background

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // Pure black space background
    vec3 color = vec3(0.0);

    // Layer 1: Tiny distant stars (slowest drift)
    vec2 starUV1 = uv * 150.0;
    starUV1.y += iTime * 0.008;
    vec2 starID1 = floor(starUV1);
    vec2 starLocal1 = fract(starUV1);
    float rand1 = hash(starID1);

    if (rand1 > 0.97) {
        vec2 starPos = vec2(hash(starID1 + 0.1), hash(starID1 + 0.2));
        float dist = length(starLocal1 - starPos);
        float brightness = hash(starID1 + 0.3);
        float twinkle = 0.7 + 0.3 * sin(iTime * 2.0 + rand1 * 6.28);
        float star = smoothstep(0.01, 0.0, dist) * brightness * twinkle;
        color += vec3(1.0, 0.95, 0.9) * star * 0.6;
    }

    // Layer 2: Medium stars (medium drift)
    vec2 starUV2 = uv * 80.0;
    starUV2.y += iTime * 0.015;
    vec2 starID2 = floor(starUV2);
    vec2 starLocal2 = fract(starUV2);
    float rand2 = hash(starID2 + 100.0);

    if (rand2 > 0.94) {
        vec2 starPos = vec2(hash(starID2 + 0.1), hash(starID2 + 0.2));
        float dist = length(starLocal2 - starPos);
        float brightness = hash(starID2 + 0.3) * 0.8 + 0.2;
        float twinkle = 0.8 + 0.2 * sin(iTime * 1.5 + rand2 * 6.28);
        float star = smoothstep(0.015, 0.0, dist) * brightness * twinkle;
        color += vec3(1.0, 0.98, 0.95) * star;
    }

    // Layer 3: Bright foreground stars (fastest drift)
    vec2 starUV3 = uv * 40.0;
    starUV3.y += iTime * 0.025;
    vec2 starID3 = floor(starUV3);
    vec2 starLocal3 = fract(starUV3);
    float rand3 = hash(starID3 + 200.0);

    if (rand3 > 0.91) {
        vec2 starPos = vec2(hash(starID3 + 0.1), hash(starID3 + 0.2));
        float dist = length(starLocal3 - starPos);
        float brightness = hash(starID3 + 0.3) * 0.5 + 0.5;
        float twinkle = 0.85 + 0.15 * sin(iTime * 1.0 + rand3 * 6.28);
        float star = smoothstep(0.025, 0.0, dist) * brightness * twinkle;

        // Subtle glow for brighter stars
        float glow = smoothstep(0.08, 0.0, dist) * brightness * 0.3;

        color += vec3(1.0, 1.0, 0.95) * (star + glow);
    }

    // Sample terminal content
    vec4 termColor = texture(iChannel0, uv);

    // Blend: stars visible in transparent areas
    fragColor = mix(vec4(color, 1.0), termColor, termColor.a);
}
