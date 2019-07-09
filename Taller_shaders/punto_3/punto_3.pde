import nub.core.*;
import nub.primitives.*;
import nub.processing.*;

// Nub objects
Scene scene;
Node light;
Node model;

// Textures
PImage image;
PImage image_blur;
PImage plain;

// Controls
boolean bumpMapping = true;


// shader
PShader lightingShader;

// variables for shader uniforms
final int MAX_LIGHTS = 10;
int lightCount = 7;
float[] lightPosition = new float[MAX_LIGHTS * 4];
float[] lightNormal = new float[MAX_LIGHTS * 3];
float[] lightAmbient = new float[MAX_LIGHTS * 3];
float[] lightDiffuse = new float[MAX_LIGHTS * 3];
float[] lightSpecular = new float[MAX_LIGHTS * 3];      
float[] lightFalloff = new float[MAX_LIGHTS * 3];
float[] lightSpot = new float[MAX_LIGHTS * 2];

float[] currentLightSpecular = {128, 128, 128};
float[] currentLightFalloff = {2, 0, 0};

void setup() {
  shapeMode(CENTER);
  size(400, 400, OPENGL);
  lightingShader = loadShader("lightFrag.glsl", "lightVert.glsl");
  
  image = loadImage("metalplate_base.jpg");
  image_blur = loadImage("metalplate_normal.jpg");
  plain = loadImage("no_normal.jpg");

  scene = new Scene(this);
  scene.setRadius(400);
  scene.fit();

  setupLights();
  setupModels();
}

void draw(){
  resetUniforms();
  ambientLight(0, 0, 0);
  shader(lightingShader);
  background(0);
  scene.render();
  addLightsToShader(lightingShader);
  
  println("draw");
}

void setupModels(){
  model = new Node(scene){
    @Override
    public void graphics(PGraphics pg) {
      noStroke();
      PShape modelShape;
      modelShape = pg.createShape(BOX, 300);
      modelShape.setTexture(image);
      if(bumpMapping){
        lightingShader.set("normalTexture", image_blur);
      } else {
        lightingShader.set("normalTexture", plain);
      }
      pg.shape(modelShape);
    }
  };
  model.setPickingThreshold(0);
}

void setupLights(){
  light = new Node(scene){
    @Override
    public void graphics(PGraphics pg){
      stroke(255,255,255);
      addPointLight(255,255,255, position().x(), position().y(), position().y());
    }
  };
  light.setPosition(new Vector(100, 100, 200));
  light.setPickingThreshold(0);
}

void keyPressed(){
  if(key == 'b'){
    println("bumpMapping: "+bumpMapping);
    bumpMapping = !bumpMapping;
  }
}

///////////////////////////////
// LIGHTING SHADER FUNCTIONS //
///////////////////////////////

void addPointLight(float r, float g, float b, float x, float y, float z){
  lightPosition(lightCount, x, y, z);
  lightNormal(lightCount, 0, 0, 0);
  lightAmbient(lightCount, 0, 0, 0);
  lightDiffuse(lightCount, r, g, b);
  lightSpecular(lightCount, currentLightSpecular[0], currentLightSpecular[1], currentLightSpecular[2]);
  noLightSpot(lightCount);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
  lightCount++;
}

void addSpotLight(float r, float g, float b, float x, float y, float z, float dx, float dy, float dz, float angle, float concentration){
  lightPosition(lightCount, x, y, z);
  lightNormal(lightCount, dx, dy, dz);  
  lightAmbient(lightCount, 0, 0, 0);
  lightDiffuse(lightCount, r, g, b);
  lightSpecular(lightCount, currentLightSpecular[0], currentLightSpecular[1], currentLightSpecular[2]);
  lightSpot(lightCount, angle, concentration);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
}

void addLightsToShader(PShader sh){
  sh.set("myLightCount", lightCount);
  sh.set("myLightPosition", lightPosition, 4);
  sh.set("myLightNormal", lightNormal, 3);
  sh.set("myLightAmbient", lightAmbient, 3);
  sh.set("myLightDiffuse", lightDiffuse, 3);
  sh.set("myLightSpecular", lightSpecular, 3);
  sh.set("myLightFalloff", lightFalloff, 3);
  sh.set("myLightSpot", lightSpot, 2);
}

