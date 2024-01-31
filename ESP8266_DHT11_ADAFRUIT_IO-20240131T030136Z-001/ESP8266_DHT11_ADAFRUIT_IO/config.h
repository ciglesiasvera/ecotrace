/************************ Adafruit IO Config *******************************/

#define IO_USERNAME "ciglesiasvera"
#define IO_KEY "aio_YbtF71HM9fG9lBguLr3jSDMTQOoR"

/******************************* WIFI **************************************/

#define WIFI_SSID "TcoExP"
#define WIFI_PASS "S_*?316zhFLxMdp73"

#include "AdafruitIO_WiFi.h"

AdafruitIO_WiFi io(IO_USERNAME, IO_KEY, WIFI_SSID, WIFI_PASS);
