String[] lines;
int textsize;
Diagram force_diagram;
void setup(){
  //smooth();
  lines = loadStrings("./star.csv");
  force_diagram = new Diagram(lines); 
  size(800, 600);
  surface.setResizable(true);
  textsize = 15;
}

void draw(){
  background(255);
  force_diagram.draw();
}

void mousePressed(){
  if(mouseButton == LEFT){
    force_diagram.nodeChosen();
  }else if(mouseButton == RIGHT){
    force_diagram.match1();
  }
}

void mouseReleased(){
  if(mouseButton == LEFT){
    force_diagram.nodeUnchosen();
  }else if(mouseButton == RIGHT){
    force_diagram.match2();
  }
}

void mouseDragged(){
  if(mouseButton == LEFT){
    force_diagram.nodeDrag();
  }else if(mouseButton == RIGHT){
    force_diagram.mouse_move();
  }
  force_diagram.total_E = force_diagram.total_Energy();
}

void mouseClicked(){
  if(mouseButton == LEFT){
    force_diagram.addBubble(mouseX, mouseY);
  }else if(mouseButton == RIGHT){
    force_diagram.delBubble();
  }
  force_diagram.total_E = force_diagram.total_Energy();  
}