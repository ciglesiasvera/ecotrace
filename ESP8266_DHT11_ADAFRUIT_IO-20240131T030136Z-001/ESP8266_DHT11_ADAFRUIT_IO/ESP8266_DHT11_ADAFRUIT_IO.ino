#include "DHT.h"

/************************** Config. comunicacion ***********************************/

#include "config.h"

/************************ Example Starts Here *******************************/

#define DHTPIN 0
#define DHTTYPE DHT11 
DHT dht(DHTPIN, DHTTYPE);

AdafruitIO_Feed *temperatura = io.feed("temperatura");
AdafruitIO_Feed *humedad = io.feed("humedad");

void setup() {
  
  Serial.begin(115200);
  while(! Serial);
  Serial.print("Conectando a Adafruit IO");
  io.connect();
  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.println(io.statusText());
  
  dht.begin();
}

void loop() {
  delay(60000);
  io.run();
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  Serial.print("temperatura: ");
  Serial.print(t);
  Serial.print(" humedad: ");
  Serial.println(h);
  temperatura->save(t);
  humedad->save(h); 
 
}
