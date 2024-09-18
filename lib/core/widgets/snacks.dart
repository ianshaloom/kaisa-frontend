import 'package:flutter/material.dart';
import 'package:kaisa/theme/text_scheme.dart';

class Snack {
// factory constructor
  Snack._privateConstructor();
  static final Snack _instance = Snack._privateConstructor();
  factory Snack() => _instance;

  // NOTE Error Handling
  void authError(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Authentification Error: User not found');
        }
        break;
      case 1:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Authentification Error: Invalid Login Credentials');
        }
        break;
      case 2:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Authentification Error: Authentication failed');
        }
        break;
      case 3:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Authentification Error: Password is too weak');
        }
        break;

      case 4:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Authentification Error: Email already in use');
        }
        break;

      case 5:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Authentification Error: Password is too weak');
        }
        break;

      case 6:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Authentification Error: Something went wrong');
        }
        break;
    }
  }

  // NOTE Error Handling
  void cloudError(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context, message: 'Cloud Error: Could not add to cloud');
        }
        break;
      case 1:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context, message: 'Cloud Error: Could not update cloud');
        }
        break;
      case 2:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Cloud Error: Could not delete from cloud');
        }
        break;
      case 3:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message: 'Cloud Error: Could not get from cloud');
        }
        break;

      case 4:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context,
              message:
                  'Cloud Error: There was an error while performing this action');
        }
        break;
    }
  }

  void cloudSuccess(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context, message: 'Cloud Success: Added to cloud');
        }
        break;
      case 1:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context, message: 'Cloud Success: Updated to cloud');
        }
        break;
      case 2:
        {
          Navigator.pop(context);
          _instance.showSnackBar(
              context: context, message: 'Cloud Success: Deleted from cloud');
        }
        break;
    }
  }

  void showSnackBar({
    required BuildContext context,
    required String message,
  }) {
    final textTheme = Theme.of(context).textTheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 1,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: bodyMedium(textTheme).copyWith(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        behavior: SnackBarBehavior.floating,
      ), 
    );
  }
}
