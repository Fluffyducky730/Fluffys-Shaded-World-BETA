#version 120

#include "/lib/framebuffer.glsl"

varying vec4 texcoord;

varying vec3 lightVector;
varying vec3 lightColor;
varying vec3 skyColor;

/*DRAWBUFFERS : 012 */

struct Fragment {
  vec3 albedo;
  vec3 normal;

  float emission;
};

struct Lightmap {
  float torchLightStrength;
  float skyLightStrength;
}

Fragment getFragment(in vec2 coord) {
  Fragment newFragment;

  newFragment.albedo = getAlbedo(coord);
  newFragment.normal = getNormal(coord);
  newFragment.emission = getEmission(coord);

  return newFragment;
}

Lightmap getLightmapSample(in vec2 coord) {
  Lightmap lightmap;

  lightmap.torchLightStrength = getTorchLightStrength(coord);
  lightmap.skyLightStrength = getSkyLightStrength(coord);

  return lightmap;
}

vec3 calculateLighting(in Fragment frag, in Lightmap lightmap) {
  float directLightStrength = dot(frag.normal, lightVector);
  directLightStrength = max(0.0, directLightStrength);
  vec3 directLight = directLightStrength * lightColor;

  vec3 torchColor = vec3(1.0, 0.9, 0.8) * 0.1;
  vec3 torchLight = torchColor * lightmap.torchLightStrength;

  vec3 skyLight = skyColor * lightmap.skyLightStrength;

  vec3 litColor = frag.albedo * (directLight + skyColor + torchLight);
  return mix(litColor, frag.albedo, frag.emission);
}

void main() {
  Fragment frag = getFragment(texcoord.st);
  Lightmap lightmap = getLightmapSample(texcoord.st);
  vec3 finalColor = calculateLighting(frag, lightmap);

  GCOLOR_OUT = vec4(finalColor, 1.0);
}
