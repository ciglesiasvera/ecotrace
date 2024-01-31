/************************ Adafruit IO Config *******************************/

#define IO_USERNAME "username"
#define IO_KEY "key"

/******************************* WIFI **************************************/

#define WIFI_SSID "SSID"
#define WIFI_PASS "Password"

#include "AdafruitIO_WiFi.h"

AdafruitIO_WiFi io(IO_USERNAME, IO_KEY, WIFI_SSID, WIFI_PASS);
