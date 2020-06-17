 /********************************************************************************
  * Character class:
  * Defines the shape of character, location, and action of this character object
  ********************************************************************************/
 public class Character extends GameObjectModel{
   
  /*Character field variables*/
  String characterName = "";
  int pass = 0;
  boolean jumpRequested = false;
  boolean fallRequested = false;
  float characSpeedX = 3;
  float characSpeedY = 3;
  float characVelocityY = 3;
  int xdirection = 1;  // Left or Right
  int ydirection = 1;  // Top to Bottom
  BoundingBox boundBox; 
  Obstacle currentPlatform = null;
  DeathZone deathZone =  null;
  CharacterSpawnPoint spawnPoint= null;
  //PlatformParent [] platformWorld;
  List<PlatformParent> platformWorld;
  Obstacle ground;
  int platformParentPointer = 0;
  int numOfParentPlatforms = 5;
   
  public Character(String name, float x, float y, int h, int w) {
    characterName = name;
    myHeight = h;
    myWidth = w;
    //sets location to be the point at the feet of the character
    myLoc = new PVector (x, y-(h/2), 0); 
    //platformWorld = new PlatformParent[numOfParentPlatforms];
    platformWorld = new ArrayList<PlatformParent>();
  }
  
  void setBoundingBox(BoundingBox bB){
    boundBox = bB;
  }

  void setGroundPlatform(Obstacle obs){
    ground = obs;
    currentPlatform = obs;
    //System.out.println("OBS: start from " + obs.myLoc.x + " end " + (obs.myLoc.x+obs.myWidth));
  }

  void setDeathZone(DeathZone dZ){
    deathZone = dZ;
  }

  void setSpawnPoint(CharacterSpawnPoint spawn){
    spawnPoint = spawn;
  }

  void addAPlatformParentToMyWorld(PlatformParent newParent){
    platformWorld.add(newParent);
  }
  
 private void checkIfPassingDeathZone(){
    if(deathZone!=null){
       if(myLoc.y >= deathZone.myLocStart.y){
           //register that death event has occurred
           this.eventHappened = true;
           this.setEventName("Character has died!");
           if(spawnPoint!=null){
             //register that re-spawn event has occurred
             this.eventHappened = true;
             this.setEventName("Character has re-spawned!");
             myLoc = new PVector (((float)spawnPoint.getLocX()), ((float)spawnPoint.getLocY())-(myHeight/2), 0); 
             //display();
          }
       }
    }
  }
  
  /***************************************
   * atBoundBoxEdgeX:
   * Prevents character to go beyond the bound box set within the platform scene shot
   ***************************************/
  boolean atBoundBoxEdgeX(){
    if((myLoc.x <= boundBox.myLoc.x) || (myLoc.x >= boundBox.myWidth)) return true;
    if((myLoc.x<= boundBox.myLoc.x) || (myLoc.x >= boundBox.myWidth)) return true;
    if((myLoc.x-(myWidth/2) <= boundBox.myLoc.x) || (myLoc.x-(myWidth/2) >= boundBox.myWidth)) return true; 
    return false;
  }
  
  /*************************************** 
   * atBoundBoxEdgeY:
   * Prevents character to go beyond the bound box set within the platform scene shot
   ***************************************/
  boolean atBoundBoxEdgeY(){
    if((myLoc.y <= boundBox.myLoc.y) || (myLoc.y >= boundBox.myHeight)) return true;
    if((myLoc.y<= boundBox.myLoc.y) || (myLoc.y >= boundBox.myHeight)) return true;
    if((myLoc.y-(myHeight/2) <= boundBox.myLoc.y) || (myLoc.y-(myHeight/2) >= boundBox.myHeight)) return true; 
    return false;
  }

  void checkForCollisions(){
    if(atBoundBoxEdgeX()) myLoc.x = myLoc.x;
    if(atBoundBoxEdgeY()) myLoc.y = myLoc.y;
    for(int i = 0; i< platformWorld.size(); i++){
         if(platformWorld.get(i)!=null){
            for(int j = 0; j< platformWorld.get(i).listOfPlatforms.length; j++){
                if(platformWorld.get(i).listOfPlatforms[j]!=null){
                   if(platformWorld.get(i).listOfPlatforms[j].hasCollided(myLoc.x, myLoc.y, myWidth/2, myHeight/2)){
                     if(!platformWorld.get(i).listOfPlatforms[j].equals(currentPlatform)){
                      if(platformWorld.get(i).listOfPlatforms[j].sideThatWasHit!=0){
                         handleCollision(platformWorld.get(i).listOfPlatforms[j].sideThatWasHit, platformWorld.get(i).listOfPlatforms[j]);
                       }
                     }
                   }
                }
            }
         }
      }
  }
  
  void handleCollision(int sideHit, Obstacle platformHit){
    platformHit.eventHappened = true;
    
    if(sideHit==1){
      currentPlatform = platformHit;
      myLoc.y = (currentPlatform.myLoc.y-(myWidth/2));
      fallRequested = false;
      System.out.println("currentPlatform = " + currentPlatform.myNum + " (" + currentPlatform.myLoc.x + ", " + currentPlatform.myLoc.y +")" + ": sideHit = 1");
      
      return;
    }
    if(sideHit==2){
      myLoc.x = myLoc.x-(myWidth/2);
      System.out.println("currentPlatform = " + currentPlatform.myNum + " (" + currentPlatform.myLoc.x + ", " + currentPlatform.myLoc.y +")" + ": sideHit = 2");
      
      return;
    }
    if(sideHit==3){
      if(!fallRequested){
        ydirection *= -1;
      }
      System.out.println("currentPlatform = " + currentPlatform.myNum + " (" + currentPlatform.myLoc.x + ", " + currentPlatform.myLoc.y +")" + ": sideHit = 3");
      
      return;
    }
    if(sideHit==4){
      myLoc.x = myLoc.x+(myWidth/2);
      System.out.println("currentPlatform = " + currentPlatform.myNum + " (" + currentPlatform.myLoc.x + ", " + currentPlatform.myLoc.y +")" + ": sideHit = 4");
      
      return;
    }
  }
  
  void display( ) {
     if(keyPressed){
        if(key==' '){
            jumpRequested = true;
            this.eventHappened = true;
            this.setEventName("(Space bar hit) Jump Requested");
        }
        if(key==CODED){
           switch(keyCode){
             case(RIGHT):
                 //register that event has occurred
                 this.eventHappened = true;
                 this.setEventName("(Right key hit) Move to right requested");
                 //move character
                 myLoc.x += characSpeedX;
                 if(atBoundBoxEdgeX()) myLoc.x = (boundBox.myLoc.x+boundBox.myWidth)-(myWidth/2);
                 if(myLoc.x > (currentPlatform.myLoc.x+currentPlatform.myWidth)){ 
                 currentPlatform = new Obstacle(0, 0, 0, 0, 0, 0);
                 fallRequested = true;
               }
               break;
             case(LEFT):
                 //register event has occurred
                 this.eventHappened = true;
                 this.setEventName("(Left key hit) Move to left requested");
                 //move character
                 myLoc.x -= characSpeedX;
                 if(atBoundBoxEdgeX()) myLoc.x = boundBox.myLoc.x+(myWidth/2);
                 if(myLoc.x < (currentPlatform.myLoc.x)){ 
                 currentPlatform = new Obstacle(0, 0, 0, 0, 0, 0);
                 fallRequested = true;  
               }
               break;
           }
         }
      }
      //checks if any collisions has occurred
      checkForCollisions();
          
       //if 'space' bar was pressed and a jump was requested
      if(jumpRequested && (!fallRequested)){
          float jumpHeight = myWidth*3;
           myLoc.y += ( characVelocityY * ydirection );
           //System.out.println("falling down falling down2"); 
          if(atBoundBoxEdgeX()) myLoc.x = myLoc.x;
          if(atBoundBoxEdgeY()){
              myLoc.y = myLoc.y;
              jumpHeight = (jumpHeight/2);
          }
          checkForCollisions();
          if(myLoc.y >(currentPlatform.myLoc.y-myWidth/2) || myLoc.y < (currentPlatform.myLoc.y-(jumpHeight))){
             ydirection *= -1;
             pass++;
          }
          if((myLoc.y ==(currentPlatform.myLoc.y-myWidth/2))&& pass>1){
              jumpRequested = false;
              pass = 0;
          }
      }
      //if the character has left their current platform
      if(fallRequested){
          //register that falling event has occurred
          this.eventHappened = true;
          this.setEventName("Character Falling");
          //have character fall down
          myLoc.y+= ( characVelocityY * ydirection );
          if(atBoundBoxEdgeX()) myLoc.x = myLoc.x;
          checkIfPassingDeathZone();
          checkForCollisions();
      }
      if(myLoc.x < (ground.myLoc.x+ground.myWidth)){
        if(myLoc.y >= ground.myLoc.y-myWidth/2){
          if(fallRequested){
             currentPlatform = ground;
             jumpRequested = false;
             fallRequested = false;
          }
        }
      }
      stroke(0, 191, 255);
      fill(0, 191, 255);
      ellipse(myLoc.x, myLoc.y, myWidth, myHeight);
      stroke(strokeColor);
  }
 }
 
