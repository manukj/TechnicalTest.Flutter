abstract class Failure {
  final String message;
  
  Failure({required this.message});
}

class APIFailure extends Failure {
  final int? statusCode;
  
  APIFailure({required String message, this.statusCode}) : super(message: message);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message: message);
} 