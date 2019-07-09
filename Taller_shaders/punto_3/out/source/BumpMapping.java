import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import nub.core.*; 
import nub.primitives.*; 
import nub.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BumpMapping extends PApplet {





// Nub objects
Scene scene;
Node light;
Node model;

// Textures
PImage plain;

final int TEX_NUMBER = 7;
PImage[] baseTexArray = new PImage[TEX_NUMBER]; 
PImage[] normalTexArray = new PImage[TEX_NUMBER]; 

// Controls
boolean bumpMapping = true;
int selectedTexture = 0;
boolean figureType = true;


// shader
PShader lightingShader;

// variables for shader uniforms
final int MAX_LIGHTS = 10;
int lightCount = 0;
float[] lightPosition = new float[MAX_LIGHTS * 4];
float[] lightNormal = new float[MAX_LIGHTS * 3];
float[] lightAmbient = new float[MAX_LIGHTS * 3];
float[] lightDiffuse = new float[MAX_LIGHTS * 3];
float[] lightSpecular = new float[MAX_LIGHTS * 3];      
float[] lightFalloff = new float[MAX_LIGHTS * 3];
float[] lightSpot = new float[MAX_LIGHTS * 2];

float[] currentLightSpecular = {128, 128, 128};
float[] currentLightFalloff = {2, 0, 0};

public void setup() {
  shapeMode(CENTER);
  
  lightingShader = loadShader("lightFrag.glsl", "lightVert.glsl");

  scene = new Scene(this);
  scene.setRadius(400);
  scene.fit();

  loadTextures();
  setupLights();
  setupModels();
}

public void loadTextures(){
  baseTexArray[0] = loadImage("metalplate_base.jpg");
  normalTexArray[0] = loadImage("metalplate_normal.jpg");
  baseTexArray[1] = loadImage("metaltiles_base.jpg");
  normalTexArray[1] = loadImage("metaltiles_normal.jpg");
  baseTexArray[2] = loadImage("rock_base.jpg");
  normalTexArray[2] = loadImage("rock_normal.jpg");
  baseTexArray[3] = loadImage("scales_base.jpg");
  normalTexArray[3] = loadImage("scales_normal.jpg");
  baseTexArray[4] = loadImage("stone_base.jpg");
  normalTexArray[4] = loadImage("stone_normal.jpg");
  baseTexArray[5] = loadImage("terracota_base.jpg");
  normalTexArray[5] = loadImage("terracota_normal.jpg");
  baseTexArray[6] = loadImage("wood_base.jpg");
  normalTexArray[6] = loadImage("wood_normal.jpg");
  plain = loadImage("no_normal.jpg");
}

public void draw(){
  resetUniforms();
  ambientLight(0, 0, 0);
  addAmbientLight(128, 128, 128);
  shader(lightingShader);
  background(0);
  scene.render();
  addLightsToShader(lightingShader);
}

public void setupModels(){
  model = new Node(scene){
    @Override
    public void graphics(PGraphics pg) {
      noStroke();
      PShape modelShape;
      if(figureType){
        modelShape = pg.createShape(SPHERE, 50);
      } else{
        modelShape = pg.createShape(BOX, 50);
      }
      modelShape.setTexture(baseTexArray[selectedTexture]);
      if(bumpMapping){
        lightingShader.set("normalTexture", normalTexArray[selectedTexture]);
      } else {
        lightingShader.set("normalTexture", plain);
      }
      pg.shape(modelShape);
    }
  };
  model.setPickingThreshold(0);
}

public void setupLights(){
  light = new Node(scene){
    @Override
    public void graphics(PGraphics pg){
      stroke(255,255,255);
      pg.sphere(10)   ;
      addPointLight(255,255,255, position().x(), position().y(), position().y());
    }
  };
  light.setPosition(new Vector(0, 0, 200));
  light.setPickingThreshold(0);
}

///////////////////////
// MOUSE INTERACTION //
///////////////////////

public void mouseMoved() {
  scene.cast();
}

public void mouseDragged() {
  if (mouseButton == LEFT && scene.trackedNode() == null){
    scene.spin();
  }
  else if (mouseButton == RIGHT){
    scene.translate();
  }
  else{
    scene.scale(mouseX - pmouseX);
  }
}

public void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}

public void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      selectedTexture = selectedTexture == TEX_NUMBER-1 ? 0 : selectedTexture + 1;
    }
    else if(keyCode == DOWN){
      selectedTexture = selectedTexture == 0 ? TEX_NUMBER-1 : selectedTexture - 1;
    }
  } else{
    if(key == 'b'){
      println("bumpMapping: "+bumpMapping);
      bumpMapping = !bumpMapping;
    }
    else if(key == 's'){
      println("Changed figure");
      figureType = !figureType;
    }
  }
}

///////////////////////////////
// LIGHTING SHADER FUNCTIONS //
///////////////////////////////

