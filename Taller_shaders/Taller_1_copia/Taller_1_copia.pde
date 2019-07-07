import g4p_controls.*;
import processing.video.*;

// Class with static variables that emulate an Enum since it is not supported
class ContentType {
  static final int IMAGE = 1;
  static final int VIDEO = 2;
}

PGraphics base, modified; // PGraphics
PImage img, catImg, baboonImg, lenaImg; // Images
Movie video; // Video

GButton catButton, baboonButton, lenaButton, videoButton; // Buttons
GCheckbox greyHistogramCheck, redHistogramCheck, greenHistogramCheck, blueHistogramCheck, segmentationCheck; // Histogram buttons
GCheckbox meanCheck, ccirCheck, btCheck, smpteCheck; // Grayscale Buttons
GCheckbox edgeDetectionCheck, sharpenCheck, boxBlurCheck, gaussianBlurCheck; // Masks Buttons

int contentType = ContentType.IMAGE;
int modifierType = 1; // 1=GrayScale
int segmentatinRange = 20; // range of segmentation option

float[][] sharpenMatrix =  { { 0, -1.0, 0 } , 
                             { -1.0, 5.0, -1.0 } ,
                             { 0, -1.0, 0 } } ;

float[][] edgeDetectionMatrix =  { { 1, 0, -1 } , 
                                   { 0, 0, 0 } ,
                                   { -1, 0, 1 } } ;
                                   

float[][] boxBlurMatrix =  { { 1.0/9, 1.0/9, 1.0/9 } , 
                             { 1.0/9, 1.0/9, 1.0/9 } ,
                             { 1.0/9, 1.0/9, 1.0/9 } } ;
                             
float[][] gaussianBlurMatrix =   { { 1.0/16, 1.0/8, 1.0/16 } , 
                                   { 1.0/8, 1.0/4, 1.0/8 } ,
                                   { 1.0/16, 1.0/8, 1.0/16 } } ;

void setup() {
  size(1152, 550);
  base = createGraphics(512, 300);
  modified = createGraphics(512, 300);
  
  catImg = loadImage("cat.jpg");
  baboonImg = loadImage("baboon.png");
  lenaImg = loadImage("lena.png");
  
  img = catImg;
  video = new Movie(this, "cat.mp4");
  video.loop();
  
  // Content Type Buttons
  catButton = new GButton(this, 25, 425, 100, 30, "Cat");
  catButton.addEventHandler(this, "handleCatButton");
  baboonButton = new GButton(this, 150, 425, 100, 30, "Baboon");
  baboonButton.addEventHandler(this, "handleBaboonButton");
  lenaButton = new GButton(this, 275, 425, 100, 30, "Lena");
  lenaButton.addEventHandler(this, "handleLenaButton");
  videoButton = new GButton(this, 25, 475, 100, 30, "Video");
  videoButton.addEventHandler(this, "handleVideoButton");
  
  // Grayscale Method Buttons
  meanCheck = new GCheckbox(this, 612, 400, 125, 25, "Mean");
  ccirCheck = new GCheckbox(this, 612, 425, 125, 25, "CCIR 601");
  btCheck = new GCheckbox(this, 612, 450, 125, 25, "BT. 709");
  smpteCheck = new GCheckbox(this, 612, 475, 125, 25, "SMPTE 240M");
  
  // Convolution Buttons
  edgeDetectionCheck = new GCheckbox(this, 775, 400, 125, 25, "Edge Detection");
  sharpenCheck = new GCheckbox(this, 775, 425, 125, 25, "Sharpen");
  boxBlurCheck = new GCheckbox(this, 775, 450, 125, 25, "Box Blur");
  gaussianBlurCheck = new GCheckbox(this, 775, 475, 125, 25, "Gaussian Blur");
  
  //Histograms Buttons
  greyHistogramCheck = new GCheckbox(this, 950, 400, 125, 25, "Grey");
  redHistogramCheck = new GCheckbox(this, 950, 425, 125, 25, "Red");
  greenHistogramCheck = new GCheckbox(this, 950, 450, 125, 25, "Green");
  blueHistogramCheck = new GCheckbox(this, 950, 475, 125, 25, "Blue");
  segmentationCheck = new GCheckbox(this, 950, 500, 125, 25, "Segmentation");
  
}

