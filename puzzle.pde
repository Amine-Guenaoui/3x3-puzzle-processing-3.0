import java.util.*;
Integer plan[] = {4,6,8,2,7,5,0,3,1}; // ce plan va etre transforme en une matrice : le but d'utiliser un vecteur est de faire un SHUFFLE si on ve
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
    buttonBackPoseY,
    buttonInitPoseX,
    buttonInitPoseY;
int curPosx,
    curPosy;
boolean goalReached,// if goal is reached 
        moveStop;// to change position with a mouse 
PImage Map;
MapPosition Root;// our root Node/State
int visitedX,visitedY;// the position of the mouse in the map
int step;
LinkedList<MapPosition> Open;  
LinkedList<MapPosition> Temp;  
LinkedList<MapPosition> Path;
LinkedList<MapPosition> Path2;
LinkedList<MapPosition> Closed;  
PImage back;  
boolean path_reached=false;
boolean found_goal;      
void setup(){
    back = loadImage("retro.jpg");
    size(800,600);
    // the next variables values are DYNAMIC TO DIFFRENT RESOLUTIONS 
    back = back.get(300,300,width,height);
    blocSizeX = (width-100)/4;
    blocSizeY = height/3;
    buttonSizeX = width/6;
    buttonSizeY = (height)/10;
    buttonNextPoseX = width-width/5;
    buttonNextPoseY = height-(height/2);
    buttonBackPoseX = buttonNextPoseX;
    buttonBackPoseY = buttonNextPoseY - buttonSizeY; 
    buttonInitPoseX = buttonBackPoseX;
    buttonInitPoseY = buttonBackPoseY - buttonSizeY; 
    
    //randomise the map --------------
    //List<Integer> intList = Arrays.asList(plan); // put contents on inlist
    //Collections.shuffle(intList);//shuffle contents
    //intList.toArray(plan);// return results 
    //println(Arrays.toString(plan)); // show results 
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
    Path  = new LinkedList<MapPosition>();
    Path2  = new LinkedList<MapPosition>();
    Closed =new LinkedList<MapPosition>();  
    
    
    
    Root = new MapPosition(map,goal);
    Root.showMap();
    println("Root == goal : ",Root.is_goal());
    println("constructing path ... A star");
    Open.add(Root); // adding Root to OPEN
    
    double debut = System.currentTimeMillis();   
    found_goal =  A_star();
    double fin = System.currentTimeMillis();
    println("ALGORITHME execution TIME  : "+(debut+fin)/2);

}

void draw(){
  background(back);//show background image
  if(!found_goal && !checkGoal()){
  fillMap();
  //positionChange();
  }else if(found_goal & !checkGoal() ){
  //positionChange(); // to use the mouse
  fillMap();  
  }
  else if (found_goal & checkGoal() ){
  fillMap();  
  end();
  }
  showButtons();

 // println("checking Goal" , goalReached);

}


void showButtons(){
 showButton("Suivant",buttonNextPoseX,buttonNextPoseY ,buttonSizeX,buttonSizeY);
 showButton("Retour",buttonBackPoseX,buttonBackPoseY ,buttonSizeX,buttonSizeY);
 showButton("Initialiser",buttonInitPoseX,buttonInitPoseY ,buttonSizeX,buttonSizeY);
 showButton("But",buttonBackPoseX,buttonBackPoseY+buttonSizeY*2,buttonSizeX,buttonSizeY);
 showNumber("Pas",Path2.size(),buttonBackPoseX,buttonBackPoseY-buttonSizeY*2);
 showNumber("Faux",wrong_poses(),buttonBackPoseX,buttonBackPoseY-buttonSizeY*3);
 
}

int wrong_poses(){ // a function that calculates THE SUM of false positions 
   int wrong = 0;
   for(int i=0;i<goal.length ; i++){
     for(int j=0;j<goal[i].length ; j++){
        if(map[i][j]!=goal[i][j]){
            wrong++;
        }
            
     }
    }
  return wrong;
}
void showNumber(String text ,int number ,int poseX,int poseY){

fill(255,255,255,100);
rect(poseX-100,poseY-50,200,60);
textSize(40);
fill(0);
text(number,poseX,poseY);
text(text,poseX-100,poseY);

}
void showButton(String name,int posx, int posy , int w ,int h ){
 fill(255,255,255,100);
 //println("width = ",w);
 rect(posx,posy ,w,h);
 textSize(30);
 fill(0,0,0);
 text(name,posx,posy+h/2+10);
}

boolean overRect(int x, int y, int width, int height)  {
 boolean over=false;
 if(mousePressed ){ 
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    over = true;
  } else {
    over = false;
  }
 }
 return over;
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

void fillIntoGivenMap(int [][]map){ // to assign the given map into map/state  which will be shown to screen 
  
  for(int i=0 ; i<this.map.length ; i++){
        for(int j=0 ; j<this.map[i].length ; j++){       
           //fill(255,255,255,);
           //rect(blocSizeX*i,blocSizeY*j,blocSizeX,blocSizeY);
           //fill(0,0,0);
           //textSize(blocSizeX);
           this.map[j][i]=map[j][i];
           if(map[j][i]!=0)
           //println(map[i][j]," " );
           if(map[i][j]==0){ // to save the cursor position 
            curPosx = i;
            curPosy = j;
           }           
        }
    }

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
  text("SUCCESS !",0,height/2);
  
}
void mousePressed(){ // for All Mouse events 
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
    //println(visitedX," " , visitedY);      
    if(visitedX != -1 && visitedY != -1){
    //println(map[visitedX][visitedY]);      
    move();
    }
  }
  // next button function
  if (overRect(buttonNextPoseX, buttonNextPoseY,buttonSizeX,buttonSizeY) ) {
      //println("clicked next");
          if(!Path.isEmpty()){  
            
            MapPosition path_node = Path.removeLast();
            
            fillIntoGivenMap(path_node.getMap());//afficher
            
            Path2.add(path_node);
         
      }
    }
    // back button function
    if (overRect(buttonBackPoseX,buttonBackPoseY,buttonSizeX,buttonSizeY)) {
        //println("clicked back");
        if(!Path2.isEmpty()){
          
          MapPosition path_node = Path2.removeLast();
          
          fillIntoGivenMap(path_node.getMap());
          
          Path.add(path_node);
        }   
    }
    // Init button function
    if (overRect(buttonInitPoseX,buttonInitPoseY ,buttonSizeX,buttonSizeY)) {
        //println("clicked initialize");
        while(!Path2.isEmpty()){
          
          MapPosition path_node = Path2.removeLast();
          
          fillIntoGivenMap(path_node.getMap());
          
          Path.add(path_node);
        }   
    }
    // goal button function
    if (overRect(buttonBackPoseX,buttonBackPoseY+buttonSizeY*2,buttonSizeX,buttonSizeY)) {
        //println("clicked goal");
        while(!Path.isEmpty()){
          
          MapPosition path_node = Path.removeLast();
          
          fillIntoGivenMap(path_node.getMap());
          
          Path2.add(path_node);
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
  //println("target is ",targetX," ",targetY);
  if(targetX <10 && targetY <10){
    int temp = map[visitedX][visitedY];
        map[visitedX][visitedY] = map[targetX][targetY];
        map[targetX][targetY]= temp;
        //println("pose changed ");
  }

}

boolean A_star(){
  

    while(!Open.isEmpty() && !path_reached  ){
    //if(!Open.isEmpty()){ 
            step++;
            println("---------------------------------------------");
            println("step = "+step);
            println("---------------------------------------------");
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
                println("number of movements : "+Path.size());
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
