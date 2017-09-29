#include <DHT.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

#define DHTPIN        13      //D7
#define DHTPIN_2      12      //D6
#define DHTTYPE DHT11

#define BUT1_PIN      0       //D3
#define BUT2_PIN      14      //D5

#define RELAY_1_PIN   4       //D2
#define RELAY_2_PIN   5       //D1

// Update these with values suitable for your network.
#define ssid "KyThuatTuhu"
#define password "mualinhkien.vn"

#define mqtt_server "m13.cloudmqtt.com"
#define mqtt_topic "control"
#define mqtt_user "esp8266"
#define mqtt_pwd "esp8266"
const uint16_t mqtt_port = 13910;


unsigned char rl1_status = 0;
unsigned char rl2_status = 0;
unsigned char count = 0;

unsigned char t1, h1, t2, h2, last_t1, last_h1, last_t2, last_h2;

DHT dht(DHTPIN, DHTTYPE);
DHT dht2(DHTPIN_2, DHTTYPE); 
WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];
int value = 0;

void setup() {
  pinMode(RELAY_1_PIN, OUTPUT);
  pinMode(RELAY_2_PIN, OUTPUT);
  digitalWrite(RELAY_1_PIN, HIGH);
  digitalWrite(RELAY_2_PIN, HIGH);
  pinMode(BUT1_PIN, INPUT_PULLUP);
  pinMode(BUT2_PIN, INPUT_PULLUP);
  dht.begin();
  dht2.begin();
  //Serial.begin(115200);
  //Serial.println("Initializing...");
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void setup_wifi() {
  delay(10);
  // We start by connecting to a WiFi network
  //Serial.println();
  //Serial.print("Connecting to ");
  //Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    //Serial.print(".");
  }
  //Serial.println("");
  //Serial.println("WiFi connected");
  //Serial.println("IP address: ");
  //Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  //Serial.print("Message arrived [");
  //Serial.print(topic);
  //Serial.print("] ");
  //for (int i = 0; i < length; i++) {
  //  Serial.print((char)payload[i]);
  //}
  //Serial.println();

  String str = (char*) (payload);
  if (str.indexOf("RL1 ON") != -1)
  {
    rl1_status = 0;
  }
  else if (str.indexOf("RL1 OFF") != -1)
  {
    rl1_status = 1;
  }
  else if (str.indexOf("RL2 ON") != -1)
  {
    rl2_status = 0;
  }
  else if (str.indexOf("RL2 OFF") != -1)
  {
    rl2_status = 1;
  }
  else if (str.indexOf("Start") != -1)
  {
    h1 = dht.readHumidity();   
    t1 = dht.readTemperature();
    h2 = dht2.readHumidity(); 
    t2 = dht2.readTemperature();

    snprintf(msg, 75, "Res, %u, %u, %u, %u, %u, %u", t1, h1, t2, h2, rl1_status, rl2_status);
    client.publish(mqtt_topic, msg);
  }
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    //Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP8266Client",mqtt_user, mqtt_pwd)) {
      //Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish(mqtt_topic, "ESP_reconnected");
      // ... and resubscribe
      client.subscribe(mqtt_topic);
    } else {
      //Serial.print("failed, rc=");
      //Serial.print(client.state());
      //Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}
void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  long now = millis();  
  if (now - lastMsg > 50) {
    lastMsg = now;
    if (digitalRead(BUT1_PIN) == 0)
    {
      while (digitalRead(BUT1_PIN) == 0) {}
      if (rl1_status == 0)
      {
        rl1_status = 1;
        snprintf(msg, 75, "Rel, 1, 1");
        client.publish(mqtt_topic, msg);
      }
      else
      {
        rl1_status = 0;
        snprintf(msg, 75, "Rel, 1, 0");
        client.publish(mqtt_topic, msg);
      }
    }
    if (digitalRead(BUT2_PIN) == 0)
    {
      while (digitalRead(BUT2_PIN) == 0) {}
      if (rl2_status == 0)
      {
        rl2_status = 1;
        snprintf(msg, 75, "Rel, 2, 1");
        client.publish(mqtt_topic, msg);
      }
      else
      {
        rl2_status = 0;
        snprintf(msg, 75, "Rel, 2, 0");
        client.publish(mqtt_topic, msg);
      }
    }
  
    if (rl1_status == 0)
      digitalWrite(RELAY_1_PIN, HIGH);
    else
      digitalWrite(RELAY_1_PIN, LOW);
  
    if (rl2_status == 0)
      digitalWrite(RELAY_2_PIN, HIGH);
    else
      digitalWrite(RELAY_2_PIN, LOW); 

    count++;
    if (count >= 20)
    {  
      count = 0;
      h1 = dht.readHumidity();   
      t1 = dht.readTemperature();
      h2 = dht2.readHumidity(); 
      t2 = dht2.readTemperature();

      if ((h1 != last_h1)||(t1 != last_t1)||(h2 != last_h2)||(t2 != last_t2))
      {
        last_h1 = h1;
        last_t1 = t1;
        last_h2 = h2;
        last_t2 = t2;
        snprintf(msg, 75, "Sen, %u, %u, %u, %u", t1, h1, t2, h2);
        client.publish(mqtt_topic, msg);
      }
    }
  }
  
}
