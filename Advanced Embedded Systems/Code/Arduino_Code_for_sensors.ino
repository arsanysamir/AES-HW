#include <ArduinoMqttClient.h>
#include <WiFiNINA.h>
#include "arduino_secrets.h"

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

float V1 = 0.00;

int ThermistorPin = A1;
int Vo;
float R1 = 10000; // value of R1 on board
float logR2, R2, T;
float c1 = 0.001129148, c2 = 0.000234125, c3 = 0.0000000876741; //steinhart-hart coeficients for thermistor

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


}

void loop() {
  
  VOLT1();

  Serial.print("Voltage = ");
  Serial.print(V1);
  Serial.println("V");

  delay(1000);

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
  Serial.print("Temperature: "); 
  Serial.print(T);
  Serial.println(" C"); 

}
