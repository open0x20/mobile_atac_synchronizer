import 'package:mobile_atac_synchronizer/bloc/events.dart';
import 'package:mobile_atac_synchronizer/model/model.dart';
import 'package:mobile_atac_synchronizer/model/view_model.dart';

abstract class MainBlocState {
  MainModel model;
  MainViewModel viewModel;

  MainBlocState(this.model, this.viewModel);

  bool isValidTransitionEvent(MainBlocEvent event);
}

class MainInitState extends MainBlocState {
  MainInitState(model, viewModel) : super(model, viewModel);

  @override
  bool isValidTransitionEvent(MainBlocEvent event) {
    return event is MainFetchDifferenceButtonPressEvent;
  }
}

class MainDiffLoadingState extends MainBlocState {
  MainDiffLoadingState(model, viewModel) : super(model, viewModel);

  @override
  bool isValidTransitionEvent(MainBlocEvent event) {
    return event is MainFetchingFinishedEvent;
  }
}

class MainDiffLoadingFailedState extends MainBlocState {
  MainDiffLoadingFailedState(model, viewModel) : super(model, viewModel);

  @override
  bool isValidTransitionEvent(MainBlocEvent event) {
    return event is MainFetchDifferenceButtonPressEvent;
  }
}

class MainDiffLoadedState extends MainBlocState {
  MainDiffLoadedState(model, viewModel) : super(model, viewModel);

  @override
  bool isValidTransitionEvent(MainBlocEvent event) {
    return event is MainDownloadDifferenceButtonPressEvent || event is MainFetchDifferenceButtonPressEvent;
  }
}

class MainDownloadingState extends MainBlocState {
  MainDownloadingState(model, viewModel) : super(model, viewModel);

  @override
  bool isValidTransitionEvent(MainBlocEvent event) {
    return event is MainDownloadingFinishedEvent;
  }
}

class MainDownloadingFailedState extends MainBlocState {
  MainDownloadingFailedState(model, viewModel) : super(model, viewModel);

  @override
  bool isValidTransitionEvent(MainBlocEvent event) {
    return event is MainDownloadDifferenceButtonPressEvent || event is MainFetchDifferenceButtonPressEvent;
  }
}

class MainDownloadedState extends MainBlocState {
  MainDownloadedState(model, viewModel) : super(model, viewModel);

  @override
  bool isValidTransitionEvent(MainBlocEvent event) {
    return event is MainFetchDifferenceButtonPressEvent;
  }
}