import processing.video.*;
Movie myMovie;
PShader shader;

void setup() {
  size(200, 200);
  myMovie = new Movie(this, "cat.mp4");
  myMovie.loop();
  
  shader = loadShader("edgesfrag.glsl");
}

void draw() {
  image(myMovie, 0, 0);
  shader(shader);
}

void movieEvent(Movie m) {
  m.read();
}
