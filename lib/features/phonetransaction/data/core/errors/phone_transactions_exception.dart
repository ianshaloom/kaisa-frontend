class PhoneTransException implements Exception {
  final String message;
  PhoneTransException(
      {this.message = 'An error occurred during authentication'});
  @override
  String toString() => message;
}

// C in CRUD
class CouldNotCreateTrans extends PhoneTransException {
  CouldNotCreateTrans(String? message)
      : super(
          message: "Error creating transaction",
        );
}

// R in CRUD
class CouldNotFetchTrans extends PhoneTransException {
  CouldNotFetchTrans(String? message)
      : super(
          message: "Error Fetching Phone Transactions",
        );
}

// U in CRUD
class CouldNotUpdateTrans extends PhoneTransException {
  CouldNotUpdateTrans(String? message)
      : super(
          message: "Error updating transaction",
        );
}

// D in CRUD
class CouldNotDeleteTrans extends PhoneTransException {
  CouldNotDeleteTrans(String? message)
      : super(
          message: "Error deleting transaction",
        );
}

// GenericCloudException

class GenericCloudTrans extends PhoneTransException {
  GenericCloudTrans(String? message)
      : super(
          message: "Something went wrong",
        );
}
