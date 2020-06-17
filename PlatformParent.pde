
/*********************************************************************
 * Platform Parent class:
 * Carries a list of platforms that character(s) can traverse through
 *********************************************************************/
public class PlatformParent extends GameObjectModel{

  /*PlatformParent field variables*/
  public  Obstacle listOfPlatforms[];
  public int platformParentNum;
  public int numOfPlatforms = 5;
  public int platformPointer;

  /***************************************
   * 
   **************************************/  
  public PlatformParent(int num) {
    listOfPlatforms = new Obstacle[numOfPlatforms];
    platformParentNum = num;
    platformPointer = 0; //currently points to first element in array
  }

  /***************************************
   * 
   **************************************/    
  public void setColorForMyPlatforms(color newColor){
    for(int i = 0; i< listOfPlatforms.length; i++){
      if(listOfPlatforms[i]!=null) listOfPlatforms[i].myColor = newColor; 
    }
  }

  /***************************************
   * 
   **************************************/    
  public void addNewChildPlatform(Obstacle newPlatform){
    if(platformPointer >= numOfPlatforms){
      numOfPlatforms += 5;
      Obstacle newPlatformList[] = new Obstacle[numOfPlatforms];
      for(int i = 0; i< listOfPlatforms.length; i++){
        newPlatformList[i] = listOfPlatforms[i];
      }
      listOfPlatforms = newPlatformList;
    }
    listOfPlatforms[platformPointer] = newPlatform;
    newPlatform.myNum = platformPointer;
    platformPointer++;
  }

  /***************************************
   * 
   **************************************/   
  public void deletePlatform(int platformNum){
    listOfPlatforms[platformNum] = null; //deletes platform
    for(int i = platformNum; i< listOfPlatforms.length; i++){
      if(listOfPlatforms[i]!=null) listOfPlatforms[i] = listOfPlatforms[i+1];
    } 
    platformPointer--;
  }

  /***************************************
   *locationOnAPlatform:
   *Determines whether the location given is on any of this parent's platforms
   **************************************/ 
  public boolean collidedMyPlatforms(float characX, float characY, float characWidth, float characHeight){
    for(int i = 0; i< listOfPlatforms.length; i++){
      if(listOfPlatforms[i]!=null){
        if(listOfPlatforms[i].hasCollided(characX, characY, characWidth/2, characHeight/2)){
          return true;
        }
      }
    }
    return false;
  }

  /***************************************
   * 
   **************************************/  
  public void printMyPlatformChildren(){
    System.out.println("Platform Parent " + platformParentNum);
    System.out.println("------------------------------------");
    for(int i = 0; i< listOfPlatforms.length; i++){
      if(listOfPlatforms[i]!=null){
        System.out.println("listOfPlatforms["+i+"] = " + listOfPlatforms[i].myNum + " --> ("+listOfPlatforms[i].myLoc.x +"," + listOfPlatforms[i].myLoc.y +")" ); 
      }
    }
  }

  /***************************************
   * 
   **************************************/  
  public void masterDisplay( ) {      
    for(int i = 0; i< listOfPlatforms.length; i++){
      if(listOfPlatforms[i]!=null) listOfPlatforms[i].display( );
    }
  }
}
