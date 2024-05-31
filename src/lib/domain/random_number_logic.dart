import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:src/core/isar/isar_database_manager.dart';
import 'package:src/data/random_number.dart';
import 'package:src/utils/consts.dart';

part 'random_number_logic.g.dart';

@riverpod
RandomNumberLogic randomNumberLogic(Ref ref) {
  return RandomNumberLogic(ref);
}

class RandomNumberLogic {
  RandomNumberLogic(this.ref);

  final Ref ref;

  Future<int?> generateRandomNumber(int start, int end) async {
    final cacheNumberList = await getCacheNumberList();
    if (cacheNumberList == null) {
      return null;
    }

    if (cacheNumberList.length == (end + 1) - start) {
      // すべての乱数が生成されている場合はnullを返却
      return null;
    }

    do {
      final random = Random().nextInt((end + 1) - start);
      final current = random + start;
      if (!cacheNumberList.contains(current)) {
        // 配列に含まれていない場合は保存して返却
        await _saveCacheNumberList(current);
        return current;
      }
    } while (true);
  }

  Future<RandomNumber> fetchRandomNumber() async {
    final db = await IsarDatabaseManager.instance();
    try {
      final info = await db.isar?.randomNumbers.get(0); // このクラスは1つしか発生しないため、固定でidに0を指定
      if (info == null) {
        RandomNumber newInfo = const RandomNumber(
          id: 0,
          start: Consts.start,
          end: Consts.end,
          cacheNumberList: [],
          ignoreNumberList: [],
        );
        await db.isar?.writeTxn(() async {
          await db.isar?.randomNumbers.put(newInfo);
        });
        return newInfo;
      }

      return info;
    } catch (e) {
      return const RandomNumber(
        id: 0,
        start: Consts.start,
        end: Consts.end,
        cacheNumberList: [],
        ignoreNumberList: [],
      );
    }
  }

  Future<void> changeStart(int start) async {
    final db = await IsarDatabaseManager.instance();
    try {
      final info = await db.isar?.randomNumbers.get(0);
      RandomNumber? newInfo;
      if (info != null) {
        newInfo = info.copyWith(
          start: start,
        );

        await db.isar?.writeTxn(() async {
          await db.isar?.randomNumbers.put(newInfo!);
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<void> changeEnd(int end) async {
    final db = await IsarDatabaseManager.instance();
    try {
      final info = await db.isar?.randomNumbers.get(0);
      RandomNumber? newInfo;
      if (info != null) {
        newInfo = info.copyWith(
          end: end,
        );

        await db.isar?.writeTxn(() async {
          await db.isar?.randomNumbers.put(newInfo!);
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<void> cleanCache() async {
    final db = await IsarDatabaseManager.instance();
    try {
      final info =
          await db.isar?.randomNumbers.get(0); // このクラスは1つしか発生しないため、固定でidに0を指定
      if (info == null) {
        return;
      }

      final newInfo = info.copyWith(
        cacheNumberList: [],
      );

      await db.isar?.writeTxn(() async {
        await db.isar?.randomNumbers.put(newInfo);
      });
    } catch (e) {
      return;
    }
  }

  Future<List<int>> fetchIgnoreNumberList() async {
    final db = await IsarDatabaseManager.instance();
    try {
      final result = <int>[];
      final info = await db.isar?.randomNumbers.get(0);
      if (info == null) {
        return result;
      }

      result.addAll(info.ignoreNumberList);
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<void> addIgnoreNumber(int newValue) async {
    final db = await IsarDatabaseManager.instance();
    try {
      final info = await db.isar?.randomNumbers.get(0);
      RandomNumber? newInfo;
      if (info != null) {
        final ignoreNumberList = <int>[];
        ignoreNumberList.addAll(info.ignoreNumberList);
        ignoreNumberList.add(newValue);
        newInfo = info.copyWith(
          cacheNumberList: info.cacheNumberList,
          ignoreNumberList: ignoreNumberList,
        );

        await db.isar?.writeTxn(() async {
          await db.isar?.randomNumbers.put(newInfo!);
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<void> removeIgnoreNumber(int value) async {
    final db = await IsarDatabaseManager.instance();
    try {
      final info = await db.isar?.randomNumbers.get(0);
      RandomNumber? newInfo;
      if (info != null) {
        final ignoreNumberList = <int>[];
        ignoreNumberList.addAll(info.ignoreNumberList);
        ignoreNumberList.remove(value);
        newInfo = info.copyWith(
          cacheNumberList: info.cacheNumberList,
          ignoreNumberList: ignoreNumberList,
        );

        await db.isar?.writeTxn(() async {
          await db.isar?.randomNumbers.put(newInfo!);
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<List<int>?> getCacheNumberList() async {
    final db = await IsarDatabaseManager.instance();
    try {
      final result = <int>[]; // ここにキャッシュされた乱数を格納
      final info =
          await db.isar?.randomNumbers.get(0); // このクラスは1つしか発生しないため、固定でidに0を指定
      if (info == null) {
        RandomNumber newInfo = const RandomNumber(
          id: 0,
          start: Consts.start,
          end: Consts.end,
          cacheNumberList: [],
          ignoreNumberList: [],
        );
        await db.isar?.writeTxn(() async {
          await db.isar?.randomNumbers.put(newInfo);
        });
        return result;
      }

      result.addAll(info.cacheNumberList);
      result.addAll(info.ignoreNumberList);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveCacheNumberList(int number) async {
    final db = await IsarDatabaseManager.instance();
    try {
      final info =
          await db.isar?.randomNumbers.get(0); // このクラスは1つしか発生しないため、固定でidに0を指定
      RandomNumber? newInfo;
      if (info != null) {
        final cacheNumberList = <int>[];
        cacheNumberList.addAll(info.cacheNumberList);
        cacheNumberList.add(number);
        newInfo = info.copyWith(
          cacheNumberList: cacheNumberList,
          ignoreNumberList: info.ignoreNumberList,
        );

        await db.isar?.writeTxn(() async {
          await db.isar?.randomNumbers.put(newInfo!);
        });
      }
    } catch (e) {
      return;
    }
  }
}
