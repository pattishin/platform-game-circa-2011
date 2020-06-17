/*************************************************************************************
 * GameLogger class:
 * Game logging subsystem of Event Manager
 * Registers itself with the manager to recieve log messages
 * by other objects or subsystems and writes them to a text file
 *************************************************************************************/
public class GameLogger{

  /*GameLogger field variables*/
  private PrintWriter output = null;

  public GameLogger(){ }

  public void printToFile(String logToRecord){
    try {
      output = new PrintWriter(new BufferedWriter(new FileWriter("logMessageOutput.txt", true))); // true means: "append"
      output.println(logToRecord);
    } 
    catch (IOException e) { System.out.println("IO Exception caught"); }
    finally {  if(output != null){ output.flush(); output.close(); } }
  }
}
