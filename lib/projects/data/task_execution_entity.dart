
class TaskExecutionEntity {
  int? _id;
  int? get id => _id;
  DateTime _start = DateTime.now();
  DateTime get start => _start;
  Duration? _duration;
  Duration? get duration => _duration;



  TaskExecutionEntity();
  TaskExecutionEntity.withDuration(this._duration);

  TaskExecutionEntity.from(TaskExecutionEntity other) {
    _id = other.id;
    _start = other.start;
    _duration = other.duration;
  }

  Map<String, dynamic> toFirebaseDoc() {
    return <String, dynamic> {
      "id": _id,
      "start": _start,
      "durationSec": _duration?.inSeconds
    };
  }
}
