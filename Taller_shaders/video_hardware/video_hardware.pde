import processing.video.*;
Movie myMovie;
PShader shader;
int option = 0;


void setup() {
  size(640, 640, P3D);  
  myMovie = new Movie(this, "cat.mp4");
  myMovie.play();
  
  shader = loadShader("edgesfrag.glsl");
  //shader = loadShader("embossfrag.glsl");
  //shader = loadShader("sharpenfrag.glsl");
  //shader = loadShader("boxblurfrag.glsl");
}

void draw() {
  image(myMovie, 0, 0);
  shader(shader);
  println("FPS",frameRate);
}

void movieEvent(Movie m) {
  m.read();
}
