/*************************************************************************************
 * GameObjectModel class:
 * Base object class for game object model (object-oriented) platform game
 *************************************************************************************/
public class GameObjectModel {
  
  /*GameObjectModel field variables*/
  public String GUID = "";
  public String myEventName = "";
  public int myHeight;
  public int myWidth;
  public PVector myLoc;
  public boolean eventHappened = false;

  public void setMyGUID(String guid){
    GUID = guid;
  }
   
  public String getMyGUID(){
    return GUID;
  }
  
  public void eventListener(String event){
    System.out.println("I am: " + GUID + " and got your message about: " + event);
  }
  
  public void setEventName(String event){
      this.myEventName = event;
  } 
    
  public boolean eventOccurance(){
      return eventHappened;
  } 
  
  public void reset(){
     eventHappened = false; 
  }
}
