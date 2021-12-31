import 'package:sqflite/sqflite.dart';
import 'AlarmsModel.dart';

///Storing information
class AlarmsDBWorker {

  static final AlarmsDBWorker db = AlarmsDBWorker._();

  static const String DB_NAME = 'alarms.db';
  static const String TBL_NAME = 'alarms';
  static const String KEY_ID = 'id';
  static const String KEY_TIME = "time";
  static const String KEY_DESCRIPTION = 'description';

  Database _db;

  AlarmsDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_TIME TEXT,"
                  "$KEY_DESCRIPTION TEXT"
                  ")"
          );
        }
    );
  }
  ///creating new alarm
  @override
  Future<int> create(Alarm alarm) async {
    Database db = await database;
    return await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_TIME, $KEY_DESCRIPTION) "
            "VALUES (?, ?)",
        [alarm.time, alarm.description]
    );
  }
  ///deleting alarm
  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<Alarm> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _alarmFromMap(values.first);
  }

  @override
  Future<List<Alarm>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _alarmFromMap(m)).toList() : [];
  }
  ///Changes to alarm
  @override
  Future<int> update(Alarm alarm) async {
    Database db = await database;
    return await db.update(TBL_NAME, _alarmToMap(alarm),
        where: "$KEY_ID = ?", whereArgs: [ alarm.id ]);
  }

  Alarm _alarmFromMap(Map<String, dynamic> map) {
    return Alarm()
      ..id = map[KEY_ID]
      ..time = map[KEY_TIME]
      ..description = map[KEY_DESCRIPTION];
  }

  Map<String, dynamic> _alarmToMap(Alarm alarm) {
    return Map<String, dynamic>()
      ..[KEY_ID] = alarm.id
      ..[KEY_TIME] = alarm.time
      ..[KEY_DESCRIPTION] = alarm.description;
  }
}
