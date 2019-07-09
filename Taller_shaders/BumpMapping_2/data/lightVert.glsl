uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform vec4 lightPosition;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

attribute vec4 ambient;
attribute float shininess;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 vertAmbient;
varying vec4 vertSpecular;
varying vec4 vertDiffuse;
varying float vertShininess;

varying vec3 ecPosition;

void main() {
  // Vertex in clip coordinates
  gl_Position = transform * position;

  // Vertex in eye coordinates
  ecPosition = vec3(modelview * position);

  // Normal vector in eye coordinates
  vec3 ecNormal = normalize(normalMatrix * normal);

  // Calculating texture coordinates, with r and q set both to one
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

  //Calculating specular light
  vec3 cameraDirection = normalize(0 - ecPosition);
  vec3 lightDirection = normalize(lightPosition.xyz - ecPosition);
  vec3 lightDirectionReflected = reflect(-lightDirection, ecNormal);

  float specular_intensity = max(0.0, dot(lightDirectionReflected, cameraDirection));
  float diffuse_intensity = max(0.0, dot(lightDirection, ecNormal));

  vertColor = color;
  vertAmbient = ambient;
  vertSpecular = vec4(specular_intensity, specular_intensity, specular_intensity, 1) * color;;
  vertDiffuse = vec4(diffuse_intensity, diffuse_intensity, diffuse_intensity, 1) * color;
  vertShininess = shininess;
}
