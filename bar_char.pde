class Bar_char{
  float width_bar;
  float gap;
  String[] names;
  int[] values;
  //ArrayList<Rect> rects = new ArrayList<Rect>();
  Rect[] rects;
  Bar_char(String[] names, int[] values){
    this.names = names;
     rects = new Rect[names.length];
    this.values = values;
    for(int i=0; i<names.length; i++){
      rects[i]= new Rect(Integer.toString(values[i]),names[i]);
      //rects.add(r);
    }
  }
  
  void arrange(){
    fill(255);
    rect(0, 0, width, height);    
    width_bar = 0.65*0.8*width/names.length;
    gap = 0.35*0.8*width/names.length;
    for(int i=0;i<names.length;i++){
      rects[i].x = x_frame+ (i+1)*gap + i*width_bar;
      rects[i].y = height-y_frame;
      rects[i].wid = width_bar;
      // negative number to draw above
      rects[i].hgt = -height*0.8*values[i]/Y_range;
    }
  }
}