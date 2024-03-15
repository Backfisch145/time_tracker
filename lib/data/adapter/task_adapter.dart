import 'package:hive/hive.dart' show BinaryReader, BinaryWriter, TypeAdapter;

import '../task.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    Task t = Task()
      ..id = fields[0] as String?
      ..name = fields[1] as String
      ..lastUpdate = fields[3] as DateTime?
      ..running = fields[5] as bool;


    Duration d = fields[4] as Duration;
    if (t.lastUpdate != null && t.running == true) {
      int millisSince = DateTime.now().difference(t.lastUpdate!).inMilliseconds;
      d = Duration(milliseconds:  d.inMilliseconds + millisSince);
    }
    t.lastUpdate = null;
    t.duration = d;

    return t;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.lastUpdate)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.running);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
