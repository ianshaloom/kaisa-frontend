import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kaisa_user.g.dart';

@JsonSerializable()
class KUser extends Equatable {
  final String phoneNumber;

  const KUser({
    required this.phoneNumber,
  });

  factory KUser.fromJson(Map<String, dynamic> json) =>
      _$KUserFromJson(json);

  Map<String, dynamic> toJson() => _$KUserToJson(this);

  KUser copyWith({
    String? phoneNumber,
  }) {
    return KUser(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [phoneNumber];
}
