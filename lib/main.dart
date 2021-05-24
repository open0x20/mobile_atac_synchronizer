import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_atac_synchronizer/bloc/states.dart';

import 'bloc/bloc.dart';
import 'bloc/events.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATAC Synchronizer',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'ATAC Synchronizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocProvider(
        create: (_) => MainBloc.init(),
          child: _body()
      ),
    );
  }

  Container _body() {
    return Container(
      child: BlocBuilder<MainBloc, MainBlocState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            child: Text('Calculate Difference'),
                            onPressed: state.viewModel.isFetchButtonEnbaled
                                ? () => { BlocProvider.of<MainBloc>(context).add(MainFetchDifferenceButtonPressEvent()) }
                                : null,
                          ),
                          ElevatedButton(
                            child: Text('Download'),
                            onPressed: state.viewModel.isDownloadButtonEnbaled
                                ? () => { BlocProvider.of<MainBloc>(context).add(MainDownloadDifferenceButtonPressEvent()) }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white70,
                    child: _resultLog(state, state is MainDiffLoadingState),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container _resultLog(MainBlocState state, bool isLoading) {
    if (isLoading) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Result Log:' + state.viewModel.consoleLog)
          ],
        ),
      );
    }
  }
}
