#pragma language glsl3

// Change attribute names to LÖVE2D's convention
//attribute vec4 VertexPosition; // a_position in original
//attribute vec2 VertexTexCoord; // a_texCoord in original
//attribute vec4 VertexColor;    // a_color in original
attribute vec4 OriginRadius;   // a_originRadius in original (custom)

// Keep uniforms the same
uniform vec2 u_size;
uniform vec2 u_anchor;
uniform mat4 ModelViewMatrix;  // New uniform to replace CC_MVMatrix
//uniform mat4 sProjectionMatrix; // New uniform to replace CC_PMatrix

// Keep varyings with LÖVE convention
varying vec2 v_position;
varying vec2 v_texCoord;
varying vec4 v_fragmentColor;
varying vec3 v_mv_lightPosition;
varying float v_mv_lightRadius;
varying vec3 v_mv_castedAnchorPosition;
varying vec4 v_OriginRadius;   // Only declare custom attributes


// Change main to LÖVE2D entry point
vec4 position(mat4 transform_projection, vec4 vertex_position) {
    // Copy original code but use our renamed variables
    //v_texCoord = VertexTexCoord;
    v_fragmentColor = VertexColor;

    v_OriginRadius = OriginRadius;

    // Light properties are in modelview space
    v_mv_lightPosition = OriginRadius.xyz;
    v_mv_lightRadius = OriginRadius.w;
    vec3 mv_anchorPosition = (ModelViewMatrix * vec4(u_anchor.x, 0.0, 0.0, 1.0)).xzy;
    mv_anchorPosition.z += u_anchor.y;

    // Compare depth to get shadow flip
    float mv_depth = mv_anchorPosition.z;
    float mv_depthDifference = mv_depth - v_mv_lightPosition.z;
    float flip = mv_depthDifference + u_anchor.y < 0.0 ? -1.0 : 1.0;

    // Compare anchor to light to get skew
    vec3 mv_depthAnchorPosition = vec3(mv_anchorPosition.x, mv_anchorPosition.y, mv_depth + u_anchor.y);
    vec3 mv_anchorDifference = mv_depthAnchorPosition - v_mv_lightPosition;
    float mv_anchorDistance = length(mv_anchorDifference);
    vec3 mv_anchorDir = mv_anchorDifference / mv_anchorDistance;
    float skew = tan(atan(mv_anchorDir.x, mv_anchorDir.z) * flip) * 0.5;

    // 45 degree shadow flip
    mat4 castMatrix = mat4(
        1.0, 0.0, 0.0, 0.0,
        skew, 0.7071067811865475 * flip, -0.7071067811865475 * flip, 0.0,
        0.0, 0.7071067811865475 * flip, 0.7071067811865475 * flip, 0.0,
        0.0, 0.0, 0.0, 1.0
    );

    // compare distance to light and counter skew to get stretch
// (closer to light or larger skew = shorter shadow)
	// double abs appears to be necessary for some platforms (osx)
    float altitudeModifier = pow(1.0 / abs(tan(abs(atan(mv_anchorDir.y, mv_anchorDir.z)))), 0.35) * 1.25;
    float skewAbs = max(abs(skew), 0.1);
    float skewModifier = min(pow(skewAbs, 0.1) / skewAbs, 1.0);
    float mv_stretch = min(skewModifier * altitudeModifier, 1.6);

    // Cast vertex
    vec4 castedPosition = VertexPosition; 
    castedPosition.y = (castedPosition.y - u_anchor.y) * mv_stretch;
    castedPosition = castMatrix * castedPosition;
    
    // Shift casted position slightly based on direction of cast
    float flipped = min(flip, 0.0);
    castedPosition.x += skew + flipped * -mv_anchorDir.x * 2.0;
    castedPosition.y += u_anchor.y + flipped * (mv_stretch * 2.0 + mv_anchorDir.x);
    vec4 mv_castedPosition = ModelViewMatrix * castedPosition;
    
    // Extra varyings for blur and fade
    v_mv_castedAnchorPosition = vec3(mv_castedPosition.x, mv_castedPosition.z, mv_castedPosition.y - u_anchor.y);
    v_position = VertexPosition.xy;
    
    // Return the final position - LÖVE expects us to return the final position
    //return transform_projection * vertex_positio;//ProjectionMatrix * mv_castedPosition;
    return transform_projection * vertex_position * (mv_castedPosition/(mv_castedPosition-1));//ProjectionMatrix * mv_castedPosition;
}
