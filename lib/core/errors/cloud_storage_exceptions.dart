class CloudStorageException implements Exception {
  final String message;
  CloudStorageException(
      {this.message =
          'An error occurred while trying to interact with the cloud storage'});
  @override
  String toString() => message;
}

// C in CRUD
class CouldNotCreateException extends CloudStorageException {
  final String eMessage;
  CouldNotCreateException({this.eMessage = 'Unable to create record'})
      : super(message: 'Unable to create record');
}

// R in CRUD
class CouldNotFetchException extends CloudStorageException {
  final String eMessage;
  CouldNotFetchException({this.eMessage = 'Unable to fetch record(s)'})
      : super(message: 'Unable to fetch record(s)');
}

// U in CRUD
class CouldNotUpdateException extends CloudStorageException {
  final String eMessage;
  CouldNotUpdateException({this.eMessage = 'Unable to update record'})
      : super(message: 'Unable to update record');
}

// D in CRUD
class CouldNotDeleteException extends CloudStorageException {
  final String eMessage;
  CouldNotDeleteException({this.eMessage = 'Unable to delete record'})
      : super(message: 'Unable to delete record');
}

class GenericException extends CloudStorageException {
  GenericException(String? message)
      : super(
          message: "Something went wrong",
        );
}
