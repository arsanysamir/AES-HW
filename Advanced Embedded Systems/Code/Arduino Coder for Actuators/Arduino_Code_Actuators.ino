#include <Servo.h> //Die Servobibliothek wird aufgerufen. Sie wird benötigt, damit die Ansteuerung des Servos vereinfacht wird.
#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "arduino_secrets_actuators.h"

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);
const char broker[] = "10.42.0.1";
int        port     = 1883;
const char topic[]  = "Voltage";
const char topic2[]  = "Temperature";
const char topic3[]  = "Current";

//set interval for sending messages (milliseconds)
const long interval = 4000;
unsigned long previousMillis = 0;

int count = 0;

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;
String currentTopic;
Servo servoblau; //Erstellt für das Programm ein Servo mit dem Namen „servoblau“

const int buzzer = 9;

#define redLED 7
#define greenLED 8

float voltage= 0;
float temperature= 0;
float current = 0;
String readstring;

char mqttMessage;
String mqttString;
float finalvalue;

bool doorlock = false;

void setup()
{

Serial.begin(9600);

  // attempt to connect to Wifi network:
  Serial.print("Attempting to connect to SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
    // failed, retry
    Serial.print(".");
    delay(5000);
  }

delay(1000);

Serial.println("You're connected to the network");
Serial.println();

Serial.print("Attempting to connect to the MQTT broker: ");
Serial.println(broker);

  if (!mqttClient.connect(broker, port)) {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());

    while (1);
  }

  Serial.println("You're connected to the MQTT broker!");
  Serial.println();
  // set the message receive callback
  mqttClient.onMessage(onMqttMessage);

  Serial.print("Subscribing to topic: ");
  Serial.println(topic);
  Serial.println();

  // subscribe to a topic
  mqttClient.subscribe(topic);
  mqttClient.subscribe(topic2);
  mqttClient.subscribe(topic3);

  // topics can be unsubscribed using:
  // mqttClient.unsubscribe(topic);

  Serial.print("Topic: ");
  Serial.println(topic);
  Serial.print("Topic: ");
  Serial.println(topic2);
  Serial.print("Topic: ");
  Serial.println(topic3);

  Serial.println();

servoblau.attach(6); //Das Setup enthält die Information, dass das Servo an der Steuerleitung (gelb) mit Pin 8 verbunden wird. Hier ist natürlich auch ein anderer Pin möglich.
pinMode(buzzer, OUTPUT);
pinMode(greenLED, OUTPUT);
pinMode(redLED, OUTPUT);

digitalWrite(greenLED, HIGH);

}

 

void loop()

{ //Im „loop“ wird über den write-Befehl „servoblau.write(Grad)“ das Servo angesteuert. Zwischen den einzelnen Positionen gibt es eine Pause, damit das Servo genug Zeit hat, die gewünschten Positionen zu erreichen.

  mqttClient.poll();

  if(Serial.available())
    {
      readstring = "";
      delay(1);
      char c = Serial.read();
      readstring += c;
    }

  if (readstring == "m")
  {
    if (doorlock == false)
    {
      servoblau.write(0); //Position 1 ansteuern mit dem Winkel 0°
      doorlock = true;
    }
    else
    {
      servoblau.write(180); //Position 3 ansteuern mit dem Winkel 180°
      doorlock = false;
    }

    Serial.println("Motor running");
  }
  
  if (voltage > 5 || temperature > 90)
  {
    alarm();
    digitalWrite(greenLED,LOW);
    digitalWrite(redLED,HIGH);

  }
  else
  {
    noTone(buzzer);
    digitalWrite(greenLED,HIGH);
    digitalWrite(redLED,LOW);
  }

  if (readstring == "r") //reset TEST delete later
  {
    voltage = 0;
    temperature = 0;
  }

  if (readstring == "a") //Set TEST delete later
  {
    voltage = 100;
    temperature = 100;
  }

}

void alarm()
{
  tone(buzzer, 1000); // Sende 1KHz Tonsignal
}

void onMqttMessage(int messageSize) {
  // we received a message, print out the topic and contents
  Serial.println("Received a message with topic '");
  currentTopic = mqttClient.messageTopic();
  Serial.println(currentTopic);
  Serial.print("', length ");
  Serial.print(messageSize);
  Serial.println(" bytes:");
  mqttString = "";

  // use the Stream interface to print the contents
  while (mqttClient.available()) {
    // Serial.print((char)mqttClient.read());
    mqttMessage = (char)mqttClient.read();
    mqttString += (mqttMessage);
    
  }
  finalvalue = mqttString.toFloat();
  Serial.println(finalvalue);

  if (currentTopic == "Voltage")
  {
    voltage = finalvalue;
  }
  else if (currentTopic == "Current")
  {
    current = finalvalue;
  }
  else if (currentTopic == "Temperature")
  {
    temperature = finalvalue;
  }

  Serial.println();
  Serial.println();
}
