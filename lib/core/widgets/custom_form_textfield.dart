import 'package:flutter/material.dart';

import '../../theme/text_scheme.dart';

class CustomFormTf extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final bool isNumber;
  final bool isDescription;
  final bool needsValidation;

  const CustomFormTf({
    super.key,
    required this.controller,
    required this.labelText,
    required this.errorText,
    required this.isNumber,
    required this.isDescription,
    required this.needsValidation,
  });

  @override
  State<CustomFormTf> createState() => _CustomFormTfState();
}

class _CustomFormTfState extends State<CustomFormTf> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      maxLines: widget.isDescription ? 3 : 1,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      autocorrect: false,
      decoration: InputDecoration(
        labelStyle: bodyDefault(textTheme).copyWith(
          color: color.onSurface.withOpacity(0.5),
        ),
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (widget.needsValidation) {
          if (value!.isEmpty) {
            return widget.errorText;
          }
        }
        return null;
      },
    );
  }
}
