PShape box;
PImage image;

void setup() {  
  size(430, 430, P3D);
  box = createShape(BOX, 200);
  image = loadImage("metalplate_base.jpg");
  box.setTexture(image);
}

void draw() {
  shape(box, 200, 200);
}
