// defines the data object
class XBeeSensorData {
  int value;
  String address;
}

// queries the XBee for incoming I/O data frames
// and parses them into a data object

XBeeSensorData getData(boolean diagnostics) {

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