public void addAmbientLight(float r, float g, float b){
  lightPosition(lightCount, 0, 0, 0);
  lightNormal(lightCount, 0, 0, 0);
  lightAmbient(lightCount, r, g, b);
  lightDiffuse(lightCount, 0, 0, 0);
  lightSpecular(lightCount, 0, 0, 0);
  noLightSpot(lightCount);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
  lightCount ++; 
}

public void addPointLight(float r, float g, float b, float x, float y, float z){
  lightPosition(lightCount, x, y, z);
  lightNormal(lightCount, 0, 0, 0);
  lightAmbient(lightCount, 0, 0, 0);
  lightDiffuse(lightCount, r, g, b);
  lightSpecular(lightCount, currentLightSpecular[0], currentLightSpecular[1], currentLightSpecular[2]);
  noLightSpot(lightCount);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
  lightCount++;
}

public void addSpotLight(float r, float g, float b, float x, float y, float z, float dx, float dy, float dz, float angle, float concentration){
  lightPosition(lightCount, x, y, z);
  lightNormal(lightCount, dx, dy, dz);  
  lightAmbient(lightCount, 0, 0, 0);
  lightDiffuse(lightCount, r, g, b);
  lightSpecular(lightCount, currentLightSpecular[0], currentLightSpecular[1], currentLightSpecular[2]);
  lightSpot(lightCount, angle, concentration);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
  lightCount++;
}

public void addLightsToShader(PShader sh){
  sh.set("myLightCount", lightCount);
  sh.set("myLightPosition", lightPosition, 4);
  sh.set("myLightNormal", lightNormal, 3);
  sh.set("myLightAmbient", lightAmbient, 3);
  sh.set("myLightDiffuse", lightDiffuse, 3);
  sh.set("myLightSpecular", lightSpecular, 3);
  sh.set("myLightFalloff", lightFalloff, 3);
  sh.set("myLightSpot", lightSpot, 2);
}

public void lightPosition(int num, float x, float y, float z) {
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  lightPosition[4 * num + 0] =
  x*pg.modelview.m00 + y*pg.modelview.m01 + z*pg.modelview.m02 + pg.modelview.m03;
  lightPosition[4 * num + 1] =
  x*pg.modelview.m10 + y*pg.modelview.m11 + z*pg.modelview.m12 + pg.modelview.m13;
  lightPosition[4 * num + 2] =
  x*pg.modelview.m20 + y*pg.modelview.m21 + z*pg.modelview.m22 + pg.modelview.m23;
  lightPosition[4 * num + 3] = 1;
}

public void lightNormal(int num, float dx, float dy, float dz) {
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

public void lightAmbient(int num, float r, float g, float b) {
  lightAmbient[3 * num + 0] = normalizeColor(r);
  lightAmbient[3 * num + 1] = normalizeColor(g);
  lightAmbient[3 * num + 2] = normalizeColor(b);
}

public void lightDiffuse(int num, float r, float g, float b) {
  lightDiffuse[3 * num + 0] = normalizeColor(r);
  lightDiffuse[3 * num + 1] = normalizeColor(g);
  lightDiffuse[3 * num + 2] = normalizeColor(b);
}

public void lightSpecular(int num, float r, float g, float b) {
  lightSpecular[3 * num + 0] = normalizeColor(r);
  lightSpecular[3 * num + 1] = normalizeColor(g);
  lightSpecular[3 * num + 2] = normalizeColor(b);
}

public void lightFalloff(int num, float c0, float c1, float c2) {
  lightFalloff[3* num + 0] = c0;
  lightFalloff[3* num + 1] = c1;
  lightFalloff[3* num + 2] = c2;
}

public void lightSpot(int num, float angle, float exponent) {
  lightSpot[2 * num + 0] = Math.max(0, cos(angle));
  lightSpot[2 * num + 1] = exponent;
}

public void noLightSpot(int num) {
  lightSpot[2 * num + 0] = 0;
  lightSpot[2 * num + 1] = 0;
}

public void resetUniforms() {
  lightCount = 0;
  lightPosition = new float[MAX_LIGHTS * 4];
  lightNormal = new float[MAX_LIGHTS * 3];
  lightAmbient = new float[MAX_LIGHTS * 3];
  lightDiffuse = new float[MAX_LIGHTS * 3];
  lightSpecular = new float[MAX_LIGHTS * 3];      
  lightFalloff = new float[MAX_LIGHTS * 3];
  lightSpot = new float[MAX_LIGHTS * 2];
}

public float normalizeColor(float c) {
  return norm(c, 0, 255);
}

public void setCurrentSpecular(float r, float g, float b) {
  currentLightSpecular[0] = r;
  currentLightSpecular[1] = g;
  currentLightSpecular[2] = b;
}

public void setCurrentFalloff(float c0, float c1, float c2) {
  currentLightFalloff[0] = c0;
  currentLightFalloff[1] = c1;
  currentLightFalloff[2] = c2;
}
  public void settings() {  size(1080, 720, OPENGL); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BumpMapping" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
