 String getCountText(List jobs) {
    final count = jobs.length;

    if (count == 0) return "No Jobs Live";
    if (count == 1) return "1 Job Live";

    return "$count Jobs Live";
  }