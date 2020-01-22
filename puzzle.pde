import java.util.*;
Integer plan[] = {4,6,8,2,7,5,0,3,1};
//Integer plan[]={2,4,3,5,6,0,1,8,7};
int map[][];//matrix of positions
int goal[][]={{1,2,3},{8,0,4},{7,6,5}};
int blocSizeX,
    blocSizeY,
    buttonSizeX,
    buttonSizeY,
    buttonNextPoseX,
    buttonNextPoseY,
    buttonBackPoseX,
    buttonBackPoseY;
int curPosx,
    curPosy;
boolean goalReached,// if goal is reached 
        moveStop; // to change position with a mouse 
PImage Map;
MapPosition Root;
//A_tree A_star_tree; 
int visitedX,visitedY;// the position of the mouse in the map
int step;
LinkedList<MapPosition> Open;  
LinkedList<MapPosition> Temp;  
LinkedList<int[][]> Open_Map_Temp;  
LinkedList<int[][]> Open_Map;  
LinkedList<int[][]> Closed_Map_Temp;
LinkedList<int[][]> Closed_Map;
LinkedList<MapPosition> Path;
LinkedList<MapPosition> Path2;
LinkedList<MapPosition> Closed;  
PImage back;  
boolean path_reached=false;
boolean x;      
void setup(){
    back = loadImage("retro.jpg");
    size(800,600);
    back = back.get(back.width/2,0,width,height);
    blocSizeX = (width-100)/4;
    blocSizeY = height/3;
    buttonSizeX = (width-150)/3;
    buttonSizeY = (height)/10;
    buttonNextPoseX = width-99;
    buttonNextPoseY = height-(height/2);
    buttonBackPoseX = buttonNextPoseX;
    buttonBackPoseY = buttonNextPoseY - buttonSizeY; 
    //randomise the map --------------
    //List<Integer> intList = Arrays.asList(plan); // put contents on inlist
    //Collections.shuffle(intList);//shuffle contents
    //intList.toArray(plan);// return results 
    ////println(Arrays.toString(plan)); // show results 
    //Map = createImage(800,800,RGB); // create our image 
    map = new int[3][3];
    int k=0; // fill our matrice with contents 
    
    for(int i=0 ; i<3 ; i++){
       for(int j=0 ; j<3 ; j++){
           map[i][j]=plan[k];
           print(plan[k]);
           if(plan[k]==0){ // to save the cursor position 
            curPosx = i;
            curPosy = j;
           }
           k++;
        }
        println();
    }
    goalReached = false;
    moveStop=true;
    step = 0;
    Open =  new LinkedList<MapPosition>();  
    Temp =  new LinkedList<MapPosition>();  
    Open_Map_Temp = new LinkedList<int[][]>();  
    Open_Map =new LinkedList<int[][]>();  
    Closed_Map =new LinkedList<int[][]>();
    Path  = new LinkedList<MapPosition>();
    Path2  = new LinkedList<MapPosition>();
    Closed =new LinkedList<MapPosition>();  
    Closed_Map_Temp = new LinkedList<int[][]>();
    
    
    
    Root = new MapPosition(map,goal);
    Root.showMap();
    println("Root == goal : ",Root.is_goal());
    println("constructing path ... A star");
    Open.add(Root);
    //Open.add(new MapPosition(Root.move_map(2),goal,30)); // right 
    //Open.add(new MapPosition(Root.move_map(4),goal,Root.getLevel())); // up
    //Open.add(new MapPosition(Root.move_map(4),goal,Root.getLevel())); // up
    //Open.add(new MapPosition(map,goal,-9)); // up
    //Collections.sort(Open,new Open_Sort());
    //println("position de plus grand cout "+Open.indexOf(new MapPosition(Root.move_map(2),goal,0)));
    //println("position de moin  cout "+Open.indexOf(new MapPosition(Root.move_map(4),goal,Root.getLevel())));
    //println("position de raceine  "+Open.indexOf(new MapPosition(map,goal)));
    //println("Open.constains Root map only = ",Open.contains(new MapPosition(map,goal,65)));
    //println("Open.constains up move map only = ",Open.contains(new MapPosition(Root.move_map(4),goal,65)));
    //println("Open.constains goal map only = ",Open.contains(new MapPosition(goal,goal,65)));
    //MapPosition a = Open.remove();
    //MapPosition b = Open.remove();
    //MapPosition c = Open.remove();
    //println("cout de a "+a.getCost());
    //println("cout de b "+b.getCost());
    //println("cout de c "+c.getCost());
    
    
    //println(Root.is_goal());
    //// test 
    //println("size of Open = ",Open.size());
    //int index = Open.indexOf(Root); 
    //println("index of root = " ,index);
    
    //if(Root.can_move_left()){
    //  MapPosition y = new MapPosition(Root.move_map(1),goal,300) ;
    //  y.showMap();
    //  y.cursorPose();
    //  Open.add(y);
    //}
    //if(Root.can_move_up()){
    //  MapPosition y = new MapPosition(Root.move_map(4),goal,300) ;
    //  y.showMap();
    //  y.cursorPose();
    //  Open.add(y);
    //}
    
    //MapPosition y = Open.remove();
    //y.showMap();
    
    
    
    //if(Root.can_move_right()){
    //println(Open.add(new MapPosition(Root.move_map(2),goal,Root.getLevel())));
    //Collections.sort(Open,new Open_Sort());
    //}
    
    //index = Open.indexOf(new MapPosition(Root.move_map(1),goal,2));
    //MapPosition  x = Open.remove();//,y = Open.remove();
    //println("cost of  x = " ,x.getCost());//,"cost of  y = " , y.getCost());
    //x.showMap();
    //x.cursorPose();
    //y.showMap();
    //MapPosition x = Open.get(index);
    //index = Open.indexOf(new MapPosition(Root.move_map(1),goal,2));
    //println("index of another elemnt = " ,index);
   x =  A_star();
  //A_star();  
  //fillMap();
}

