import 'package:shared/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'technique.freezed.dart';
part 'technique.g.dart';

@freezed
class Technique with _$Technique {
  const factory Technique({
    String? id,
    required String name,
    String? description,
    @Default(false) bool published,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Technique;

  factory Technique.fromJson(Map<String, dynamic> json) =>
      _$TechniqueFromJson(json);
}
