abstract class MainBlocEvent {}

class MainFetchDifferenceButtonPressEvent extends MainBlocEvent {}

class MainFetchingFinishedEvent extends MainBlocEvent {
  final List<String> difference;

  MainFetchingFinishedEvent(this.difference);
}

class MainDownloadDifferenceButtonPressEvent extends MainBlocEvent {}

class MainDownloadingFinishedEvent extends MainBlocEvent {
  final List<String> downloadedFilenames;

  MainDownloadingFinishedEvent(this.downloadedFilenames);
}