
/***********************************************
 * PlatformGameEngine
 ***********************************************/

public class PlatformGameEngine extends PApplet{

  PlatformGame game;

  public void setup() {
    size(900,700);
    background(0);
    game = new PlatformGame();
    game.engine = this;
    setup();
  }

  public void draw() {
    stroke(255);
    if (mousePressed) {
      line(mouseX,mouseY,pmouseX,pmouseY);
    }
  } 

}
