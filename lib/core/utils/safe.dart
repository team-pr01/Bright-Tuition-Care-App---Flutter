
  String safe(dynamic value) {
    if (value == null || value == "") return "N/A";
    return value.toString();
  }