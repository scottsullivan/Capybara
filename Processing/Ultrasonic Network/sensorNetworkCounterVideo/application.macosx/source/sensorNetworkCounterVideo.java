import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import java.util.Iterator; 
import java.util.Map; 
import com.rapplogic.xbee.api.ApiId; 
import com.rapplogic.xbee.api.PacketListener; 
import com.rapplogic.xbee.api.XBee; 
import com.rapplogic.xbee.api.XBeeResponse; 
import com.rapplogic.xbee.api.zigbee.ZNetExplicitRxResponse; 

import com.rapplogic.xbee.examples.wpan.*; 
import org.apache.log4j.or.*; 
import org.apache.log4j.lf5.viewer.*; 
import org.apache.log4j.varia.*; 
import com.rapplogic.xbee.examples.zigbee.*; 
import org.apache.log4j.lf5.viewer.configure.*; 
import com.rapplogic.xbee.api.*; 
import org.apache.log4j.*; 
import com.rapplogic.xbee.*; 
import org.apache.log4j.xml.*; 
import org.apache.log4j.jmx.*; 
import org.apache.log4j.lf5.*; 
import org.apache.log4j.config.*; 
import org.apache.log4j.helpers.*; 
import org.apache.log4j.chainsaw.*; 
import org.apache.log4j.or.sax.*; 
import com.rapplogic.xbee.api.zigbee.*; 
import org.apache.log4j.spi.*; 
import com.rapplogic.xbee.api.wpan.*; 
import org.apache.log4j.jdbc.*; 
import org.apache.log4j.nt.*; 
import org.apache.log4j.or.jms.*; 
import com.rapplogic.xbee.test.*; 
import org.apache.log4j.lf5.util.*; 
import org.apache.log4j.net.*; 
import com.rapplogic.xbee.examples.*; 
import org.apache.log4j.lf5.viewer.categoryexplorer.*; 
import com.rapplogic.xbee.util.*; 
import com.rapplogic.xbee.transparent.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sensorNetworkCounterVideo extends PApplet {












String version = "1.03";

// *** REPLACE WITH THE SERIAL PORT (COM PORT) FOR YOUR LOCAL XBEE ***
String mySerialPort = "/dev/tty.usbserial-A601EIU9";

XBee xbee = new XBee();

int error=0;

// Instanciate print writer
PrintWriter output;


HashMap<String, SensorLabel> xBeeSensors = new HashMap<String, SensorLabel>();
SensorLabel s1 =  new SensorLabel(0, 0, "DOOR", 75);
SensorLabel s2 =  new SensorLabel(0, 100, "GIFT", 85);
SensorLabel s3 =  new SensorLabel(0, 200, "WOMEN'S ONE", 65);
SensorLabel s4 =  new SensorLabel(0, 300, "WOMEN'S TWO", 80);
SensorLabel s5 =  new SensorLabel(0, 400, "MEN'S", 60);
SensorLabel s6 =  new SensorLabel(0, 500, "UPSTAIRS", 70);


PFont font;

public void setup() {
  size(300, 650);
  background(255);
  noStroke();
  smooth();

  output = createWriter("dataLog/" + month() + "-" + day() + "-" + year() + "/" + hour() + "-" + minute() + "-" + second() + "-" + "triggers.csv");

  font = createFont("Helvetica-Bold", 48, true);
  textAlign(LEFT);
  textFont(font, 20);

  xBeeSensors.put("00:13:a2:00:40:89:d6:0b", s1); //R1
  xBeeSensors.put("00:13:a2:00:40:8b:48:8c", s2); //R2
  xBeeSensors.put("00:13:a2:00:40:79:c2:16", s3); //R3
  xBeeSensors.put("00:13:a2:00:40:8c:bc:00", s4); //R4
  xBeeSensors.put("00:13:a2:00:40:a0:97:e5", s5); //R5
  xBeeSensors.put("00:13:a2:00:40:a4:d7:1d", s6); //R6

    PropertyConfigurator.configure(dataPath("")+"log4j.properties");
  println("Available serial ports:");
  println(Serial.list());
  try {
    // opens your serial port defined above, at 9600 baud
    xbee.open(mySerialPort, 9600);
  }
  catch (XBeeException e) {
    println("** Error opening XBee port: " + e + " **");
    println("Is your XBee plugged in to your computer?");
    println("Did you set your COM port in the code near line 20?");
    error=1;
  }
}

public void draw() {
  fill(0);
  // report any serial port problems in the main window
  if (error == 1) {
    fill(0);
    text("** Error opening XBee port: **\n"+
      "Is your XBee plugged in to your computer?\n" +
      "Did you set your COM port in the code near line 20?", width/3, height/2);
  }

  XBeeSensorData data = new XBeeSensorData(); // create a data object
  data = getData(false); // put data into the data object
  if ((data != null) && (data.address != null)) {
    xBeeSensors.get(data.address).xBeeData = data;
  }



  Iterator i = xBeeSensors.entrySet().iterator();  // Get an iterator

    while (i.hasNext ()) {
    Map.Entry me = (Map.Entry)i.next();
    SensorLabel l = (SensorLabel) me.getValue();
    l.drawNumbers();
  }
  
  fill(255);
  rect(0, 600, 300, 100);
 
  textFont(font, 15);
  fill(0xff808285);
  text("To save the data, hit SHIFT + s", 20, 630);
} // end of draw loop




public void keyPressed() {
  if (key == 'S') {
    output.flush();
    output.close(); // Finishes the file
    exit(); // Stops the program
  }
}

public boolean isSomeoneThere(int currentSensorReading, int triggerThreshold) {
  return currentSensorReading <= triggerThreshold;
}

public void updateCounterDrawing(int moveCount, int sensorOut, int moveX, int moveY, String name) {
  fill(255);
  rect(moveX, moveY, 210, 100);
  fill(0xffe6e7e8);
  rect(moveX, moveY + 35, 124, 30);
  fill(0xff58595b);
  textFont(font, 15);
  text(name, moveX + 8, moveY + 55);

  fill(0xff808285);
  text("count", moveX + 149, moveY + 38);

  fill(0xff58595b);
  textFont(font, 30);
  text(moveCount, moveX + 149, moveY + 68);
}

public void updateSensorOutput(int moveX, int moveY, int sensorOut) {
  fill(255);
  rect(moveX + 210, moveY, 90, 100);

  textFont(font, 15);
  fill(0xff808285);
  text("reading", moveX + 222, moveY + 38);

  fill(0xff58595b);
  textFont(font, 30);
  text(sensorOut, moveX + 222, moveY + 68);
}

class SensorLabel {
  XBeeSensorData xBeeData;
  String name;
  int drawX;
  int drawY;
  int trigger;
  int moveCount = 0;
  boolean bodyPreviouslyThere = false;

  public SensorLabel( int x, int y, String sensorName, int threshold) {
    drawX = x;
    drawY = y;
    name = sensorName;
    trigger = threshold;
  }

  public void drawNumbers() {
    //check that actual data came in:
    if (xBeeData != null) {
      if (xBeeData.value !=0 && xBeeData.address != null) {
        println(xBeeData.address);
        println(xBeeData.value);
        updateSensorOutput(drawX, drawY, xBeeData.value);
        //text(xBeeData.value, drawX, drawY);
        int sensorOut = xBeeData.value;

        //condition2
        // if there was *just* a body there but now it's gone
        if (bodyPreviouslyThere && !isSomeoneThere(sensorOut, trigger)) {
          moveCount++; 

          updateCounterDrawing(moveCount, sensorOut, drawX, drawY, name);
          output.println(month() + "/" + day() + "/" + year() + "," + hour() + ":" + minute() + ":" + second() + "," + xBeeData.address);

          bodyPreviouslyThere = false;
        }

        //condition1
        // if there wasn't a body there but now there is!
        if (!bodyPreviouslyThere && isSomeoneThere(sensorOut, trigger)) {
          bodyPreviouslyThere = true;
        }
        //updateSensorDrawing(sensorOut);
      }
    }
  }
}
// defines the data object
class XBeeSensorData {
  int value;
  String address;
}


// queries the XBee for incoming I/O data frames
// and parses them into a data object

public XBeeSensorData getData(boolean diagnostics) {

  XBeeSensorData data = new XBeeSensorData();
  String value = "";      // returns an impossible value if there's an error
  String address = ""; // returns a null value if there's an error

  try {
    // we wait here until a packet is received.
    XBeeResponse response = xbee.getResponse();
    // uncomment next line for additional debugging information
    //println("Received response " + response.toString());

    // check that this frame is a valid I/O sample, then parse it as such
    if (response.getApiId() == ApiId.ZNET_RX_RESPONSE
      && !response.isError()) {
      ZNetRxResponse rxResponse =
        (ZNetRxResponse)(XBeeResponse) response;
        if (diagnostics) {
          println("cast response is " +rxResponse.toString());
        }
      // get the sender's 64-bit address
      int[] addressArray = rxResponse.getRemoteAddress64().getAddress();
      // parse the address int array into a formatted string
      String[] hexAddress = new String[addressArray.length];
      for (int i=0; i<addressArray.length;i++) {
        // format each address byte with leading zeros:
        hexAddress[i] = String.format("%02x", addressArray[i]);
      }

      // join the array together with colons for readability:
      String senderAddress = join(hexAddress, ":");
      //println("Sender address: " + senderAddress);
      data.address = senderAddress;


      //ByteUtils is a class provided by arduino-api to make working with
      //Xbee response data a little easier.
      value = ByteUtils.toString(rxResponse.getData());
      String correctedValue = value.substring(0, value.length() - 1);
      //println("Data: " + value);
      data.value = Integer.parseInt(correctedValue);
    }
    else if (!response.isError()) {
      //println("Got error in data frame");
    }
    else {
      println("Data frame wasn't of the expected type.");
    }
  }
  catch (XBeeException e) {
    println("Error receiving response: " + e);
  }
  return data; // sends the data back to the calling function
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sensorNetworkCounterVideo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
