PImage image;
PImage vdorig;
PImage lachoy;
PShape can;
float angle;

PShader selShader;
PShader bwShader;
PShader embossShader;
PShader sharpenfrag;
PShader boxblurfrag;

void setup() {
  size(640, 360, P3D);
  vdorig = loadImage("vdorig.png");
  lachoy = loadImage("lachoy.jpg");
  image = vdorig;
  bwShader = loadShader("edgesfrag.glsl");
  embossShader = loadShader("embossfrag.glsl");
  sharpenfrag = loadShader("sharpenfrag.glsl");
  boxblurfrag = loadShader("boxblurfrag.glsl");
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
    //Sharpen
    image = vdorig;
    selShader = sharpenfrag;
  } else if (key == '3') {
    //Box blur
    image = vdorig;
    selShader = boxblurfrag;
  } else if (key == '4') {
    //Edge detection
    image = lachoy;
    selShader = bwShader;
  } else if (key == '5') {
    //Sharpen
    image = lachoy;
    selShader = sharpenfrag;
  } else if (key == '6') {
    //Box blur
    image = lachoy;
    selShader = boxblurfrag;
  } else if (key == '7') {
    //Emboss
    image = vdorig;
    selShader = embossShader;
  } else if (key == '8') {
    //Emboss
    image = lachoy;
    selShader = embossShader;
  } 
}
