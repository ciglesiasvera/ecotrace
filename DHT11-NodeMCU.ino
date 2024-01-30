#include <DHT.h>

#define DHTTYPE DHT11
#define DHTPIN 0  // Define el pin al que está conectado el sensor (D3 en este caso)

DHT sensor(DHTPIN,DHTTYPE);

void setup() {
  sensor.begin();
  Serial.begin(9600);
}

void loop() {
 float h = sensor.readHumidity();
 float t = sensor.readTemperature();
 Serial.print("Current Humidity: ");
 Serial.print(h);
 Serial.println(" %");
 Serial.print("Current Temperature: ");
 Serial.print(t);
 Serial.println(" C°");
 delay(2000);
}
