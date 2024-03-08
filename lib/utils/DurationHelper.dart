

String printDuration(Duration? duration) {
  if (duration == null) {
    return "";
  }

  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

String printDurationTrimmed(Duration? duration) {
  if (duration == null) {
    return "";
  }

  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) {
    return (n > 0) ? n.toString().padLeft(2, "0") : "";
  };
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  String result = "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  result = result.replaceAll(RegExp(":*"), "");
  return result;
}