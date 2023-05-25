#include <Servo.h> //Die Servobibliothek wird aufgerufen. Sie wird benötigt, damit die Ansteuerung des Servos vereinfacht wird.
 

Servo servoblau; //Erstellt für das Programm ein Servo mit dem Namen „servoblau“

const int buzzer = 9;

#define redLED 7
#define greenLED 8

float voltage= 0;
float temperature= 0;
float current = 0;
String readstring;

bool doorlock = false;

void setup()

{

Serial.begin(9600);
servoblau.attach(6); //Das Setup enthält die Information, dass das Servo an der Steuerleitung (gelb) mit Pin 8 verbunden wird. Hier ist natürlich auch ein anderer Pin möglich.
pinMode(buzzer, OUTPUT);
pinMode(greenLED, OUTPUT);
pinMode(redLED, OUTPUT);

digitalWrite(greenLED, HIGH);

}

 

void loop()

{ //Im „loop“ wird über den write-Befehl „servoblau.write(Grad)“ das Servo angesteuert. Zwischen den einzelnen Positionen gibt es eine Pause, damit das Servo genug Zeit hat, die gewünschten Positionen zu erreichen.


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
  
  if (voltage > 10 || temperature > 90)
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