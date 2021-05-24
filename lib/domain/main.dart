class MainDomain {
  static Future<List<String>> fetchDifferenceFromWLAN() async {
    // TODO real api call
    await Future.delayed(Duration(seconds: 3));
    return ['123', 'test', 'abcdefg'].toList();
  }

  static Future<List<String>> downloadDifferenceFromWLAN() async {
    await Future.delayed(Duration(seconds: 3));
    // TODO real api call
    return ['123', 'test', 'abcdefg'].toList();
  }

  static Future<void> saveFilenames() async {
    // TODO implement
  }
}