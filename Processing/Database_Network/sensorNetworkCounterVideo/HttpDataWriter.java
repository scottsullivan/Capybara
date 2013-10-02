import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.HttpResponse;
import org.apache.http.HttpEntity;
import org.apache.http.entity.*;
import org.apache.http.util.*;
import org.json.*;
class HttpDataWriter {
  public void getStatus(String url) {
    HttpClient client = new DefaultHttpClient();
    HttpGet method = new HttpGet(url);
    HttpResponse response = null;
    HttpEntity entity = null;
    int status;
    try {
      response = client.execute(method);
      status = response.getStatusLine().getStatusCode();
      System.out.println("Status is " + status);
    } catch(Exception e) {
      e.printStackTrace();
    } finally {
      client.getConnectionManager().shutdown();
    }
  }

  public void getData(String url) {
    HttpClient client = new DefaultHttpClient();
    HttpGet method = new HttpGet(url);
    HttpResponse response = null;
    HttpEntity entity = null;
    int status;
    try {
      response = client.execute(method);
      status = response.getStatusLine().getStatusCode();
      System.out.println("Status is " + status);
      entity = response.getEntity();
      if(null != entity) {
        String body = EntityUtils.toString(entity);
        JSON obj = JSON.parse(body);
        System.out.println(obj);
      }
    } catch(Exception e) {
      e.printStackTrace();
    } finally {
      client.getConnectionManager().shutdown();
    }

  }


  public void postJSON(String url, String jsonString) {
    System.out.println("Posting to " + url);
    System.out.println(jsonString);
    HttpClient httpClient = new DefaultHttpClient();
    HttpEntity entity = null;
    try {
      HttpPost request = new HttpPost(url);

      StringEntity params =new StringEntity(jsonString);
      request.addHeader("content-type", "application/json");
      request.setEntity(params);
      HttpResponse response = httpClient.execute(request);
      entity = response.getEntity();
      if(null != entity) {
        String body = EntityUtils.toString(entity);
        JSON obj = JSON.parse(body);
        System.out.println(obj);
      }

      // handle response here...
    }catch (Exception e) {
      // handle exception here
      e.printStackTrace();
    } finally {
      httpClient.getConnectionManager().shutdown();
    }
  }

}
