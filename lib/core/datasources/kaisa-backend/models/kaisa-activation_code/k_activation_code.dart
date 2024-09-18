import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'k_activation_code.g.dart';

@JsonSerializable()
class KActivationCode extends Equatable {
  final int code;

  const KActivationCode({
    required this.code,
  });

  factory KActivationCode.fromJson(Map<String, dynamic> json) =>
      _$KActivationCodeFromJson(json);

  Map<String, dynamic> toJson() => _$KActivationCodeToJson(this);

  @override
  List<Object?> get props => [code];
}
