class MainViewModel {
  final List<String> difference;
  final bool isFetchButtonEnabled;
  final bool isDownloadButtonEnabled;
  final List<String> logs;

  MainViewModel({
    this.difference = const [],
    this.isFetchButtonEnabled = false,
    this.isDownloadButtonEnabled = false,
    this.logs = const []
  });
}