void lightPosition(int num, float x, float y, float z) {
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  lightPosition[4 * num + 0] = x*pg.modelview.m00 + y*pg.modelview.m01 + z*pg.modelview.m02 + pg.modelview.m03;
  lightPosition[4 * num + 1] = x*pg.modelview.m10 + y*pg.modelview.m11 + z*pg.modelview.m12 + pg.modelview.m13;
  lightPosition[4 * num + 2] = x*pg.modelview.m20 + y*pg.modelview.m21 + z*pg.modelview.m22 + pg.modelview.m23;
  lightPosition[4 * num + 3] = 1;
}

void lightNormal(int num, float dx, float dy, float dz) {
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  float nx =
      dx*pg.modelviewInv.m00 + dy*pg.modelviewInv.m10 + dz*pg.modelviewInv.m20;
    float ny =
      dx*pg.modelviewInv.m01 + dy*pg.modelviewInv.m11 + dz*pg.modelviewInv.m21;
    float nz =
      dx*pg.modelviewInv.m02 + dy*pg.modelviewInv.m12 + dz*pg.modelviewInv.m22;

    float d = PApplet.dist(0, 0, 0, nx, ny, nz);
    if (0 < d) {
      float invn = 1.0f / d;
      lightNormal[3 * num + 0] = invn * nx;
      lightNormal[3 * num + 1] = invn * ny;
      lightNormal[3 * num + 2] = invn * nz;
    } else {
      lightNormal[3 * num + 0] = 0;
      lightNormal[3 * num + 1] = 0;
      lightNormal[3 * num + 2] = 0;
}
}

void lightAmbient(int num, float r, float g, float b) {
  lightAmbient[3 * num + 0] = normalizeColor(r);
  lightAmbient[3 * num + 1] = normalizeColor(g);
  lightAmbient[3 * num + 2] = normalizeColor(b);
}

void lightDiffuse(int num, float r, float g, float b) {
  lightDiffuse[3 * num + 0] = normalizeColor(r);
  lightDiffuse[3 * num + 1] = normalizeColor(g);
  lightDiffuse[3 * num + 2] = normalizeColor(b);
}

void lightSpecular(int num, float r, float g, float b) {
  lightSpecular[3 * num + 0] = normalizeColor(r);
  lightSpecular[3 * num + 1] = normalizeColor(g);
  lightSpecular[3 * num + 2] = normalizeColor(b);
}

void lightFalloff(int num, float c0, float c1, float c2) {
  lightFalloff[3* num + 0] = c0;
  lightFalloff[3* num + 1] = c1;
  lightFalloff[3* num + 2] = c2;
}

void lightSpot(int num, float angle, float exponent) {
  lightSpot[2 * num + 0] = Math.max(0, cos(angle));
  lightSpot[2 * num + 1] = exponent;
}

void noLightSpot(int num) {
  lightSpot[2 * num + 0] = 0;
  lightSpot[2 * num + 1] = 0;
}

void resetUniforms() {
  lightCount = 0;
  lightPosition = new float[MAX_LIGHTS * 4];
  lightNormal = new float[MAX_LIGHTS * 3];
  lightAmbient = new float[MAX_LIGHTS * 3];
  lightDiffuse = new float[MAX_LIGHTS * 3];
  lightSpecular = new float[MAX_LIGHTS * 3];      
  lightFalloff = new float[MAX_LIGHTS * 3];
  lightSpot = new float[MAX_LIGHTS * 2];
}

float normalizeColor(float c) {
  return norm(c, 0, 255);
}

void setCurrentSpecular(float r, float g, float b) {
  currentLightSpecular[0] = r;
  currentLightSpecular[1] = g;
  currentLightSpecular[2] = b;
}

void setCurrentFalloff(float c0, float c1, float c2) {
  currentLightFalloff[0] = c0;
  currentLightFalloff[1] = c1;
  currentLightFalloff[2] = c2;
}
