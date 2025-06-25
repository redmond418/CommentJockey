uniform vec2 resolution;
uniform float time;
uniform sampler2D texture;
uniform float yOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    vec2 uv = -1. + 2. * gl_FragCoord.xy / resolution.xy;
    float value = abs(cos(sin(uv.x * uv.x * 80 + (uv.y + time) * 20) + uv.y * 3 - time * 0.2));
    gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor * value;
}