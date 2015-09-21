import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;

class HueLighting implements LightingInterface
{
  private ArrayList<LightInterface> lights;
  
  HueLighting()
  {
    this.lights = new ArrayList<LightInterface>();
  }
  
  public void add(LightInterface light)
  {
    this.lights.add(light);
  }
  
  public void remove(int id)
  {
    this.lights.remove(id - 1);
  }
  
  public void on()
  {
    for(int i = 0; i < lights.size(); i++) {
      LightInterface light = lights.get(i);
      light.on();
    }
  }
  
  public void on(int id)
  {
    LightInterface light = lights.get(id - 1);
    light.on();
  }
  
  public void off()
  {
    for(int i = 0; i < lights.size(); i++) {
      LightInterface light = lights.get(i);
      light.off();
    }
  }
  
  public void off(int id)
  {
    LightInterface light = lights.get(id - 1);
    light.off();
  }
  
  public void brightness(int brightness)
  {
    for(int i = 0; i < lights.size(); i++) {
      LightInterface light = lights.get(i);
      light.brightness(brightness);
    }
  }
  
  public void brightness(int id, int brightness)
  {
    LightInterface light = lights.get(id - 1);
    light.brightness(brightness);
  }

  public void brightness(int id, int brightness, int transitionSpeed)
  {
    LightInterface light = lights.get(id - 1);
    light.brightness(brightness, transitionSpeed);
  }
}

class HueLight implements LightInterface
{
  private String user = "newdeveloper";
  private int id;
  private int brightness;
  private String url;
  
  public String name = "";

  HueLight(String _name, int _id) 
  {
    this.name = _name;
    this.id = _id;
    this.url = this.setUrl(this.getBridgeIp(), this.user, this.id);
  }
  
  private String setUrl(String bridgeIp, String user, int _id)
  {
    return "http://" + bridgeIp + "/api/" + user + "/lights/" + _id + "/state";
  }
  
  private String status()
  {
    return loadStrings(this.url.substring(0, (this.url.length() - 6)))[0];
  }

  public int brightness() 
  {
    return this.brightness;
  }

  public void brightness(int value) 
  {
    value = value > 255 ? 255 : value;
    value = value < 0 ? 0 : value; 
    this.command("{\"bri\": " + value + "}");
    this.brightness = value;
  }

  public void brightness(int value, int transitionSpeed) {
    value = value > 255 ? 255 : value;
    value = value < 0 ? 0 : value; 
    this.command("{\"bri\": " + value + ", \"transitiontime\": " + transitionSpeed + "}");
    this.brightness = value;
  }

  boolean isOn() {
    String response = this.status();
    if ( response != null ) {
      JSONObject root = new JSONObject();
      root = root.parse(response);
      JSONObject condition = root.getJSONObject("state");
      boolean isOn = condition.getBoolean("on");
      println("Light " + id + " on = " + isOn);
      return isOn;
    }
    return false;
  }
  
  public void toggle() {
    this.command("{\"on\": " + !this.isOn() + "}");
  }
  
  public void on() {
    this.command("{\"on\": " + true + "}");
  }
  
  public void off() {
    this.command("{\"on\": " + false + "}");
  }
  
  private void command(String command) 
  {
    try
    {
      HttpPut httpPut = new HttpPut(this.url);
      DefaultHttpClient httpClient = new DefaultHttpClient();

      httpPut.addHeader("Accept", "application/json");
      httpPut.addHeader("Content-Type", "application/json");

      StringEntity entity = new StringEntity(command, "UTF-8");
      entity.setContentType("application/json");
      httpPut.setEntity(entity); 

      HttpResponse response = httpClient.execute(httpPut);
    } 
    catch( Exception e ) { 
      e.printStackTrace();
    }
  }
  
  private String getBridgeIp() 
  {
    try
    {
      HttpGet httpGet = new HttpGet("https://www.meethue.com/api/nupnp");                               
      DefaultHttpClient httpClient = new DefaultHttpClient();
      httpGet.addHeader("Accept", "application/json");                  
      httpGet.addHeader("Content-Type", "application/json");
      HttpResponse response = httpClient.execute(httpGet);

      String body = "{\"source\":" + EntityUtils.toString(response.getEntity()) + "}";
      JSONObject parsed = JSONObject.parse(body);
      JSONArray array = parsed.getJSONArray("source");
      JSONObject result = array.getJSONObject(0);
      String ip = result.getString("internalipaddress");

      return ip;
    } 
    catch( Exception e ) {
      println("Unable to find Hue Bridge on local network.");
      e.printStackTrace();
      return "";
    }
  }
}

