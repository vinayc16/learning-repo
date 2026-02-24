
class ApiConstants{
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String apiVersion = '/v1';
  static const String fullBaseUrl = '$baseUrl$apiVersion';

  // EndPoints
  static const String users = '/users';
  static const String api2 = '/endpoint2';
  static const String api3 = '/endpoint3';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String acceptLanguage = 'Accept-Language';

  //Timeouts
  static const int connectTimerOutsMs = 15000;
  static const int receiveTimerOutsMs = 15000;
  static const int sendTimerOutsMs = 15000;
}