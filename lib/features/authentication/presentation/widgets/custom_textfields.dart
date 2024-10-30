import 'package:email_validator/email_validator.dart' show EmailValidator;
import 'package:flutter/material.dart';

import '../../../../../theme/text_scheme.dart';

// Component: Email Text Form Field
class EmailTextFormField extends StatefulWidget {
  const EmailTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<EmailTextFormField> createState() => _EmailTextFormFieldState();
}

class _EmailTextFormFieldState extends State<EmailTextFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'Email',
        labelStyle: bodyMedium(textTheme).copyWith(
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autofillHints: const [AutofillHints.email],
      // onFieldSubmitted: (_) => null,
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'Please enter a valid email address'
          : null,
    );
  }
}

// Component: Password Text Form Field
class PassWordTextFormField extends StatefulWidget {
  const PassWordTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<PassWordTextFormField> createState() => _PassWordTextFormFieldState();
}

class _PassWordTextFormFieldState extends State<PassWordTextFormField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      autocorrect: false,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      textInputAction: TextInputAction.done,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.remove_red_eye_outlined,
          ),
          onPressed: () => _togglePasswordVisibility(),
        ),
        labelText: 'Password',
        labelStyle: bodyMedium(textTheme).copyWith(
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return 'Please enter a password';
        }
        if (password.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }
}

// Component: Confirm Phone Number Text Form Field
class ActivateTextFormField extends StatefulWidget {
  const ActivateTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<ActivateTextFormField> createState() => _ActivateTextFormFieldState();
}

class _ActivateTextFormFieldState extends State<ActivateTextFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      autocorrect: false,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.code),
        labelText: 'Activation Code',
        labelStyle: bodyMedium(textTheme).copyWith(
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (phone) {
        if (phone == null || phone.isEmpty) {
          return 'Please enter activation code';
        }
        return null;
      },
    );
  }
}

// Component: Normal Text Form Field
class NormalTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final Icon? prefixIcon;
  final bool needsValidation;
  const NormalTextFormField({
    Key? key,
    required this.controller,
    required this.needsValidation,
    required this.labelText,
    required this.errorText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<NormalTextFormField> createState() => _NormalTextFormFieldState();
}

class _NormalTextFormFieldState extends State<NormalTextFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        labelText: widget.labelText,
        labelStyle: bodyMedium(textTheme).copyWith(
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: widget.needsValidation
          ? (value) {
              if (value == null || value.isEmpty) {
                return widget.errorText;
              }
              return null;
            }
          : null,
    );
  }
}



// Component: Confirm Phone Number Text Form Field
class TelTextFormField extends StatefulWidget {
  const TelTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<TelTextFormField> createState() => _TelTextFormFieldState();
}

class _TelTextFormFieldState extends State<TelTextFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      autocorrect: false,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone_outlined),
        labelText: 'Phone Number',
        labelStyle: bodyMedium(textTheme).copyWith(
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (phone) {
        if (phone == null || phone.isEmpty) {
          return 'Please enter phone number';
        }
        return null;
      },
    );
  }
}
