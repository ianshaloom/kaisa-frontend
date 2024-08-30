
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfo {
  static final connectionChecker = InternetConnectionChecker();
  static Future<bool> get isConnected async => await connectionChecker.hasConnection;
}
