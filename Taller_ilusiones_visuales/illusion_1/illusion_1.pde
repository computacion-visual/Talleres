int x = 0;
int y = 0;
boolean move_y = true;
boolean move_x = false;
boolean increase_x = true;
boolean increase_y = true;

int diameter = 50;
boolean grow = true;

void setup(){
  size(720, 700);
 
}
  
void draw(){
  if(diameter < 100 && grow){
   diameter += 1;
  }
  else{
    grow = false;
    if(diameter > 15)
      diameter -= 1;
     else
       grow = true;
  }
  
  if(move_x){
    if(increase_x)
      if(x < 400)
        x++;
      else
        increase_x = false;
    else
      if(x > 0)
        x--;
      else
        increase_x = true;
  }
  
   if(move_y){
    if(increase_y)
      if(y < 400)
        y++;
      else{
        increase_y = false;
        move_x=true;
      }
    else
      if(y > 0)
        y--;
      else{
        increase_y = true;
        move_x=false;
      }
  }
 
  
  noStroke();
  fill(112, 48, 160);
  
  background(250, 250, 250);   
  circle(x + diameter/2 + 5             , y + diameter/2 + diameter + 5  , diameter);
  circle(x + diameter/2 + diameter + 5  , y + diameter/2 + 5             , diameter);
  circle(x + diameter/2 + diameter + 5  , y + diameter/2 + 2*diameter + 5, diameter);
  circle(x + diameter/2 + 2*diameter + 5, y + diameter/2 + diameter + 5  , diameter);
  fill(0, 0, 0);
  circle(x + diameter/2 + diameter + 5  , y+ diameter/2 + diameter + 5   , 50);
  
  
  
}
