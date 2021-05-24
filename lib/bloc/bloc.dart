import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_atac_synchronizer/bloc/events.dart';
import 'package:mobile_atac_synchronizer/bloc/states.dart';
import 'package:mobile_atac_synchronizer/domain/main.dart';
import 'package:mobile_atac_synchronizer/model/model.dart';
import 'package:mobile_atac_synchronizer/model/view_model.dart';

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  MainBloc(initialState) : super(initialState);

  factory MainBloc.init() {
    return MainBloc(MainInitState(
        MainModel(
            filenames: [''].toList(),
        ),
        MainViewModel(
          filenames: [''].toList(),
          isFetchButtonEnbaled: true,
          isDownloadButtonEnbaled: false,
          consoleLog: '',
        ),
    ));
  }

  @override
  Stream<MainBlocState> mapEventToState(MainBlocEvent event) async* {
    // Fetching
    if (event is MainFetchDifferenceButtonPressEvent &&
        state.isValidTransitionEvent(event)) {
      yield MainDiffLoadingState(state.model, state.viewModel);

      try {
        final List<String> difference = await MainDomain
            .fetchDifferenceFromWLAN();
        final MainViewModel newMainViewModel = MainViewModel(
            filenames: difference,
            isFetchButtonEnbaled: true,
            isDownloadButtonEnbaled: true,
            consoleLog: state.viewModel.consoleLog +
                '\nDetected ${difference.length} new songs.'
        );
        yield MainDiffLoadedState(state.model, newMainViewModel);
      } catch (e) {
        final MainViewModel newMainViewModel = MainViewModel(
            filenames: [],
            isFetchButtonEnbaled: true,
            isDownloadButtonEnbaled: false,
            consoleLog: state.viewModel.consoleLog +
                '\nFailed to fetch difference.'
        );
        yield MainDiffLoadingFailedState(state.model, state.viewModel);
      }
      return;
    }

    // Downloading
    if (event is MainDownloadDifferenceButtonPressEvent &&
        state.isValidTransitionEvent(event)) {
      yield MainDownloadingState(state.model, state.viewModel);

      try {
        final List<String> difference = await MainDomain
            .downloadDifferenceFromWLAN();
        final MainModel newMainModel = MainModel(
          filenames: [
            ...state.model.filenames,
            ...difference
          ],
        );
        await MainDomain.saveFilenames();

        final MainViewModel newMainViewModel = MainViewModel(
            filenames: difference,
            isFetchButtonEnbaled: true,
            isDownloadButtonEnbaled: true,
            consoleLog: state.viewModel.consoleLog +
                '\nDetected ${difference.length} new songs.'
        );
        yield MainDiffLoadedState(newMainModel, newMainViewModel);
      } catch (e) {
        final MainViewModel newMainViewModel = MainViewModel(
            filenames: [],
            isFetchButtonEnbaled: true,
            isDownloadButtonEnbaled: false,
            consoleLog: state.viewModel.consoleLog +
                '\nFailed to fetch difference.'
        );
        yield MainDiffLoadingFailedState(state.model, state.viewModel);
      }
      return;
    }
  }
}