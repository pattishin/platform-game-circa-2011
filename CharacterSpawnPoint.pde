 
  /****************************************************************************
  * CharacterSpawnPoint class:
  * Specifies the point where the character appears/ reappears in the game world.
  ****************************************************************************/
 public class CharacterSpawnPoint extends GameObjectModel{
   
  /*CharacterSpawnPoint field variables*/ 
  public color myColor = color (0, 0, 0);
  
  public CharacterSpawnPoint(float x, float y) {
    myLoc = new PVector(x, y-10, 0);
  }
  
  float getLocX(){
      return myLoc.x;
  }
  
  float getLocY(){
      return myLoc.y;
  }

  void display() {
    fill(myColor);
    ellipse(myLoc.x, myLoc.y, 55, 55);
    fill(color(50,50,50));
    ellipse(myLoc.x, myLoc.y, 45, 45);
    fill(myColor);
    ellipse(myLoc.x, myLoc.y, 35, 35);
    fill(color(50,50,50));
    ellipse(myLoc.x, myLoc.y, 25, 25);
  }
 }

