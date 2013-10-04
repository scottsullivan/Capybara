import java.io.File;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

class CsvDataWriter implements DataAdapter {
  File file;
  FileWriter fw;
  BufferedWriter bw;
  String filePath;
  int readingBufferSize = 2;
  int writtenCount = 0;

  /**
   *  CsvDataWriter will save its files relative to the current sketch path
   *
   *  @filePrefix could be a directory name, ie "dataLog/" or any other valid path
   *  @filePostfix will be added to the file path after the date
   *  @addDateToFile will add the date in yyyy-MM-dd/HH-mm-ss format based on when the sketch started.
   *  if true, the path will be 'prefix + date + postfix'
   *  if false, the file path will look like 'prefix + postfix'.
   */
  public CsvDataWriter(String filePrefix, String filePostfix, Boolean addDateToFile) {
    filePath = createFilePath(filePrefix, filePostfix, addDateToFile);
    println("Creating log file at: " + filePath);
    try{
    		file = new File(filePath);
        file.getParentFile().mkdirs();

    		//if file doesnt exists, then create it
    		if(!file.exists()){
    			file.createNewFile();
    		}

    		//true = append file
        fw = new FileWriter(file.getAbsolutePath(),true);
        bw = new BufferedWriter(fw);

    	}catch(IOException e){
    		e.printStackTrace();
    	}
  }

  public void close() {
    try{
      bw.flush();
      bw.close();
    }catch(IOException e){
      e.printStackTrace();
    }
  }

  public void saveReading(SensorReading r) {
    writeData(r.toCSV());
  }

  private void writeData(String data) {
    try{
      println("Writing data: " + data);
      bw.write(data);
      bw.newLine();
      writtenCount++;
      String toFormat = "Writing %s/%s lines before flushing.";
      println(String.format(toFormat, writtenCount, readingBufferSize));
      if (writtenCount > readingBufferSize) {
        flushBuffer();
        writtenCount = 0;
      }
    }catch(IOException e){
      e.printStackTrace();
    }
  }

  //sketchPath() is a processing method
  private String createFilePath(String prefix, String postfix, Boolean addDateToFile) {
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd/HH-mm-ss");
    Date date = new Date();
    if (addDateToFile) {
      return sketchPath("") + prefix + dateFormat.format(date) + postfix;
    } else {
      return sketchPath("") + prefix + postfix;
    }
  }

  private void flushBuffer() {
    try{
      println("Flushing buffer");
      bw.flush();
    }catch(IOException e){
      e.printStackTrace();
    }
  }

}
