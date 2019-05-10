float xmag, ymag = 0;
float newXmag, newYmag = 0; 
 
void setup()  { 
  size(640, 360, P3D); 
  noStroke(); 
} 
 
void draw()  { 
  background(0.5);
  
  pushMatrix(); 
  translate(width/2, height/2, -30); 
  
  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;
  
  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0; 
  }
  
  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0; 
  }
  
  rotateX(-ymag); 
  rotateY(-xmag); 
  
  scale(90);
  beginShape(QUADS);
  
  fill(47, 81, 112);
  vertex(-1,  1, -1);
  vertex(-1,  1,  1);
  vertex(-1, -1,  1);
  vertex(-1, -1, -1);
  
  vertex( 1,  1, -1);
  vertex(-1,  1, -1);
  vertex(-1, -1, -1);
  vertex( 1, -1, -1);
  
  vertex(-1,  1, -1);
  vertex( 1,  1, -1);
  vertex( 1,  1,  1);
  vertex(-1,  1,  1);
  
  

  vertex(-1, -1, 1);
  vertex(0, -1, 1);
  vertex(0, 1, 1);
  vertex(-1, 1, 1);
  vertex(0, 0, 1);
  vertex(1, 0, 1);
  vertex(1, 1, 1);
  vertex(0, 1, 1);
  
  vertex(0, 0, 0);
  vertex(1, 0, 0);
  vertex(1, -1, 0);
  vertex(0, -1, 0);
    
  
  fill(25, 39, 59);
  vertex(1, -1, -1);
  vertex(1, 0, -1);
  vertex(1, 0, 0);
  vertex(1, -1, 0);
  vertex(1, 1, 1);
  vertex(1, 1, -1);
  vertex(1, 0, -1);
  vertex(1, 0, 1);
  
  vertex(0, -1, 1);
  vertex(0, 0, 1);
  vertex(0, 0, 0);
  vertex(0, -1, 0);

  
  fill(96, 151, 188);
  vertex(-1, -1, -1);
  vertex(1, -1, -1);
  vertex(1, -1, 0);
  vertex(-1, -1, 0);
  vertex(-1, -1, 1);
  vertex(-1, -1, 0);
  vertex(0, -1, 0);
  vertex(0, -1, 1);
  
  vertex(1, 0, 1);
  vertex(1, 0, 0);
  vertex(0, 0, 0);
  vertex(0, 0, 1);
  

  endShape();
  
  popMatrix(); 
} 
