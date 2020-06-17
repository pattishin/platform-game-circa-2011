import java.util.*; 
/*************************************************************************************
 * GameTimeline class:
 *************************************************************************************/
public class GameTimeline {

  private ArrayList pastMovements;
  private HashMap positions2Replay; 


  public GameTimeline(){
    pastMovements = new ArrayList();
    positions2Replay = new HashMap();
  }

  /***************************************
   * Add Positions 2 Timeli
   **************************************/
  public void addPosition2Timeline(String guid, PVector position){
    pastMovements.add(position);
    positions2Replay.put(guid, position);
  }

  /***************************************
   * Slow Down
   **************************************/
  public ArrayList slowDownByHalfSpeed(){
    ArrayList slow = new ArrayList();
    Object [] pastPos = pastMovements.toArray();
    for(int i = 0; i< pastPos.length; i++){
      slow.add(pastPos[i]); 
      slow.add(pastPos[i]);
    }
    return slow;
  }

  /***************************************
   * Speed Up By 2
   **************************************/
  public ArrayList speedUpByTwo(){
    ArrayList speed = new ArrayList();
    Object [] pastPos = pastMovements.toArray();
    for(int i = 0; i< pastPos.length; i++){
      if((i%2)==0) speed.add(pastPos[i]); 
    }
    return speed;

  }

  /***************************************
   * Normal Speed
   **************************************/
  public ArrayList normalSpeed(){
    return pastMovements;
  }
}
