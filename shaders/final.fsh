#version 120

varying vec4 texcoord;

uniform sampler2D gcolor;

void Vignette(inout vec3 color) {
  float dist = distance(texcoord.st, vec2(0.5)) * 2.0;
  dist /= 1.5142f;

  dist = pow(dist, 1.1f);

  color.rgb *= (1.0f - dist) / 0.5;
}

vec3 convertToHRD(in vec3 color) {

  vec3 HRDImage;

  vec3 overExposed = color * 1.2f;

  vec3 underExposed = color / 1.5f;

  HRDImage = mix(underExposed, overExposed, color);

  return HRDImage;

}

void main() {

  vec3 color = texture2D(gcolor, texcoord.st).rgb;

  color = convertToHRD(color);

  //Vignette(color);

  color.b = color.b + 0.05f;

  gl_FragColor = vec4(color.rgb, 1.0f);

}
