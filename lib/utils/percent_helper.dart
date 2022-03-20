extension PercentHelper on String {
  String getPercentString(double percent) {
    if (percent == 0.1) {
      return "10%";
    } else if (percent == 0.2) {
      return "20%";
    } else if (percent == 0.3) {
      return "30%";
    } else if (percent == 0.4) {
      return "40%";
    } else if (percent == 0.5) {
      return "50%";
    } else if (percent == 0.6) {
      return "60%";
    } else if (percent == 0.7) {
      return "70%";
    } else if (percent == 0.8) {
      return "80%";
    } else if (percent == 0.9) {
      return "90%";
    } else if (percent == 1.0) {
      return "100%";
    }

    return "0%";
  }
}