void draw() {
  background(128);
  // Text
  textSize(32);
  text("Original", 25, 35);
  text("Modificada", 612, 35);
  textSize(18);
  text("Content Type", 25, 390);
  text("Grayscale", 612, 390);
  text("Masks", 775, 390);

  // Base Canvas
  base.beginDraw();
  base.background(0);
  img.resize(512,300);
  switch(contentType){
    case ContentType.IMAGE:
      base.image(img, 0, 0);
      break;
     case ContentType.VIDEO:
      base.image(video, 0, 0);
      break;
     default:
       break;
  }
  base.endDraw();
  base.loadPixels();
  image(base, 25, 50);

  // Modified Canvas
  modified.beginDraw();
  modified.background(0);
  modified.loadPixels();
  setPixels(base, modified);
  if(meanCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 1.0/3, 1.0/3, 1.0/3);
  }
  if(ccirCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 0.2989, 0.5870, 0.1140);
  }
  if(btCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 0.2126, 0.7152, 0.0722);
  }
  if(smpteCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 0.212, 0.701, 0.087);
  }
  if(edgeDetectionCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, edgeDetectionMatrix, 3, modified.width);
  }
  if(sharpenCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, sharpenMatrix, 3, modified.width);
  }
  if(boxBlurCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, boxBlurMatrix, 3, modified.width);
  }
  if(gaussianBlurCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, gaussianBlurMatrix, 3, modified.width);
  }
  if(contentType == ContentType.IMAGE){
    text("Histograms", 950, 390);
  }
  if(contentType == ContentType.VIDEO){
    textSize(25);
    text("FPS: " + int(frameRate), 950, 400);
  }

  modified.updatePixels();  
  modified.endDraw();
  
  image(modified, 612, 50);
  
  if(greyHistogramCheck.isSelected() && contentType == ContentType.IMAGE){
    int[] hist = greyHistogram(modified.pixels);
    drawHistogram(hist, color(255,255,255), img);
  }
  if(redHistogramCheck.isSelected() && contentType == ContentType.IMAGE){
    int[] hist = rgbHistogram(modified.pixels, 'r');
    drawHistogram(hist, color(255,0,0), img);
  }
  if(greenHistogramCheck.isSelected() && contentType == ContentType.IMAGE){
    int[] hist = rgbHistogram(modified.pixels, 'g');
    drawHistogram(hist, color(0,255,0), img);
  }
  if(blueHistogramCheck.isSelected() && contentType == ContentType.IMAGE){
    int[] hist = rgbHistogram(modified.pixels, 'b');
    drawHistogram(hist, color(0,0,255), img);
  }
  if(segmentationCheck.isSelected() && contentType == ContentType.IMAGE) {
    int segmentationMinValue;
    int segmentationMaxValue;
    stroke(255, 0, 0);
    strokeWeight(3);
    if(mouseX < 612 + segmentatinRange){
      line(612, img.height, 612, img.height + 50);
      line(612 + (segmentatinRange*2), img.height, 612 + (segmentatinRange*2), img.height + 50);
      segmentationMinValue = 0;
      segmentationMaxValue = segmentatinRange * 2;
    } else if(mouseX > 612 + img.width - segmentatinRange){
      line(612 + img.width - (segmentatinRange*2), img.height, 612 + img.width - (segmentatinRange*2), img.height + 50);
      line(612 + img.width, img.height, 612 + img.width, img.height + 50);
      segmentationMinValue = img.width - (segmentatinRange*2);
      segmentationMaxValue = img.width;
    } else{
      line(mouseX - segmentatinRange, img.height, mouseX - segmentatinRange, img.height + 50);
      line(mouseX + segmentatinRange, img.height, mouseX + segmentatinRange, img.height + 50);
      segmentationMinValue = mouseX - 612 - segmentatinRange;
      segmentationMaxValue = mouseX - 612 + segmentatinRange;
    }

    strokeWeight(1);
    int[] hist = segmentationHistogram(modified.pixels);

    modified.pixels = segmentImage(modified.pixels, segmentationMinValue, segmentationMaxValue);
    modified.updatePixels();  
    modified.endDraw();    
    image(modified, 612, 50);

    drawSegmentationHistogram(hist, color(255,255,255), img, segmentationMinValue, segmentationMaxValue);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if(segmentatinRange + 20 > 240){
        segmentatinRange = 240;
      } else {
        segmentatinRange += 20;
      }
    } else if (keyCode == DOWN) {
      if(segmentatinRange - 20 < 20){
        segmentatinRange = 20;
      } else {
        segmentatinRange -= 20;
      }
    } 
  } 
}

color [] blackAndWhite(color[] pixelArray, float red, float green, float blue) {
  for(int i = 0; i < pixelArray.length; i++){
    float r = red(color(pixelArray[i])) * red;
    float g = green(color(pixelArray[i])) * green;
    float b = blue(color(pixelArray[i])) * blue;
    pixelArray[i] = color(r + g + b);
  }
  return pixelArray;
}

