// ignore_for_file: prefer_typing_uninitialized_variables

class AppException implements Exception {
  final code;
  final message;
  final details;

  AppException({this.code, this.message, this.details});

  @override
  String toString() {
    return "[$code]: $message \n $details";
  }
}

class FetchDataException extends AppException {
  
  FetchDataException(String? details)
      : super(
          code: "fetch-data",
          message: "Error During Fetching Data",
          details: details,
        );
}

class PostDataException extends AppException {
  PostDataException(String? details)
      : super(
          code: "post-data",
          message: "Error During Posting Data",
          details: details,
        );
}

class PatchDataException extends AppException {
  PatchDataException(String? details)
      : super(
          code: "post-data",
          message: "Error During Posting Data",
          details: details,
        );
}

class TimeOutException extends AppException {
  TimeOutException(String? details)
      : super(
          code: "request-timeout",
          message: "Request TimeOut",
          details: details,
        );
}