void draw(){
  background(back);
  if(!x && !checkGoal()){
  fillMap();
  positionChange();
  //x =  A_star();
  
  }else if(x & !checkGoal() ){
  positionChange();
  fillMap();  
    
  }
  else if (x & checkGoal() ){
  //showButton();  

  fillMap();  
  end();
  }
  showButtons();

 // println("checking Goal" , goalReached);

}

void mouseClicked() {
  if (overRect(buttonNextPoseX, buttonNextPoseY,buttonSizeX,buttonSizeY) ) {
    delay(1000/2);
    
    println("hover next");
      if(!Path.isEmpty()){  
        MapPosition path_node = Path.removeLast();
        fillIntoGivenMap(path_node.getMap());
        Path2.add(path_node);
      }   
  }
  if (overRect(buttonBackPoseX,buttonBackPoseY ,buttonSizeX,buttonSizeY)) {
      delay(1000/2);
      println("hover back");
      if(!Path2.isEmpty()){  
        MapPosition path_node = Path2.removeLast();
        fillIntoGivenMap(path_node.getMap());
        Path.add(path_node);
      }   
  }
  
}

void showButtons(){
 showButton("suivant",buttonNextPoseX,buttonNextPoseY ,buttonSizeX,buttonSizeY);
 showButton("retour",buttonBackPoseX,buttonBackPoseY ,buttonSizeX,buttonSizeY);

}




