class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error occurred', this.statusCode});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network error occurred'});
} 