import 'package:dio/dio.dart';

class CustomException implements Exception {
    final String message;
    final bool isInternal;

    CustomException({String? message, this.isInternal = false}) : message = message ??
                (isInternal
                    ? "Something went wrong. Please try again later."
                    : "An unexpected error occurred.");

    @override
    String toString() {
        return "CustomException: $message";
    }

    static CustomException translate(dynamic error) { 
        if (error is CustomException) {
            return error;
        }
        
        if (error is DioException) {
            return _handleDioError(error);
        }
        
        if (error is FormatException) {
            return CustomException(message: "We couldn't process the data. Please try again.");
        }
        
        if (error is ArgumentError) {
            return CustomException(message: error.message.toString());
        }
        
        return CustomException(isInternal: true);
    }

    static CustomException _handleDioError(DioException error) {
        switch (error.type) {
            case DioExceptionType.connectionTimeout:
                return CustomException(message: "Connection timed out.");
            case DioExceptionType.receiveTimeout:
                return CustomException(message: "Server took too long to respond.");
            case DioExceptionType.badResponse:
                return _parseBadResponse(error);
            default:
                return CustomException(isInternal: true);
        }
    }

    static CustomException _parseBadResponse(DioException error) {
        final data = error.response?.data;
        
        if (data is Map && data["message"] is String) {
            return CustomException(message: data["message"]);
        }
        
        return CustomException(isInternal: true);
    }
}