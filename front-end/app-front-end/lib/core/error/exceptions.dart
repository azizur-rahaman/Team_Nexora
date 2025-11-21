class ServerException implements Exception {
  final String? message;
  
  ServerException({this.message});
  
  @override
  String toString() => message ?? 'Server Exception';
}

class CacheException implements Exception {
  final String? message;
  
  CacheException({this.message});
  
  @override
  String toString() => message ?? 'Cache Exception';
}

class NetworkException implements Exception {
  final String? message;
  
  NetworkException({this.message});
  
  @override
  String toString() => message ?? 'Network Exception';
}

class UnauthorizedException implements Exception {
  final String? message;
  
  UnauthorizedException({this.message});
  
  @override
  String toString() => message ?? 'Unauthorized';
}

class NotFoundException implements Exception {
  final String? message;
  
  NotFoundException({this.message});
  
  @override
  String toString() => message ?? 'Not Found';
}

class ForbiddenException implements Exception {
  final String? message;
  
  ForbiddenException({this.message});
  
  @override
  String toString() => message ?? 'Forbidden';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? details;
  
  ValidationException({required this.message, this.details});
  
  @override
  String toString() => details != null ? '$message: $details' : message;
}
