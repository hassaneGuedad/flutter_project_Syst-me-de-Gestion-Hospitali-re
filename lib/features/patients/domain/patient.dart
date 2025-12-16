import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

// Converter to handle int to String ID conversion
class _IntToStringConverter implements JsonConverter<String, dynamic> {
  const _IntToStringConverter();

  @override
  String fromJson(dynamic json) {
    if (json is int) {
      return json.toString();
    }
    return json as String;
  }

  @override
  dynamic toJson(String object) => object;
}

@freezed
class Patient with _$Patient {
  const factory Patient({
    @_IntToStringConverter() required String id,
    required String nom,
    required String prenom,
    required DateTime dateNaissance,
    required String numeroSecuriteSociale,
    @Default(0.0) double coutTotal,
    @Default([]) List<String> soinIds,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);
}
