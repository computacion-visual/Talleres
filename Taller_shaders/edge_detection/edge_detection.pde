PImage image;
PShape can;
float angle;

PShader bwShader;

void setup() {
  size(640, 360, P3D);
  image = loadImage("vdorig.png");
  bwShader = loadShader("edgesfrag.glsl");
}

void draw() {
  background(0);
  image(image, 0, 0);
  shader(bwShader);
}
