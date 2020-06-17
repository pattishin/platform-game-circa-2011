
/*************************************************************************************
 * Obstacle class:
 * creates box-like obstacles that can be used as potential obstacles or as platforms
 *************************************************************************************/
public class Obstacle extends GameObjectModel{

  /*Obstacle field variables*/
  public float myNum;
  public int myParentNum = -1; //default -1 if wasn't assigned one
  public color myColor = color(127, 0, 0);
  public int sideThatWasHit = 0;


  /***************************************
   * 
   **************************************/  
  public Obstacle(int num, float x, float y, int h, int w, int parentNum) {
    myNum = num;
    myHeight = h;
    myWidth = w;
    myLoc = new PVector(x, y, 0);
    myParentNum = parentNum; 
  }

  /***************************************
   * Check if this obstacle has been bumped into by another object
   **************************************/
  public boolean hasCollided(float objectX, float objectY, float objectRadWidth, float objectRadHeight){
    //Manages collisions from the sides of the ellipse (more realistic) 
    if(((objectX+objectRadWidth) >= myLoc.x) && ((objectX+objectRadWidth) < (myWidth+myLoc.x))){
      if(((objectY+objectRadHeight) >= myLoc.y) && ((objectY+objectRadHeight) < (myHeight+myLoc.y))){
        sideThatWasHit = 1;
        return true;
      }
    }
    if(((objectX-objectRadWidth) >= myLoc.x) && ((objectX-objectRadWidth) < (myWidth+myLoc.x))){
      if(((objectY+objectRadHeight) >= myLoc.y) && ((objectY+objectRadHeight) < (myHeight+myLoc.y))){
        sideThatWasHit = 2;
        return true;
      }
    }
    if(((objectX+objectRadWidth) >= myLoc.x) && ((objectX+objectRadWidth) < (myWidth+myLoc.x))){
      if(((objectY-objectRadHeight) >= myLoc.y) && ((objectY-objectRadHeight) < (myHeight+myLoc.y))){
        sideThatWasHit = 3;
        return true;
      }
    }
    if(((objectX-objectRadWidth) >= myLoc.x) && ((objectX-objectRadWidth) < (myWidth+myLoc.x))){
      if(((objectY-objectRadHeight) >= myLoc.y) && ((objectY-objectRadHeight) < (myHeight+myLoc.y))){
        sideThatWasHit = 4;
        return true;
      }
    }

    return false;
  }

  /***************************************
   * 
   **************************************/
  public void display( ) {      
    fill(255);
    ellipse(myLoc.x, myLoc.y, 15, 15);
    fill(myColor);
    rect(myLoc.x, myLoc.y, myWidth, myHeight);
    fill(color(50, 50, 50));
    rect(myLoc.x+4, myLoc.y+4, myWidth-8, myHeight-8);

    fill(0);
    text(""+myNum + ": ("+myLoc.x+", " + myLoc.y+")" , myLoc.x, myLoc.y);
  }
}
