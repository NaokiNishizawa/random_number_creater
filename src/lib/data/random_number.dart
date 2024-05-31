import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'random_number.freezed.dart';
part 'random_number.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class RandomNumber with _$RandomNumber {
  const RandomNumber._();

  const factory RandomNumber({
    required int id,
    required List<int> cacheNumberList,
    required List<int> ignoreNumberList,
  }) = _RandomNumber;

  @override
  Id get id => Isar.autoIncrement;

  factory RandomNumber.fromJson(Map<String, dynamic> json) =>
      _$RandomNumberFromJson(json);
}