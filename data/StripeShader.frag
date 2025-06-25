#define PI 3.1415926535897932384626433832795

uniform float angle = PI / 4;
uniform float divide = 0.08;
uniform float time;
uniform vec2 resolution;
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    vec4 mainTex= texture2D(texture, vertTexCoord.xy);
    vec2 uv = gl_FragCoord.xy / resolution;
    float tiltedU = cos(angle) * gl_FragCoord.x - sin(angle) * gl_FragCoord.y;
    mainTex.a *= step(time, fract(tiltedU * divide));
    gl_FragColor = mainTex * vertColor;
}