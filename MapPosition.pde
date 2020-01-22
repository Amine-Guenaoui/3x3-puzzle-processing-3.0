class MapPosition{

  int map[][]; 
  int goal[][]={{1,2,3}, // le but 
                {8,0,4},
                {7,6,5}};
  int cursor_pose[]; // position de la case vide 
  int h = 0;//heuristic
  int g = 0;//level
  int f = 0;// fonction de cout 
  boolean visited = false;
  MapPosition parent = null;
 
 public MapPosition (int given_map[][],int goal[][],int given_g){ // if two parameters are given it means its a child 
    this.map=assign_map(given_map);
    this.h = heuristic();
    this.g=given_g +1;
    this.f=this.h+this.g;
    this.goal=goal;
    //println("Child Created ! ! ");
    //println(" cursorPoses",this.cursor_pose[0],this.cursor_pose[1]);
    println("F(",this.f,") = H(",this.h,")+G(",this.g,")");
 }
 
 public MapPosition (int given_map[][],int goal[][]){ // if one parameter is given it means its a root 
    this.map = assign_map(given_map);
    this.h = heuristic();
    this.f=this.h+this.g;
    this.g=0;
    this.goal=goal;
    println("Root Created ! ! ");
    println(" cursorPoses",this.cursor_pose[0],this.cursor_pose[1]);
    println("F(",this.f,") = H(",this.h,")+G(",this.g,")");
 }
 
 int heuristic (){ // a function that calculates a certain heuristic (THE SUM of  false positions of certain numbers  of the puzzle ) 
 int heuristic = 0;
   for(int i=0;i<goal.length ; i++){
     for(int j=0;j<goal[i].length ; j++){
        if(map[i][j]!=goal[i][j])
            heuristic ++;
     }
   }
 
 
 return heuristic;
 }
 
 int [][] assign_map(int given_map[][]){ //to assign a given map to the instance map 
   int [][] newMap = new int[given_map.length][given_map[0].length];
   this.cursor_pose = new int[2];
   for(int i=0;i<given_map.length ; i++){
     for(int j=0;j<given_map[i].length ; j++){
        //println(" map[",i,"][",j,"] = given_map[",i,"][",j,"] ",map[i][j],given_map[i][j]);
       newMap[i][j]=given_map[i][j];
       if(given_map[i][j] == 0){
       this.cursor_pose[0]=i;
       this.cursor_pose[1]=j;
       }
     }
   }
 
 return newMap;
 }
 boolean is_goal(){
 for(int i=0;i<map.length ; i++){
     for(int j=0;j<map[i].length ; j++){
        
       if(map[i][j]!=goal[i][j]){
       return false;
       }
         
     }
   }
   return true;
 }

  int [][] getMap(){
    return this.map;
  }
  int  getCost(){
    return this.f;
  }
  int  getLevel(){
    return this.g;
  }
  int[] get_CursorPose(){
     return cursor_pose; 
  }
  
  boolean can_move_up(){
    //println("can move up ",(cursor_pose[0]-1) >= 0);
    return (cursor_pose[0]-1) >= 0 ;
    
  }
  boolean can_move_down(){
    //println("can move down ",(cursor_pose[0]+1) < 3);
    return (cursor_pose[0]+1) < 3;
    
  }
  boolean can_move_left(){
    //println("can move left ",(cursor_pose[1]-1) >= 0);
    return (cursor_pose[1]-1) >= 0 ;
    
  }
  boolean can_move_right(){
    //println("can move right ",(cursor_pose[1]+1) < 3);
    return (cursor_pose[1]+1) < 3;
    
  }
  
  
 int [][]move_map(int direction){
    
   int new_map[][] = assign_map(this.map);
   int x = cursor_pose[0];
   int y = cursor_pose[1];
   //println("curseur x = ",x," curseur y = ",y);
   int x2=x;
   int y2=y;
   if(direction == 1){ // left 
   y2-=1;
   }
   if(direction == 2){ // right 
   y2+=1;
   }
   if(direction == 3){ // down 
   x2+=1;
   }
   if(direction == 4){ // up 
   x2-=1;
   }
   //println("direction = ",direction);
   //println("x = ",x," y = ",y," x2 =  ",x2 , " y2 = ",y2);
   
   int temp = new_map[x][y]; // temp = B
     new_map[x][y] = new_map[x2][y2]; // B = A
     new_map[x2][y2] = temp; // A = temp
   return new_map; 
 }
  
 void showMap(){
   println();
   for(int i=0;i<3;i++){
       for(int j=0;j<3;j++){
         print(map[i][j]," " );
       }
     println();
   }
 } 
 
 boolean same_map(int [][] given_map){
 
  
   for(int i=0;i<3;i++){
       for(int j=0;j<3;j++){
         if(map[i][j]!=given_map[i][j]){
         return false;
         }
       }
   }
   return true;
 } 
 
 void setVisited(){
     visited = true;
 }
 
 boolean isVisited(){
   
   return visited;
 
 }
 @Override
  public int hashCode() {
    final int prime = 310000;
    int result = 1;
    result = prime * result + Arrays.deepHashCode(map);
    return result;
  }
 @Override    
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }
    if (obj == null) {
      return false;
    }
    if (!(obj instanceof MapPosition)) {
      return false;
    }
    MapPosition other = (MapPosition) obj;
    return Arrays.deepEquals(map,other.getMap()); 
  } 
 
 void cursorPose(){
     println("cursorPoseX = ",cursor_pose[0],cursor_pose[1]);
 
 }
 
  
}
