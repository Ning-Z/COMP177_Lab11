import java.util.Map;

class Diagram{
  
  private float SpringCons = .15f;
  private float CoulombCons = 30.0f;
  private float DampingCoef = .1f;
  private float timeStep = .6f;
  
  ArrayList<Node> bubbles = new ArrayList<Node>();
  int max_mass = 0;
  int total_mass = 0;
  int total_bubble = 1;
  Node chosen, match1, match2;
  float total_E;
  int ids = 0;
  
  
  //constructor of Diagram
  Diagram(String[] lines){
    int num_nodes = int(lines[0]);
    int num_edges = int(lines[num_nodes+1]);
    
    // add nodes from the data file, and record the location of nodes 
    for(int i=0; i<num_nodes; i++){
      String[] line = lines[i+1].split(",");
      Node node = new Node(int(line[0]), int(line[1]));
      bubbles.add(node);
      if(int(line[1]) > max_mass){
        max_mass = int(line[1]);
      }
      total_mass += int(line[1]);
      total_bubble += 1;
      ids += 1;
    }
    
    // add the neighbors and the original spring length into nodes
    for(int i=num_nodes; i<num_nodes+num_edges; i++){
      String[] line = lines[i+2].split(",");
      //printArray(line);
      Node n1 = this.getNode(int(line[0]));
      Node n2 = this.getNode(int(line[1]));
      n1.add_node(n2, int(line[2]));
      n2.add_node(n1, int(line[2]));
    }
    
    // initialized the diameter of each node
    float x_r = 0.1*width;
    float y_r = 0.9*height;
    for(Node b:bubbles){
      x_r = x_r+0.1*width;
      y_r = y_r-0.1*height;
      b.setDia(0.05*height*0.01*height*float(b.mass)/float(max_mass));
      b.set(x_r, y_r);
      println(b.x,"  ", b.y, "neighbor: ", b.id);
      b.print_neighbors();
    }
    
    //Get the initial total Energy
    total_E = total_Energy();
  }
  
  

  
  // mathod return the node with a given id
  Node getNode(int id){
    for(Node n:bubbles){
      if(n.id == id){
        return n;
      }
    }
    return null;
  }
  
  // method draw the diagram
  void draw(){
    
    // draw edges
    for(Node b:bubbles){      
      //draw the line
      for(int i = 0; i<b.neighborSize(); i++){
        strokeWeight(2);
        stroke(83, 114, 226);
        line(b.x, b.y, b.neighbors.get(i).x, b.neighbors.get(i).y);
      }
    }
    
    // draw bubbles
    for(Node b:bubbles){      
      //draw the node itself
      b.draw_node();
    }
    
    
    fill(28, 41, 86);
    textSize(textsize);
    String t1 = "Total Kinetic Energy: " + str(total_E);
    String t2 = "Steady: False";
    textAlign(LEFT,TOP);
    text(t1, 0, 0);
    
    if (total_E <= 0.5){
    //  total_E = total_Energy();
    //}else{
      float display_E = total_E;
      t1 = "Total Kinetic Energy: " + str(display_E);
      t2 = "Steady: True";
      total_Energy();
    }else{
      total_E = total_Energy();
    }
    text(t2, 0, textsize);
  }
  
