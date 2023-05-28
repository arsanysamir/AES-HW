#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "arduino_secrets.h"


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

float V1 = 0.00;

int ThermistorPin = A1;
int Vo;
float R1 = 10000; // value of R1 on board
float logR2, R2, T;
float c1 = 0.001129148, c2 = 0.000234125, c3 = 0.0000000876741; //steinhart-hart coeficients for thermistor


int Sensor = A2; // Der Stromstärkesensor wird am Pin A0 (Analog "0") angeschlossen.
int VpA = 66; // Millivolt pro Ampere (100 für 20A Modul und 66 für 30A Modul)
int sensorwert= 0;
int Nullpunkt = 2500; // Spannung in mV bei dem keine Stromstärke vorhanden ist
double SensorSpannung = 0;
double Ampere = 0;

#define voltmeasure A0

#define redLED 9
#define greenLED 8


void VOLT1()
{
  // Measuring up to 17.5 Volts with this Resistor Set-up

  float R1 = 10000;
  float R2 = 4000;
  float v_ref = 5;
  float resistor_ratio = 0;
  float adc_value = 0;
  float voltage = 0;
  resistor_ratio = (R2/(R1+R2));

  for (int i = 0; i<20; i++)
  {
    adc_value = adc_value + analogRead(voltmeasure);
    
    delay(1);
  }

  adc_value = adc_value/20;
  voltage = ((adc_value* v_ref) / 1024);

  // Serial.print("\nADC Voltage CH1VOLT =");
  // Serial.print(voltage);
  // Serial.print("\n\n");

  V1 = voltage/ resistor_ratio;

}

void setup() {

  

  Serial.begin(9600);

  pinMode(greenLED, OUTPUT);
  pinMode(redLED, OUTPUT);

  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
    // failed, retry
    Serial.print(".");
    delay(5000);
  }
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

}

void loop() {

  mqttClient.poll();
  VOLT1();

  // Serial.print("\nVoltage = ");
  // Serial.print(V1);
  // Serial.println("V");

  delay(100);

  if (V1 < 5 && (T < 30))
  {
    digitalWrite(greenLED, HIGH);
    digitalWrite(redLED, LOW);
  }
  else
  {
    digitalWrite(greenLED,LOW);
    digitalWrite(redLED, HIGH);
  }

  Vo = analogRead(ThermistorPin);
  R2 = R1 * (1023.0 / (float)Vo - 1.0); //calculate resistance on thermistor
  logR2 = log(R2);
  T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2)); // temperature in Kelvin
  T = T - 273.15; //convert Kelvin to Celcius
 // T = (T * 9.0)/ 5.0 + 32.0; //convert Celcius to Farenheit
  // Serial.print("Temperature: "); 
  // Serial.print(T);
  // Serial.println(" C\n\n");

  CurrentSense(); 

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    // save the last time a message was sent
    previousMillis = currentMillis;

    Serial.print("Sending Voltage to topic: ");
    Serial.println(topic);
    Serial.println(V1);

    Serial.print("Sending Temperature to topic: ");
    Serial.println(topic2);
    Serial.println(T);

    Serial.print("Sending Current to topic: ");
    Serial.println(topic3);
    Serial.println(Ampere);

    // send message, the Print interface can be used to set the message contents
    mqttClient.beginMessage(topic);
    mqttClient.print(V1);
    mqttClient.endMessage();

    mqttClient.beginMessage(topic2);
    mqttClient.print(T);
    mqttClient.endMessage();

    mqttClient.beginMessage(topic3);
    mqttClient.print(Ampere);
    mqttClient.endMessage();

    Serial.println();
  }
}

void CurrentSense()
{
  sensorwert = analogRead(Sensor);
  SensorSpannung = (sensorwert / 1024.0) * 5000; // Hier wird der Messwert in den Spannungswert am Sensor umgewandelt.
  Ampere = ((SensorSpannung - Nullpunkt) / VpA); // Im zweiten Schritt wird hier die Stromstärke berechnet.

  // Ausgabe der Ergebnisse am Seriellen Monitor
  // Serial.print("Sensorwert = " ); // Ausgabe des reinen Sensorwertes
  // Serial.print(sensorwert); 
  // Serial.print("\t Sensorspannung in mV = "); // Zeigt die Sensorspannung an
  // Serial.print(SensorSpannung,3); // Die "3" hinter dem Komma erzeugt drei Nachkommastellen
  // Serial.print("\t Ampere = "); // shows the voltage measured 
  // Serial.println(Ampere,3); // Die "3" hinter dem Komma erzeugt drei Nachkommastellen
  // delay(100); 
}