color[] segmentImage(color[] pixelArray, int minValue, int maxValue){
  for(int i = 0; i < pixelArray.length; i++) {
    int brightness = int(brightness(pixelArray[i]));
    if (brightness < minValue || brightness > maxValue) {
      pixelArray[i] = color(0, 0, 0);
    }
  }

  return pixelArray;
}

int[] greyHistogram(color[] pixelArray){
  int[] hist = new int[256]; 
  for (int i = 0; i < pixelArray.length; i++) {
    int bright = int(brightness(pixelArray[i]));
    hist[bright]++; 
  }
  
  return hist;
}

int[] rgbHistogram(color[] pixelArray, char channel){
  int[] hist = new int[256]; 
  switch(channel){
    case 'r':
      for (int i = 0; i < pixelArray.length; i++) {
        int value = int(red(pixelArray[i]));
        hist[value]++; 
      }
      break;
    case 'g':
      for (int i = 0; i < pixelArray.length; i++) {
        int value = int(green(pixelArray[i]));
        hist[value]++; 
      }
      break;
    case 'b':
      for (int i = 0; i < pixelArray.length; i++) {
        int value = int(blue(pixelArray[i]));
        hist[value]++; 
      }
      break;
    default:
      break;
  }
  return hist;
}

int[] segmentationHistogram(color[] pixelArray){
  int[] hist = new int[256];
   for (int i = 0; i < pixelArray.length; i++) {
    int value = int(brightness(pixelArray[i]));
    hist[value]++; 
  }
  return hist;
}

void drawHistogram(int[] hist, color strokeColor, PImage img){
  int histMax = max(hist);
  
  stroke(strokeColor);
  for (int i = 0; i < img.width; i+=2) {
    int which = int(map(i, 0, img.width, 0, 255));
    int y = int(map(hist[which], 0, histMax, img.height, 0));
    line(612 + i, img.height + 50, 612 + i, y + 50);
  }
}

void drawSegmentationHistogram(int[] hist, color strokeColor, PImage img, int minValue, int maxValue){
  int histMax = max(hist);
  
  stroke(strokeColor);
  for (int i = minValue; i < maxValue; i+=2) {
    int which = int(map(i, 0, img.width, 0, 255));
    int y = int(map(hist[which], 0, histMax, img.height, 0));
    line(612 + i, img.height + 50, 612 + i, y + 50);
  }
}

color[] applyConvolution(color[] pixelArray, float[][] matrix, int matrixsize, int imgWidth){
  color [] result = new color[pixelArray.length];
  for(int i=0; i<pixelArray.length; i++){
    result[i] = convolution(i%imgWidth, i/imgWidth, matrix, matrixsize, pixelArray);
  }
  return result;
}

color convolution(int x, int y, float[][] matrix, int matrixsize,  color[] pixelArray) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  
  for (int i = 0; i < matrixsize; i++ ) {
    for (int j = 0; j < matrixsize; j++ ) {
      
      int xloc = x + i-offset;
      int yloc = y + j-offset;
      int loc = xloc + img.width*yloc;
      
      loc = constrain(loc,0,pixelArray.length-1);
      rtotal += (red(color(pixelArray[loc])) *matrix[i][j] );
      gtotal += (green(color(pixelArray[loc])) * matrix[i][j]);
      btotal += (blue(color(pixelArray[loc])) * matrix[i][j]);
    }
  }
  
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);

  return color(rtotal, gtotal, btotal); 
}

void setPixels(PGraphics in, PGraphics out){
  for(int i=0; i<in.pixels.length; i++){
    out.pixels[i] = in.pixels[i];
  }
}

void movieEvent(Movie m) {
  m.read();
}

public void handleCatButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  greyHistogramCheck.setVisible(true);
  redHistogramCheck.setVisible(true);
  greenHistogramCheck.setVisible(true);
  blueHistogramCheck.setVisible(true);
  segmentationCheck.setVisible(true);
  img = catImg;
}


public void handleBaboonButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  greyHistogramCheck.setVisible(true);
  redHistogramCheck.setVisible(true);
  greenHistogramCheck.setVisible(true);
  blueHistogramCheck.setVisible(true);
  segmentationCheck.setVisible(true);
  img = baboonImg;
}

public void handleLenaButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  greyHistogramCheck.setVisible(true);
  redHistogramCheck.setVisible(true);
  greenHistogramCheck.setVisible(true);
  blueHistogramCheck.setVisible(true);
  segmentationCheck.setVisible(true);
  img = lenaImg;
}


public void handleVideoButton(GButton button, GEvent event){
  contentType = ContentType.VIDEO;
  greyHistogramCheck.setVisible(false);
  redHistogramCheck.setVisible(false);
  greenHistogramCheck.setVisible(false);
  blueHistogramCheck.setVisible(false);
  segmentationCheck.setVisible(false);
}
