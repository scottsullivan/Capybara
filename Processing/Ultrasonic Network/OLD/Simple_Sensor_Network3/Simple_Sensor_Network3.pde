
import processing.serial.*;
import java.util.Iterator;
import java.util.Map;

import com.rapplogic.xbee.api.ApiId;
import com.rapplogic.xbee.api.PacketListener;
import com.rapplogic.xbee.api.XBee;
import com.rapplogic.xbee.api.XBeeResponse;
import com.rapplogic.xbee.api.zigbee.ZNetExplicitRxResponse;

String version = "1.03";

// *** REPLACE WITH THE SERIAL PORT (COM PORT) FOR YOUR LOCAL XBEE ***
String mySerialPort = "/dev/tty.usbserial-A900XU05";

// create and initialize a new xbee object
XBee xbee = new XBee();

int error=0;

HashMap<String, SensorLabel> xBeeSensors = new HashMap<String, SensorLabel>();
SensorLabel s1 =  new SensorLabel(100, 100);
SensorLabel s2 =  new SensorLabel(100, 200);
SensorLabel s3 =  new SensorLabel(100, 300);


PFont font;

void setup() {

  xBeeSensors.put("00:13:a2:00:40:8c:bc:00", s1);
  xBeeSensors.put("00:13:a2:00:40:79:c2:16", s2);
  xBeeSensors.put("00:13:a2:00:40:8b:48:8c", s3);

  size(400, 400); // screen size
  smooth(); // anti-aliasing for graphic display
  font = createFont("Arial", 16, true);
  textAlign(LEFT);
  // Set the font and its size (in units of pixels)
  textFont(font, 32);
  // The log4j.properties file is required by the xbee api library, and
  // needs to be in your data folder. You can find this file in the xbee
  // api library you downloaded earlier
  PropertyConfigurator.configure(dataPath("")+"log4j.properties");
  // Print a list in case the selected one doesn't work out
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

class SensorLabel {
  XBeeSensorData xBeeData;
  String name;
  int drawX;
  int drawY;   

  public SensorLabel( int x, int y) {
    drawX = x;
    drawY = y;
  }

  void drawNumbers() {
    //check that actual data came in:
    if (xBeeData != null) {
      if (xBeeData.value !=0 && xBeeData.address != null) {
        println(xBeeData.address);
        println(xBeeData.value);
        text(xBeeData.value, drawX, drawY);
      }
    }
  }


  //public setData(XBeeSensorData data) {
  //  xBeeData = data;
  // }
}
// draw loop executes continuously
void draw() {
  background(255);
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
} // end of draw loop







