#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define MAX_LIGHTS 10

uniform int myLightCount;
uniform vec4 myLightPosition[MAX_LIGHTS];
uniform vec3 myLightNormal[MAX_LIGHTS];
uniform vec3 myLightAmbient[MAX_LIGHTS];
uniform vec3 myLightDiffuse[MAX_LIGHTS];
uniform vec3 myLightSpecular[MAX_LIGHTS];
uniform vec3 myLightFalloff[MAX_LIGHTS];
uniform vec2 myLightSpot[MAX_LIGHTS];

uniform sampler2D texture;
uniform sampler2D normalTexture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertAmbient;
varying vec4 vertSpecular;
varying vec4 vertDiffuse;
varying float vertShininess;

varying vec3 ecNormal;
varying vec3 ecPosition;
varying vec3 ecNormalInv;
varying vec4 vertTexCoord;

const float zero_float = 0.0;
const float one_float = 1.0;
const vec3 zero_vec3 = vec3(0);

float falloffFactor(vec3 lightPos, vec3 vertPos, vec3 coeff) {
  vec3 lpv = lightPos - vertPos;
  vec3 dist = vec3(one_float);
  dist.z = dot(lpv, lpv);
  dist.y = sqrt(dist.z);
  return one_float / dot(dist, coeff);
}

float spotFactor(vec3 lightPos, vec3 vertPos, vec3 lightNorm, float minCos, float spotExp) {
  vec3 lpv = normalize(lightPos - vertPos);
  vec3 nln = -one_float * lightNorm;
  float spotCos = dot(nln, lpv);
  return spotCos <= minCos ? zero_float : pow(spotCos, spotExp);
}

float lambertFactor(vec3 lightDir, vec3 vecNormal) {
  return max(zero_float, dot(lightDir, vecNormal));
}

float blinnPhongFactor(vec3 lightDir, vec3 vertPos, vec3 vecNormal, float shine) {
  vec3 np = normalize(vertPos);
  vec3 ldp = normalize(lightDir - np);
  return pow(max(zero_float, dot(ldp, vecNormal)), shine);
}

vec3 normalFromTexture(sampler2D tex){
  vec3 normal = texture(tex, vertTexCoord.st).rgb;
  normal.g = 1 - normal.g;
  // transform normal vector to range [-1,1]
  normal = normalize(normal * 2.0 - 1.0);
  return normal;
}



void main() {
  // Light calculations
  vec3 totalAmbient = vec3(0, 0, 0);

  vec3 totalFrontDiffuse = vec3(0, 0, 0);
  vec3 totalFrontSpecular = vec3(0, 0, 0);

  vec3 totalBackDiffuse = vec3(0, 0, 0);
  vec3 totalBackSpecular = vec3(0, 0, 0);

  vec3 normal = normalFromTexture(normalTexture);
  vec3 normalInv = normal * -one_float;

  for (int i = 0; i < MAX_LIGHTS; i++) {
    if (myLightCount == i) break;

    vec3 lightPos = myLightPosition[i].xyz;
    bool isDir = myLightPosition[i].w < one_float;
    float spotCos = myLightSpot[i].x;
    float spotExp = myLightSpot[i].y;

    vec3 lightDir;
    float falloff;
    float spotf;

    if (isDir) {
      falloff = one_float;
      lightDir = -one_float * myLightNormal[i];
    } else {
      falloff = falloffFactor(lightPos, ecPosition, myLightFalloff[i]);
      lightDir = normalize(lightPos - ecPosition);
    }

    spotf = spotExp > zero_float ? spotFactor(lightPos, ecPosition, myLightNormal[i],
                                              spotCos, spotExp)
                                 : one_float;

    if (any(greaterThan(myLightAmbient[i], zero_vec3))) {
      totalAmbient       += myLightAmbient[i] * falloff;
    }

    if (any(greaterThan(myLightDiffuse[i], zero_vec3))) {
      totalFrontDiffuse  += myLightDiffuse[i] * falloff * spotf *
                            lambertFactor(lightDir, normal);
      totalBackDiffuse   += myLightDiffuse[i] * falloff * spotf *
                            lambertFactor(lightDir, normalInv);
    }

    if (any(greaterThan(myLightSpecular[i], zero_vec3))) {
      totalFrontSpecular += myLightSpecular[i] * falloff * spotf *
                            blinnPhongFactor(lightDir, ecPosition, normal, vertShininess);
      totalBackSpecular  += myLightSpecular[i] * falloff * spotf *
                            blinnPhongFactor(lightDir, ecPosition, normalInv, vertShininess);
    }
  }

  // Calculating final color as result of all lights (plus emissive term).
  // Transparency is determined exclusively by the diffuse component.
  vec4 frontVertColor =     vec4(totalAmbient, 0) * vertAmbient +
                  vec4(totalFrontDiffuse, 1) * vertColor +
                  vec4(vec3(0, 0, 0), 0) * vertSpecular +
                  vec4(vertDiffuse.rgb, 0);

  vec4 backVertColor = vec4(totalAmbient, 0) * vertAmbient +
                  vec4(totalBackDiffuse, 1) * vertColor +
                  vec4(totalBackSpecular, 0) * vertSpecular +
                  vec4(vertDiffuse.rgb, 0);
  gl_FragColor = texture2D(texture, vertTexCoord.st) * frontVertColor;
}
