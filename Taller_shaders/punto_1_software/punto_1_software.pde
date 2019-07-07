PImage img;

float[][] edgeDetectionMatrix =  { { 1, 0, -1 } , 
                                   { 0, 0, 0 } ,
                                   { -1, 0, 1 } } ;
                                   
float[][] sharpenMatrix =  { { 0, -1.0, 0 } , 
                             { -1.0, 5.0, -1.0 } ,
                             { 0, -1.0, 0 } } ;

float[][] boxBlurMatrix =  { { 1.0/9, 1.0/9, 1.0/9 } , 
                             { 1.0/9, 1.0/9, 1.0/9 } ,
                             { 1.0/9, 1.0/9, 1.0/9 } } ;
                             

void setup() {
  img = loadImage("vdorig.png");
  //img.pixels = applyConvolution(img.pixels, edgeDetectionMatrix, 3, img.width);
  img.pixels = applyConvolution(img.pixels, boxBlurMatrix, 3, img.width);
  println("FPS:", frameRate);
}

void draw() {
  image(img, 0, 0);
}

import processing.video.*;

void setPixels(PGraphics in, PGraphics out){
  for(int i=0; i<in.pixels.length; i++){
    out.pixels[i] = in.pixels[i];
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

void movieEvent(Movie m) {
  m.read();
}
