uniform sampler2D texture;
uniform float offset = 0.001;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    float combineAlpha = texture2D(texture, vertTexCoord.st + vec2(offset, offset)).a;
    combineAlpha *= texture2D(texture, vertTexCoord.st + vec2( offset, -offset)).a;
    combineAlpha *= texture2D(texture, vertTexCoord.st + vec2(-offset,  offset)).a;
    combineAlpha *= texture2D(texture, vertTexCoord.st + vec2(-offset, -offset)).a;
    combineAlpha = 1. - combineAlpha;
    vec4 mainTex= texture2D(texture, vertTexCoord.st);
    mainTex.a *= combineAlpha;
    gl_FragColor = mainTex * vertColor;
    // gl_FragColor = vec4(vertTexCoord.s, vertTexCoord.t, 0, 1);
}