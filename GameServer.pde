import java.util.*; 
import java.io.*;
import java.net.*;
import processing.net.*;

/*************************************************************************************
 * GameServer class:
 *************************************************************************************/
public class GameServer implements Runnable{          
  private String clientAddress = "";
  private PrintStream out;
  private DataInputStream in;
  private int portNumber;
  private String threadName = "";

  public GameServer() {  }

  public GameServer(String name, int port) { 
    this.threadName = name;	
    this.portNumber = port;
  }

  /***************************************
   * 
   **************************************/         
  public void run() {
    String line;
    try {
      ServerSocket ss = new ServerSocket(5222);
      System.out.println( "Waiting for connection ...");
      Socket s = ss.accept();
      clientAddress = s.getInetAddress() + "";
      System.out.println( "Connection established with " + clientAddress);
      in = new DataInputStream(s.getInputStream());
      out = new PrintStream(s.getOutputStream());
      while (true) {
        line = in.readLine();
        out.println("Server: lalalala -> "+line); 
      }
    }
    catch (IOException e) {
      System.out.println("Could not listen on port: 5005");
      System.exit(-1);
    }
    catch (Exception e) {
      System.out.println("Could not listen on port: 5005");
      System.exit(-1);
    }
  }
}





