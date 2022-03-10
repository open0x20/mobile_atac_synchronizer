import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_atac_synchronizer/bloc/events.dart';
import 'package:mobile_atac_synchronizer/bloc/states.dart';
import 'package:mobile_atac_synchronizer/domain/main.dart';
import 'package:mobile_atac_synchronizer/domain/results.dart';
import 'package:mobile_atac_synchronizer/model/model.dart';
import 'package:mobile_atac_synchronizer/model/view_model.dart';

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  MainBloc(initialState) : super(initialState);

  factory MainBloc.init() {
    return MainBloc(MainInitState(
        MainModel(),
        MainViewModel(
          isFetchButtonEnabled: true,
        ),
    ));
  }

  @override
  Stream<MainBlocState> mapEventToState(MainBlocEvent event) async* {
    // Fetching
    if (event is MainFetchDifferenceButtonPressEvent && state.isValidTransitionEvent(event)) {
      yield MainDiffLoadingState(state.model, state.viewModel);

      try {
        await for (Result<List<String>> result in MainDomain.fetchDifference()) {
          if (result is IntermediateResult) {
            final MainViewModel newMainViewModel = MainViewModel(
              logs: [...state.viewModel.logs, result.message],
            );
            yield MainDiffLoadingState(state.model, newMainViewModel);
          } else if (result is ErrorResult) {
            final MainViewModel newMainViewModel = MainViewModel(
              isFetchButtonEnabled: true,
              isDownloadButtonEnabled: true,
              logs: [...state.viewModel.logs, result.message],
            );
            yield MainDiffLoadingFailedState(state.model, newMainViewModel);
          } else if (result is FinalResult) {
            final MainViewModel newMainViewModel = MainViewModel(
              difference: result.result!,
              isFetchButtonEnabled: true,
              isDownloadButtonEnabled: true,
              logs: [...state.viewModel.logs, result.message],
            );
            yield MainDiffLoadedState(state.model, newMainViewModel);
          }
        }
      } catch (e) {
        final MainViewModel newMainViewModel = MainViewModel(
            isFetchButtonEnabled: true,
          logs: [...state.viewModel.logs, 'E: An unexpected error occurred.', 'E: ${e.toString()}'],
        );
        yield MainDiffLoadingFailedState(state.model, newMainViewModel);
      }
      return;
    }

    // Downloading
    if (event is MainDownloadDifferenceButtonPressEvent && state.isValidTransitionEvent(event)) {
      yield MainDownloadingState(state.model, state.viewModel);

      try {
        await for (Result<List<String>> result in MainDomain.downloadDifference(state.viewModel.difference)) {
          if (result is IntermediateResult) {
            final MainViewModel newMainViewModel = MainViewModel(
              logs: [...state.viewModel.logs, result.message],
            );
            yield MainDownloadingState(state.model, newMainViewModel);
          } else if (result is ErrorResult) {
            final MainViewModel newMainViewModel = MainViewModel(
              isFetchButtonEnabled: true,
              logs: [...state.viewModel.logs, result.message],
            );
            yield MainDownloadingFailedState(state.model, newMainViewModel);
          } else if (result is FinalResult) {
            final MainViewModel newMainViewModel = MainViewModel(
              isFetchButtonEnabled: true,
              logs: [...state.viewModel.logs, result.message],
            );
            yield MainDownloadedState(state.model, newMainViewModel);
          }
        }
      } catch (e) {
        final MainViewModel newMainViewModel = MainViewModel(
          isFetchButtonEnabled: true,
          logs: [...state.viewModel.logs, 'E: An unexpected error occurred.', 'E: ${e.toString()}'],
        );
        yield MainDownloadingFailedState(state.model, newMainViewModel);
      }
      return;
    }
  }
}