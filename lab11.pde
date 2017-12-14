String[] lines;
String[] headers;
String[] names;
int[] values;
int X_range;
int Y_range = 0;
float x_frame, y_frame;
float y_len, y_gap;
Bar_char barc;

void setup(){
  size(800,600);
  lines = loadStrings("./data.csv");
  headers = split(lines[0], ",");
  names = new String[lines.length - 1];
  values = new int[lines.length - 1];
  for(int i = 1; i < lines.length; i++){
    String[] data = split(lines[i], ",");
    names[i - 1] = data[0];
    values[i - 1] = int(data[1]);
    if(Y_range < values[i-1]){
      Y_range = values[i-1];
    }
  }
  barc = new Bar_char(names, values);
}

void draw(){
  x_frame = width*0.1;
  y_frame = height*0.1;
  barc.arrange();
  y_len = 0.8*height;
  y_gap = 10*y_len/Y_range;
  float temp = height-y_frame;
  int y_mark = 0; 
  while(temp >= 0.1*height){
    line(x_frame, temp, width-x_frame+20, temp);
    fill(0);
    text(str(y_mark*10), x_frame-0.045*width, temp);
    y_mark ++;
    temp -= y_gap;
  }  
  line(x_frame, height-y_frame, x_frame, temp);
  for(Rect r:barc.rects){
    r.draw();  
    if(r.show_data){
      fill(0);
      text(r.data,r.x, r.y+r.hgt-10);
    }
    pushMatrix();
    translate(r.x, r.y+10);
    rotate(radians(45));
    fill(0);
    text(r.name, 0,0);
    popMatrix(); 
  }
  fill(25,25,112); text(headers[0], width/2, height*0.99);
  pushMatrix();
  translate(0.025*width, 0.5*height);
  rotate(radians(270));
  text(headers[1], 0,0);
  popMatrix(); 
}