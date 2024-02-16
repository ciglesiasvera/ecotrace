import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Error "mo:base/Error";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";

//import the custom types we have in Types.mo
import Types "Types";

// Actor
actor {

  // Function to transform the response
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
  
  public func get_weather(city: Text.Text) : async Text {

    // IC management canister
    let ic : Types.IC = actor ("aaaaa-aa");

    // Setup arguments for HTTP GET request

    // API key for Weatherbit
    let apiKey = "Your API Key";
    let apiUrl = "API URL";
    let url = apiUrl # "?city=" # city # "&key=" # apiKey;

    // Headers for the system http_request call
    let request_headers = [
      { name = "Host"; value = "api.weatherbit.io:443" },
      { name = "User-Agent"; value = "weather_canister" },
    ];

    // Transform context
    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    // The HTTP request
    let http_request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null; // Optional for request
      headers = request_headers;
      body = null; // Optional for request
      method = #get;
      transform = ?transform_context;
    };

    // Add cycles to pay for HTTP request
    Cycles.add(230_949_972_000);

    // Make HTTPS request and wait for response
    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

    // Decode the response
    let response_body: Blob = Blob.fromArray(http_response.body);
    let decoded_text: Text = switch (Text.decodeUtf8(response_body)) {
      case (null) { "No value returned" };
      case (?y) { y };
    };

    // Return response of the body
    decoded_text
  };
};
