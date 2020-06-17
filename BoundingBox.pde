 /****************************************************************************
  * BoundingBox class:
  * Specifies the boundary where the character can not traverse in the gameworld
  * The boundaries of the character's scene.
  ****************************************************************************/
 public class BoundingBox extends GameObjectModel{
  
  /*BoundingBox field variables*/ 
  public color myColor = color (50, 50, 50);
   
  public BoundingBox(float x, float y, int h, int w) {
    myHeight = h;
    myWidth = w;
    myLoc = new PVector(x, y, 0);
  }
 
  public void display() {
    fill(myColor);
    rect(myLoc.x, myLoc.y, myWidth, myHeight);
  }
}
