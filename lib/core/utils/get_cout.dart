 String getCountText(int liveJobs) {
    final count = liveJobs;

    if (count == 0) return "";
    if (count == 1) return "1 Job Live";

    return "$count Jobs Live";
  }