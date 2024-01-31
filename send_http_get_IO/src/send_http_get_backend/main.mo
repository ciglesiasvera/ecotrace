import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Error "mo:base/Error";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";

// Importa los tipos personalizados que tengas en Types.mo
import Types "Types";

// Actor
actor {

  // Función para transformar la respuesta
  public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
    let transformed : Types.CanisterHttpResponsePayload = {
      status = raw.response.status;
      body = raw.response.body;
      headers = [
        { name = "Content-Security-Policy"; value = "default-src 'self'" },
        { name = "Referrer-Policy"; value = "strict-origin" },
        { name = "Permissions-Policy"; value = "geolocation=(self)" },
        { name = "Strict-Transport-Security"; value = "max-age=63072000" },
        { name = "X-Frame-Options"; value = "DENY" },
        { name = "X-Content-Type-Options"; value = "nosniff" },
      ];
    };
    transformed;
  };
  
  // Función para obtener la temperatura desde Adafruit IO
  public func get_temperature() : async Text {
    // IC management canister
    let ic : Types.IC = actor ("aaaaa-aa");

    // Configuración de la solicitud HTTP a Adafruit IO
    let apiKey = "API Key";
    let feedPath = "feed path";
    let apiUrl = "https://io.adafruit.com/api/v2/" # feedPath;
    let url = apiUrl # "?key=" # apiKey;

    // Encabezados de la solicitud HTTP
    let request_headers = [
      { name = "Host"; value = "io.adafruit.com" },
      { name = "User-Agent"; value = "adafruit_canister" },
    ];

    // Contexto de transformación
    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    // Solicitud HTTP
    let http_request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null;
      headers = request_headers;
      body = null;
      method = #get;
      transform = ?transform_context;
    };

    // Agrega ciclos para pagar la solicitud HTTP
    Cycles.add(230_949_972_000);

    // Realiza la solicitud HTTPS y espera la respuesta
    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

    // Decodifica la respuesta
    let response_body: Blob = Blob.fromArray(http_response.body);
    let decoded_text: Text = switch (Text.decodeUtf8(response_body)) {
      case (null) { "No se ha devuelto ningún valor" };
      case (?y) { y };
    };

    // Devuelve la respuesta del cuerpo
    decoded_text
  };
};
