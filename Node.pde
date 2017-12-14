class Node{
  float x, y, dia;
  int mass, id;
  float v_x, v_y;
  //float a_x, a_y;
  ArrayList<Node> neighbors;
  ArrayList<Float> spring_len;
  Node(int id, int mass){
    this.id = id;
    this.mass = mass;
    //this.v_x = 0.0;
    //this.v_y = 0.0;
    neighbors = new ArrayList<Node>();
    spring_len = new ArrayList<Float>();
  }
  
  boolean mouse_in(){
    return sq(mouseX-x) + sq(mouseY-y) <= sq(dia/2);
  }
  
  void print_neighbors(){
    for(Node n:neighbors){
      print(n.id, "---");
    }
  }
  
  void draw_node(){
    if(mouse_in()){
      fill(83, 114, 226);
    }else{
      fill(139, 160, 237);
    }
    strokeWeight(2);
    stroke(83, 114, 226);
    ellipse(x, y, dia, dia);
    if(mouse_in()){
      hoverText(mouseX, mouseY);
    }
  }
  
  //void hoverText(float mx, float my){
  //  float padding = 10;
  //  fill(190, 219, 219);
  //  strokeWeight(0);
  //  float textSize = 20;
  //  textSize(textSize);
  //  textAlign(LEFT,TOP);
  //  //float textBoxWidth = (float)(str(id).length())*textSize*0.6;
  //  //rect(mx+padding, my+padding, textBoxWidth, textSize*1.2);
  //  fill(54, 63, 63);
  //  text("ID: "+ id + ", Mass: " + str(mass), mx + padding, my+padding);
  //}
  
  void hoverText(float mx, float my){
    float padding = 15;
    float textSize = 15;
    textSize(textSize);
    String t1 = "ID: "+ str(id);
    String t2 = "Mass: " + str(mass);
    //Make sure text stay in the canvas
    if (my+textSize*2 >= height){
      my = height-textSize*2;
    }
    if (mx + textSize * t2.length()*0.75>= width){
      mx = width - textSize*t2.length()*0.75;
    }
    fill(28, 41, 86);
    textAlign(LEFT,TOP);
    text(t1, mx + padding, my);
    textAlign(LEFT,TOP);
    text(t2, mx + padding, my+textSize);
  }
  
  void add_node(Node neighbor, float spring_length){
    for(Node n:neighbors){
      if(n.id == neighbor.id){
        return;
      }
    }
    this.neighbors.add(neighbor);
    this.spring_len.add(spring_length);
  }
  
  // set diameter of each node
  void setDia(float dia){
    this.dia = dia/2;
  }
  
  // set the velocity of node
  void setV(float v_x, float v_y){
    this.v_x = v_x;
    this.v_y = v_y;
  }
  
  // set the location of a node. node has to be in the canvas
  void set(float x, float y){
    if(x+dia/2 >=width){
      this.x = width-dia/2;
    }else if(x <= dia/2){
      this.x = dia/2;
    }else{
      this.x = x;
    }
    
    if(y+dia/2 >= height){
      this.y = height-dia/2;
    }else if(y <= dia/2){
      this.y = dia/2;
    }else{
      this.y = y;
    }
  }
  
  // get the size of this node's neighbor
  int neighborSize(){
    return this.neighbors.size();
  }
}