  // method calculate the total energy and the location
  float total_Energy(){
    float total_E = 0.0f;
    for(int i = 0; i < this.bubbles.size(); i++){
      Node T = this.bubbles.get(i);
      float forceX = 0.0;
      float forceY = 0.0;
      //Coulomb Force:
      for (int j = 0; j < this.bubbles.size(); j++){
        Node N = this.bubbles.get(j);
        if (N != T){
          float dx = T.x - N.x;
          float dy = T.y - N.y;
          float sq_distance = sq(dx)+sq(dy) + 0.001;
          float CForceX = T.mass*N.mass*CoulombCons * dx / sq_distance;
          float CForceY = T.mass*N.mass*CoulombCons * dy / sq_distance;
          forceX += CForceX; 
          forceY += CForceY;
        }
      }
      //Spring Force:
      for (int j = 0; j < T.neighbors.size(); j++){
        Node N = T.neighbors.get(j);
        float springL = T.spring_len.get(j);
        float dx = N.x - T.x;
        float dy = N.y - T.y;
        float newL = sqrt(sq(dx)+sq(dy)) + 0.001;
        float springX = springL * dx/newL;
        float springY = springL * dy/newL;
        float SForceX = SpringCons * (dx-springX);
        float SForceY = SpringCons * (dy-springY);
        forceX += SForceX;
        forceY += SForceY;
      }
      float accX = forceX/T.mass;
      float accY = forceY/T.mass;
      
      float vX = (T.v_x + timeStep*accX) * DampingCoef;
      float vY = (T.v_y + timeStep*accY) * DampingCoef;
      
      float x = T.x + timeStep * vX+ (accX *sq(timeStep))/2;
      float y = T.y + timeStep * vY+ (accY *sq(timeStep))/2;
      
      T.set(x,y);
      T.setV(vX,vY);
      total_E += T.mass * (sq(vX)+sq(vY))/2;
    }
    return total_E;
  }
  
  // get the node chosen by mouse
  void nodeChosen(){
    for(Node b:bubbles){
      if(b.mouse_in()){
        chosen = b;
        break;
      }
    }
  }
  
  // set the chosen node to null
  void nodeUnchosen(){
    chosen = null;
  }
  
  // move the node chosen to the location it drags to
  void nodeDrag(){
    if(chosen != null){
      chosen.set(mouseX, mouseY);
      chosen.setV(0.0, 0.0);
    }
  }
  
  void addBubble(float x, float y){
    boolean intersec = false;
    for(Node b:bubbles){
      if(b.mouse_in()){
        intersec = true;
        break;
      }
    }
    if(!intersec){
      int mass = 4;
      ids += 1;
      Node add_one = new Node(ids, mass);
      total_mass += mass;
      add_one.set(x, y);
      if(max_mass == 0){
        max_mass = total_mass;
      }
      add_one.setDia(0.05*height*0.01*height*float(mass)/float(max_mass));
      add_one.setV(0.0, 0.0);
      bubbles.add(add_one);
    }
  }
  
  void delBubble(){
    Node toDel =null;
    for(Node b:bubbles){
      if(b.mouse_in()){
        toDel = b;
        break;
      }
    }
    //println(toDel.id);
    if(toDel != null){
      int del_id = toDel.id;
      int del_loc = 0;
      for(int i=0; i<bubbles.size();i++){
        //delete the selected one 
        
        if(bubbles.get(i).id == del_id){
          del_loc = i;
        }else{
        
          // remove the deleted one from its neighbors
          ArrayList<Node> neighbor = bubbles.get(i).neighbors;
          int del_nei_loc = -1;
          if(!neighbor.isEmpty()){
            for(int j=0; j<neighbor.size(); j++){
              if(neighbor.get(j).id == del_id){
                del_nei_loc = j;
                break;
              }
            }
            if(del_nei_loc != -1){
              neighbor.remove(del_nei_loc);
            }
          }
        }
      }
      total_mass -= bubbles.get(del_loc).mass;
      bubbles.remove(del_loc);
    }
  }
  
  // add neighborhood for right button drag
  void match1(){
    match1 = null;
    for(Node b:bubbles){
      if(b.mouse_in()){
        match1 = b;
        break;
      }
    }
  }
  void match2(){
    match2 = null;
    for(Node b:bubbles){
      if(b.mouse_in()){
        match2 = b;
        break;
      }
    }
    if(match1 != null && match2!=null){
      float dis;
      dis = dist(match1.x, match1.y,match2.x, match2.y);
      match1.add_node(match2, dis);
      match2.add_node(match1, dis);
    }
  }
  void mouse_move(){
    if(match1 != null){
      fill(0);
      line(match1.x, match1.y, mouseX, mouseY);
    }
  }
  
}