import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:src/data/random_number.dart';

class IsarDatabaseManager {
  static IsarDatabaseManager? _instance;
  static final List<CollectionSchema> _schemaList = [
    // Add your schema here
    RandomNumberSchema,
  ];

  Isar? isar;

  IsarDatabaseManager._privateConstructor();

  static Future<IsarDatabaseManager> instance() async {
    if(_instance == null) {
      _instance = IsarDatabaseManager._privateConstructor();
      await _instance!._init(_schemaList);
    }
    return _instance!;
  }


  Future<void> _init(List<CollectionSchema> schemaList) async {
    final dir = await getApplicationDocumentsDirectory();
    if(isar != null) {
      await isar!.close();
    }

    isar = await Isar.open(
      _schemaList,
      directory: dir.path,
    );
  }

  static bool isInitialized() => _instance != null;
}