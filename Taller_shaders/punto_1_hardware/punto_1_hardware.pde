PImage image;
PImage vdorig;
PImage lachoy;

PShader shader;
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
  shader = bwShader;
}

void draw() {
  background(0);
  image(image, 0, 0);
  shader(shader);
  println("FPS:", frameRate);
}

void keyPressed() {
  if (key == '1') {
    //Edge detection
    image = vdorig;
    shader = bwShader;
  } else if (key == '2') {
    //Sharpen
    image = vdorig;
    shader = sharpenfrag;
  } else if (key == '3') {
    //Box blur
    image = vdorig;
    shader = boxblurfrag;
  } else if (key == '4') {
    //Edge detection
    image = lachoy;
    shader = bwShader;
  } else if (key == '5') {
    //Sharpen
    image = lachoy;
    shader = sharpenfrag;
  } else if (key == '6') {
    //Box blur
    image = lachoy;
    shader = boxblurfrag;
  } else if (key == '7') {
    //Emboss
    image = vdorig;
    shader = embossShader;
  } else if (key == '8') {
    //Emboss
    image = lachoy;
    shader = embossShader;
  } 
}
