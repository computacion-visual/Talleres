#define PROCESSING_LIGHT_SHADER
#define NUM_LIGHTS 8

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform int lightCount;
uniform vec4 lightPosition[NUM_LIGHTS];

uniform float AmbientContribution;
uniform float DiffuseContribution;
uniform float SpecularContribution;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;


varying vec4 vertColor;
void main() {
  gl_Position = transform * position;
  vec3 ecPosition = vec3(modelview * position);
  vec3 cameraDirection = normalize(0 - ecPosition);

  vec3 ecNormal = normalize(normalMatrix * normal);
  float intensity;

  for (int i = 0; i < lightCount; i++){
    vec3 lightDirection = normalize(lightPosition[i].xyz - ecPosition);

    vec3 lightDirectionReflected = reflect(-lightDirection, ecNormal);

    intensity = AmbientContribution * DiffuseContribution * max(0.0, dot(lightDirection, ecNormal)) + SpecularContribution * max(0.0, dot(lightDirectionReflected, cameraDirection));
    //intensity = max(0.0, dot(lightDirection, ecNormal)) + max(0.0, dot(lightDirectionReflected, cameraDirection));

    vertColor = vec4(intensity, intensity, intensity, 1) * color;
  }
}
