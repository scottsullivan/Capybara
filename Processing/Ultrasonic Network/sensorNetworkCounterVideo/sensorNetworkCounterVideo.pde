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
String mySerialPort = "/dev/tty.usbserial-A601EIU9";

XBee xbee = new XBee();

int error=0;

// Instanciate print writer
PrintWriter output;

HashMap<String, SensorLabel> xBeeSensors = new HashMap<String, SensorLabel>();

SensorLabel s1 =  new SensorLabel(1, 0, 0, "OUTSIDE", 450);
SensorLabel s2 =  new SensorLabel(2, 0, 100, "GIFT", 85);
SensorLabel s3 =  new SensorLabel(3, 0, 200, "WOMEN'S ONE", 65);
SensorLabel s4 =  new SensorLabel(4, 0, 300, "WOMEN'S TWO", 80);
SensorLabel s5 =  new SensorLabel(5, 0, 400, "MEN'S", 60);
SensorLabel s6 =  new SensorLabel(6, 0, 500, "UPSTAIRS", 70);

PFont font;

void setup() {
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
  xBeeSensors.put("00:13:a2:00:40:8b:67:f7", s4); //R7
  xBeeSensors.put("00:13:a2:00:40:a0:97:e5", s5); //R5
  xBeeSensors.put("00:13:a2:00:40:a4:d7:1d", s6); //R6

   // PropertyConfigurator.configure(dataPath("")+"log4j.properties");
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

void draw() {
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
  fill(#808285);
  text("To save the data, hit SHIFT + s", 20, 630);
} // end of draw loop

void keyPressed() {
  if (key == 'S') {
    output.flush();
    output.close(); // Finishes the file
    exit(); // Stops the program
  }
}

