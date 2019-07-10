import processing.video.*;
Movie myMovie;
PShader shader;
int option = 0;


void setup() {
  size(640, 640, P3D);  
  frameRate(60);
  myMovie = new Movie(this, "cat.mp4");
  myMovie.play();
  
  shader = loadShader("edgesfrag.glsl");
}

void draw() {
  image(myMovie, 0, 0);
  shader(shader);
}

void movieEvent(Movie m) {
  m.read();
}
