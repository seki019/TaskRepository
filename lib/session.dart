class StudySession {
  int totalMinutes = 0;

  void recordSession(int minutes) {
    totalMinutes += minutes;
    print('StudySession: You studied for $minutes minutes. '
          'Total: $totalMinutes minutes.');
  }
}
