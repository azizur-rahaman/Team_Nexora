import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/consumption_log_model.dart';
import '../models/consumption_statistics_model.dart';

/// Consumption Remote Data Source Contract
abstract class ConsumptionRemoteDataSource {
  /// Get all consumption logs
  Future<List<ConsumptionLogModel>> getAllLogs({
    int page = 1,
    int limit = 20,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    String? sortOrder,
  });

  /// Get consumption log by ID
  Future<ConsumptionLogModel> getLogById(String id);

  /// Create consumption log
  Future<ConsumptionLogModel> createLog({
    required String itemName,
    required double quantity,
    required String unit,
    required String category,
    required DateTime date,
    String? notes,
  });

  /// Update consumption log
  Future<ConsumptionLogModel> updateLog({
    required String id,
    String? itemName,
    double? quantity,
    String? unit,
    String? category,
    DateTime? date,
    String? notes,
  });

  /// Delete consumption log
  Future<void> deleteLog(String id);

  /// Get consumption statistics
  Future<ConsumptionStatisticsModel> getStatistics({
    String period = 'month',
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Consumption Remote Data Source Implementation
class ConsumptionRemoteDataSourceImpl implements ConsumptionRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ConsumptionRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://ecobite-backend.onrender.com/api',
  });

  @override
  Future<List<ConsumptionLogModel>> getAllLogs({
    int page = 1,
    int limit = 20,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    String? sortOrder,
  }) async {
    // Build query parameters
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

    final uri = Uri.parse('$baseUrl/consumption-logs').replace(
      queryParameters: queryParams,
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        final logsJson = jsonData['data'] as List;
        return logsJson
            .map((log) => ConsumptionLogModel.fromJson(log))
            .toList();
      }
      
      throw ServerException(message: 'Invalid response format');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException(
        message: 'Failed to fetch logs: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ConsumptionLogModel> getLogById(String id) async {
    final uri = Uri.parse('$baseUrl/consumption-logs/$id');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        return ConsumptionLogModel.fromJson(jsonData['data']);
      }
      
      throw ServerException(message: 'Invalid response format');
    } else if (response.statusCode == 404) {
      throw NotFoundException(message: 'Consumption log not found');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException(message: 'Not authorized to access this resource');
    } else {
      throw ServerException(
        message: 'Failed to fetch log: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ConsumptionLogModel> createLog({
    required String itemName,
    required double quantity,
    required String unit,
    required String category,
    required DateTime date,
    String? notes,
  }) async {
    final uri = Uri.parse('$baseUrl/consumption-logs');
    
    final body = {
      'itemName': itemName,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'date': date.toIso8601String(),
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        return ConsumptionLogModel.fromJson(jsonData['data']);
      }
      
      throw ServerException(message: 'Invalid response format');
    } else if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      throw ValidationException(
        message: jsonData['error'] ?? 'Validation failed',
        details: jsonData['details'],
      );
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException(
        message: 'Failed to create log: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ConsumptionLogModel> updateLog({
    required String id,
    String? itemName,
    double? quantity,
    String? unit,
    String? category,
    DateTime? date,
    String? notes,
  }) async {
    final uri = Uri.parse('$baseUrl/consumption-logs/$id');
    
    final body = <String, dynamic>{};
    if (itemName != null) body['itemName'] = itemName;
    if (quantity != null) body['quantity'] = quantity;
    if (unit != null) body['unit'] = unit;
    if (category != null) body['category'] = category;
    if (date != null) body['date'] = date.toIso8601String();
    if (notes != null) body['notes'] = notes;

    final response = await client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        return ConsumptionLogModel.fromJson(jsonData['data']);
      }
      
      throw ServerException(message: 'Invalid response format');
    } else if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      throw ValidationException(
        message: jsonData['error'] ?? 'Validation failed',
        details: jsonData['details'],
      );
    } else if (response.statusCode == 404) {
      throw NotFoundException(message: 'Consumption log not found');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException(message: 'Not authorized to update this resource');
    } else {
      throw ServerException(
        message: 'Failed to update log: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> deleteLog(String id) async {
    final uri = Uri.parse('$baseUrl/consumption-logs/$id');
    final response = await client.delete(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['success'] != true) {
        throw ServerException(message: 'Delete operation failed');
      }
      
      return;
    } else if (response.statusCode == 404) {
      throw NotFoundException(message: 'Consumption log not found');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException(message: 'Not authorized to delete this resource');
    } else {
      throw ServerException(
        message: 'Failed to delete log: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ConsumptionStatisticsModel> getStatistics({
    String period = 'month',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{
      'period': period,
    };

    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    final uri = Uri.parse('$baseUrl/consumption-logs/statistics').replace(
      queryParameters: queryParams,
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        return ConsumptionStatisticsModel.fromJson(jsonData['data']);
      }
      
      throw ServerException(message: 'Invalid response format');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException(
        message: 'Failed to fetch statistics: ${response.statusCode}',
      );
    }
  }
}
