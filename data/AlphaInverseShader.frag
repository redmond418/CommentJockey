uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    vec4 mainTex= texture2D(texture, vertTexCoord.st);
    mainTex.a = 1 - mainTex.a;
    gl_FragColor = mainTex * vertColor;
}