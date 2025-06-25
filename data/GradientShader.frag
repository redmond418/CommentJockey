uniform vec4 gradientColor = vec4(0.5, 0.5, 0.5, 1);
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    vec4 mainTex= texture2D(texture, vertTexCoord.xy);
    vec4 underColor = gradientColor;
    underColor.a += vertColor.a;
    gl_FragColor = mainTex * mix(gradientColor, vertColor, vertTexCoord.y);
}