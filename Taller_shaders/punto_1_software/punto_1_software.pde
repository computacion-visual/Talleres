import processing.video.*;

PGraphics sourceCanvas;
PGraphics destinationCanvas;
PImage source;
PImage destination;

float[][] edgeDetectionMatrix =  { { 1, 0, -1 } , 
                                   { 0, 0, 0 } ,
                                   { -1, 0, 1 } } ;
                                   
float[][] sharpenMatrix =  { { 0, -1.0, 0 } , 
                             { -1.0, 5.0, -1.0 } ,
                             { 0, -1.0, 0 } } ;


                                   

float[][] boxBlurMatrix =  { { 1.0/9, 1.0/9, 1.0/9 } , 
                             { 1.0/9, 1.0/9, 1.0/9 } ,
                             { 1.0/9, 1.0/9, 1.0/9 } } ;
                             
float[][] gaussianBlurMatrix =   { { 1.0/16, 1.0/8, 1.0/16 } , 
                                   { 1.0/8, 1.0/4, 1.0/8 } ,
                                   { 1.0/16, 1.0/8, 1.0/16 } } ;

void setup(){
  size(1350, 500);
  sourceCanvas = createGraphics(750, 500);
  destinationCanvas = createGraphics(750, 500);
  source = loadImage("vdorig.png");
  destination = createImage(source.width, source.height, RGB);

  sourceCanvas.beginDraw();
  sourceCanvas.background(100);
  sourceCanvas.image(source, 50, 50);
  sourceCanvas.endDraw();
  
  source.loadPixels();
  destination.loadPixels();

  for (int x = 0; x < source.width; x++) {
     for(int y = 0; y < source.height; y++){
      int loc = x + y * source.width;
      destination.pixels[loc] = (source.pixels[loc]);
     }
  }
  destination.updatePixels();
  destinationCanvas.beginDraw();
  destinationCanvas.background(100);
  destinationCanvas.image(destination, 50, 50);
  destinationCanvas.endDraw();
  
  mask = edgeDetectionMatrix;
}

void draw(){ 
  image(sourceCanvas, 0, 0);
  image(destinationCanvas, 600,0);
  
  for (int x = 0; x < source.width; x++) {
     for(int y = 0; y < source.height; y++){
      int loc = x + y * source.width;
      destination.pixels[loc] = (source.pixels[loc]);
     }
  }
  destination.pixels = applyConvolution(destination.pixels, edgeDetectionMatrix, 3, destination.width);
  //destination.pixels = applyConvolution(destination.pixels, sharpenMatrix, 3, destination.width);
  //destination.pixels = applyConvolution(destination.pixels, boxBlurMatrix, 3, destination.width);
  destination.updatePixels();
  destinationCanvas.beginDraw();
  destinationCanvas.background(100);
  destinationCanvas.image(destination, 50, 50);
  destinationCanvas.endDraw();
}

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
      int loc = xloc + source.width*yloc;
      
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
