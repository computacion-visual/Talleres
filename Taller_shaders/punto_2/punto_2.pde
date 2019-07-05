void setup() {
  size(500, 500, P3D);
  background(0);
  noStroke();
}

void draw() {
  // Include lights() at the beginning
  // of draw() to keep them persistent 
  lights();
  /*translate(20, 50, 0);
  sphere(30);
  translate(60, 0, 0);
  sphere(30);*/
  
  translate(90, 120, 0);
  sphere(100);
  translate(200, 0, 0);
  sphere(100);
}
