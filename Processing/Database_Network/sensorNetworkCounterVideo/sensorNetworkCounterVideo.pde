import processing.core.*;
import processing.serial.*;
String version = "1.03";

int error=0;

PFont font;

SensorDataStore store;
SensorDataWebAdapter web;
CsvDataWriter csv;

void setup() {
  size(300, 650);
  background(255);
  noStroke();
  smooth();

  XBeeSensorData.host = this;

  XBeeSensor s1 = XBeeSensor.registerSensor(1, "OUTSIDE", "00:13:a2:00:40:89:d6:0b", 450);
  XBeeSensor s2 = XBeeSensor.registerSensor(2, "GIFT", "00:13:a2:00:40:8b:48:8c", 85);
  XBeeSensor s3 = XBeeSensor.registerSensor(3, "WOMEN'S ONE", "00:13:a2:00:40:79:c2:16", 65);
  XBeeSensor s4 = XBeeSensor.registerSensor(4, "WOMEN'S TWO", "00:13:a2:00:40:8c:bc:00", 80);
  XBeeSensor s5 = XBeeSensor.registerSensor(5, "MEN'S", "00:13:a2:00:40:a0:97:e5", 60);
  XBeeSensor s6 = XBeeSensor.registerSensor(6, "UPSTAIRS", "00:13:a2:00:40:a4:d7:1d", 70);

  new SensorLabel(0, 0, s1);
  new SensorLabel(0, 100, s2);
  new SensorLabel(0, 200, s3);
  new SensorLabel(0, 300, s4);
  new SensorLabel(0, 400, s5);
  new SensorLabel(0, 500, s6);

  store = new SensorDataStore();
  web = new SensorDataWebAdapter("http://mysterious-plains-9032.herokuapp.com", "522e2c99708615956a000002", "p3fxbdUx6EmXKue9dgf8");
  csv = new CsvDataWriter("testlog/","log.csv",true);
  store.addAdapter(web);
  store.addAdapter(csv);
  store.monitorSensors(s1, s2, s3, s4, s5, s6);

  error = XBeeSensorData.setupSerialPort("/dev/tty.usbserial-A601EIU9");

  font = createFont("Helvetica-Bold", 48, true);
  textAlign(LEFT);
  textFont(font, 20);

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

  updateSensorData();

  fill(255);
  rect(0, 600, 300, 100);

  textFont(font, 15);
  fill(#808285);
  text("To save the data, hit SHIFT + s", 20, 630);
} // end of draw loop

void updateSensorData() {
  XBeeSensorData data = XBeeSensorData.getData(); // create a data object
  XBeeSensor.update(data);
}