void showButton(String name,int posx, int posy , int w ,int h ){
 fill(255,255,255,100);
 //println("width = ",w);
 rect(posx,posy ,w,h,6, 6, 6, 6);
 textSize(30);
 fill(0,0,0);
 text(name,posx,posy+h/2+10);

  
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void fillMap(){
  
  for(int i=0 ; i<map.length ; i++){
        for(int j=0 ; j<map[i].length ; j++){       
           fill(255,255,255,100);
           rect(blocSizeX*i,blocSizeY*j,blocSizeX,blocSizeY);
           fill(0,0,0);
           textSize(blocSizeX);
           if(map[j][i]!=0)
           text(map[j][i],blocSizeX*i,blocSizeY*j+blocSizeY);
           
           //println(map[i][j]," " );
           if(map[i][j]==0){ // to save the cursor position 
            curPosx = i;
            curPosy = j;
           }           
        }
    }

}

void fillIntoGivenMap(int [][]map){
  
  for(int i=0 ; i<this.map.length ; i++){
        for(int j=0 ; j<this.map[i].length ; j++){       
           //fill(255,255,255,);
           //rect(blocSizeX*i,blocSizeY*j,blocSizeX,blocSizeY);
           //fill(0,0,0);
           //textSize(blocSizeX);
           this.map[j][i]=map[j][i];
           if(map[j][i]!=0)
           text(map[j][i],blocSizeX*i,blocSizeY*j+blocSizeY);
           
           //println(map[i][j]," " );
           if(map[i][j]==0){ // to save the cursor position 
            curPosx = i;
            curPosy = j;
           }           
        }
    }

}

void positionChange(){
//println(mouseX ," ",mouseY);
//mousePressed();
mouseClicked();

}

boolean checkGoal(){
  
  boolean reaching=true;
  int i=0,j=0;
  while(i<map.length){
    j=0;
      while(j<map[i].length){
           if(map[i][j]!=goal[i][j]) reaching=false;
           j++;
      }
      i++;
  }
  
  goalReached = reaching;
  return reaching;


}

void end(){
  fill(255,0,0);
  textSize(width/8);
  text("Goal Reached !",0,height/2);
  
}
void mousePressed(){
  int rangeX1=blocSizeX,
      rangeX2=blocSizeX*2,
      rangeX3=blocSizeX*3;
  int rangeY1=blocSizeY,
      rangeY2=blocSizeY*2,
      rangeY3=blocSizeY*3;
      visitedX = -1;
      visitedY = -1;
  if(mouseX <rangeX1 ){
    visitedY=0;
  }
  if(mouseX >rangeX1 && mouseX <rangeX2 ){
    visitedY=1;
  }
  if(mouseX >rangeX2 && mouseX <rangeX3 ){
    visitedY=2;
  }
  if(mouseY <rangeY1 ){
    visitedX=0;
  }
  if(mouseY >rangeY1 && mouseY <rangeY2 ){
    visitedX=1;
  }
  if(mouseY >rangeY2 && mouseY <rangeY3 ){
    visitedX=2;
  }
  if(mousePressed && moveStop){// once we click on a mouse button
    println(visitedX," " , visitedY);      
    if(visitedX != -1 && visitedY != -1){
    println(map[visitedX][visitedY]);      
    move();
    }
  }
      
  

}

void move(){
  // 4 conditions
  int targetX=10,targetY=10;
  if(visitedX+1 < 3 && map[visitedX+1][visitedY] == 0){ // right
    targetX = visitedX+1;
    targetY = visitedY; 
  }
  if(visitedX-1>=0 && map[visitedX-1][visitedY] == 0){ // left 
    targetX = visitedX-1;
    targetY = visitedY; 
  }
  if(visitedY+1<3 && map[visitedX][visitedY+1] == 0){ // down 
    targetX = visitedX;
    targetY = visitedY+1; 
  }
  if(visitedY-1>=0 && map[visitedX][visitedY-1] == 0){//up 
    targetX = visitedX;
    targetY = visitedY-1; 
  }
  println("target is ",targetX," ",targetY);
  if(targetX <10 && targetY <10){
    int temp = map[visitedX][visitedY];
        map[visitedX][visitedY] = map[targetX][targetY];
        map[targetX][targetY]= temp;
        println("pose changed ");
  }

}

boolean A_star(){
  
    while(!Open.isEmpty() && !path_reached  ){
    //if(!Open.isEmpty()){ 
            step++;
            //println("---------------------------------------------");
            //println("step = "+step);
            //println("---------------------------------------------");
            MapPosition X = Open.remove(); // remove return the shortest f(X) = H(X)+G(X)
            //println("---------------------------------------------");
            //println("OPEN size = ",Open.size(),"CLOSED size = ",Closed.size());
            //println("---------------------------------------------");
            
            if(X.is_goal()){
                //get path 
                MapPosition father=X.parent;
                Path.add(X);
                while(father != null) {
                Path.add(father);
                father=father.parent;    
                }
            return true;
            }
            X.setVisited();
            Closed.add(X);
            //generating kids/children 
            MapPosition fils1  = null; //left
            MapPosition fils2  = null; //right
            MapPosition fils3  = null; //bottom
            MapPosition fils4  = null; //top
            //fillIntoGivenMap(X.getMap());
            
            if(X.can_move_left()){// && !child_isGoal){
                    fils1 = new MapPosition(X.move_map(1),goal,X.getLevel());
                    fils1.parent = X;
                    //println("left map :");
                    //fils1.showMap();
            }
            
            if(X.can_move_right()){// && !child_isGoal){
                fils2 = new MapPosition(X.move_map(2),goal,X.getLevel());
                fils2.parent = X;
                //println("right map :");
                //fils2.showMap();
            }
            
            if(X.can_move_down() ){ //&& !child_isGoal ){
                fils3 = new MapPosition(X.move_map(3),goal,X.getLevel());
                fils3.parent = X;
                //println("down map :");
                //fils3.showMap();
            }
            
            if(X.can_move_up()){// !child_isGoal ){
                fils4 = new MapPosition(X.move_map(4),goal,X.getLevel());
                fils4.parent = X;
                //println("up map :");
                //fils4.showMap();
            }
             
             check_fils(fils1);
             check_fils(fils2);
             check_fils(fils3);
             check_fils(fils4);
             
}// end of Open.isempty
   
return false;
}

void check_fils(MapPosition fils){

    if(fils != null) {
                    if(!Open.contains(fils) && !Closed.contains(fils) ){
                    
                       Open.add(fils);
                       Collections.sort(Open , new Open_Sort());
                    
                    }else if ( Open.contains(fils) && !Closed.contains(fils) ){
                          
                          //println("child already in open");
                          int index =Open.indexOf(fils);
                          //println("his pose is " , index );
                          //println(index);
                          //MapPosition temp =Open.get(index);
                          MapPosition temp =Open.remove(index); // remove him temporary for testing
                          //println("-------------------------------------------------------------------- ");
                          //println("-------------------------------------------------------------------- "+Open.contains(temp));
                          //println("OLD COST IN OPEN F(old)="+temp.getCost()+" NEW COST f(new)="+fils.getCost());
                          //println("-------------------------------------------------------------------- ");
                            if(  fils.getCost() < temp.getCost() ){
                             //println("COST UPDATED => OPEN UPDATED"); 
                             //fils.setVisited();
                             Open.add(fils);
                             Collections.sort(Open,new Open_Sort());
                             //stop();
                              }else { // return him 
                                //println("COST NOT UPDATED => RESTORING OLD TP OPEN ");
                                //temp.setVisited();
                                Open.add(temp);
                                Collections.sort(Open,new Open_Sort());
                          //println("-------------------------------------------------------------------- "+Open.contains(temp));
                              }
                          //}
               
                    }else if( !Open.contains(fils) && Closed.contains(fils) ) {
                          
                          //println("child already in closed");
                          int index =Closed.indexOf(fils);
                          //println("his pose is " , index );
                          //println(index);
                          MapPosition temp =Closed.remove(index); // remove him temporary for testing 
                          //println("-------------------------------------------------------------------- ");
                          //println("---------------------------after temp removed----------------------------------------- "+Closed.contains(temp));
                          //println("OLD COST IN CLOSED F(old)="+temp.getCost()+" NEW COST f(new)="+fils.getCost());
                          //println("-------------------------------------------------------------------- ");
                          //Collections.sort(Closed,new Open_Sort());
                          //if(!temp.isVisited()){
                              if( fils.getCost() < temp.getCost() ){
                               //println("COST FROM CLOSED UPDATED => OPEN UPDATED"); 
                               //fils.setVisited();
                               Open.add(fils);
                               Collections.sort(Closed,new Open_Sort());
                                } else {  
                                  //println("COST NOT UPDATED => RESTORING OLD TP CLOSED ");
                                  //temp.setVisited();
                                  Closed.add(temp);
                                  Collections.sort(Closed,new Open_Sort());
                                  
                          //println("---------------------------------after temp restored-------------------------------- "+Closed.contains(temp));
                                }
                          //}
                    }
             }
}
