 /****************************************************************************
  * DeathZone class:
  * Specifies the boundary where the character would be considered "dead" and
  * lets calling class know to re-generate character at spawn location.
  ****************************************************************************/
 public class DeathZone extends GameObjectModel{
   
  /*DeathZone field variables*/
  private color myColor = color (120, 0, 0);
  public PVector myLocStart;
  public PVector myLocFinish;

  public DeathZone(float startX, float startY, float finishX, float finishY) {
    myLocStart = new PVector (startX, startY, 0);
    myLocFinish = new PVector (finishX, finishY, 0);
  }

  public boolean zoneEntered(float objectX, float objectY, float objectHeight, float objectWidth){
    if(objectY >= myLocStart.y){
      //character has died, re-generate same character through spawn point
      return true;
    }
    return false;
  }

  public void display() {
    fill(myColor);
    rect(myLocStart.x, myLocStart.y, myLocFinish.x, myLocFinish.y+20);
    fill(255);
    text("X-X-X-X-X DEATH ZONE X-X-X-X-X", width-300, myLocStart.y+20);
  }
 }

