PImage image;
PImage vdorig;
PImage lachoy;
PShape can;
float angle;

PShader selShader;
PShader bwShader;
PShader embossShader;

void setup() {
  size(640, 360, P3D);
  vdorig = loadImage("vdorig.png");
  lachoy = loadImage("lachoy.jpg");
  image = vdorig;
  bwShader = loadShader("edgesfrag.glsl");
  embossShader = loadShader("embossfrag.glsl");
  selShader = bwShader;
}

void draw() {
  background(0);
  image(image, 0, 0);
  shader(selShader);
}

void keyPressed() {
  if (key == '1') {
    //Edge detection
    image = vdorig;
    selShader = bwShader;
  } else if (key == '2') {
    //Emboss
    image = vdorig;
    selShader = embossShader;
  } else if (key == '3') {
    //Emboss
    image = lachoy;
    selShader = bwShader;
  } else if (key == '4') {
    //Emboss
    image = lachoy;
    selShader = embossShader;
  }
}
