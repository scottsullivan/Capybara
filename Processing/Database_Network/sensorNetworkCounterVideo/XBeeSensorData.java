import processing.serial.*;

import processing.core.*;
import com.rapplogic.xbee.api.ApiId;
import com.rapplogic.xbee.api.PacketListener;
import com.rapplogic.xbee.api.XBee;
import com.rapplogic.xbee.api.*;
import com.rapplogic.xbee.api.XBeeResponse;
import com.rapplogic.xbee.api.zigbee.ZNetExplicitRxResponse;
import com.rapplogic.xbee.api.zigbee.*;
import com.rapplogic.xbee.util.*;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

// defines the data object
public class XBeeSensorData {
  public int value;
  public String address;
  public String time;

  static XBee xbee = new XBee();
  static DateFormat timeStampFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
  public static PApplet host;

  public void setTimeStamp() {
    Date date = new Date();
    this.time = timeStampFormat.format(date);
  }

  public String getTimeStamp() {
    return this.time;
  }

  public int getValue() {
    return this.value;
  }

  public static int setupSerialPort(String mySerialPort) {
     // PropertyConfigurator.configure(dataPath("")+"log4j.properties");
    System.out.println("Available serial ports:");
    System.out.println(Serial.list());
    try {
      // opens your serial port defined above, at 9600 baud
      xbee.open(mySerialPort, 9600);
      return 0;
    }
    catch (XBeeException e) {
      System.out.println("** Error opening XBee port: " + e + " **");
      System.out.println("Is your XBee plugged in to your computer?");
      e.printStackTrace();
      return 1;
    }
  }

  // queries the XBee for incoming I/O data frames
  // and parses them into a data object
  public static XBeeSensorData getData(boolean diagnostics) {

    XBeeSensorData data = new XBeeSensorData();
    String value = "";      // returns an impossible value if there's an error
    String address = ""; // returns a null value if there's an error

    try {
      // we wait here until a packet is received.
      XBeeResponse response = xbee.getResponse();
      // uncomment next line for additional debugging information
      //System.out.println("Received response " + response.toString());

      // check that this frame is a valid I/O sample, then parse it as such
      if (response.getApiId() == ApiId.ZNET_RX_RESPONSE
        && !response.isError()) {
        ZNetRxResponse rxResponse =
          (ZNetRxResponse)(XBeeResponse) response;
          if (diagnostics) {
            System.out.println("cast response is " +rxResponse.toString());
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
        String senderAddress = host.join(hexAddress, ":");
        data.address = senderAddress;


        //ByteUtils is a class provided by arduino-api to make working with
        //Xbee response data a little easier.
        value = ByteUtils.toString(rxResponse.getData());
        String correctedValue = value.substring(0, value.length() - 1);
        //System.out.println("Data: " + value);
        data.value = Integer.parseInt(correctedValue);
	data.setTimeStamp();
      }
      else if (!response.isError()) {
        //System.out.println("Got error in data frame");
      }
      else {
        System.out.println("Data frame wasn't of the expected type.");
      }
    }
    catch (XBeeException e) {
      System.out.println("Error receiving response: " + e);
    }
    return data; // sends the data back to the calling function
  }

  public static XBeeSensorData getData() {
    return XBeeSensorData.getData(false);
  }
}
