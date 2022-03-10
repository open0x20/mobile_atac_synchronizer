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
        primarySwatch: MaterialColor(
          0xFFFF7002,
          <int, Color>{
            50: Color(0xFF000000),
            100: Color(0xFF000000),
            200: Color(0xFF000000),
            300: Color(0xFF000000),
            400: Color(0xFF000000),
            500: Color(0xFFFF7002), // base
            600: Color(0xFF000000),
            700: Color(0xFF000000),
            800: Color(0xFF000000),
            900: Color(0xFF000000),
          },
        ),

      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ATAC Synchronizer',
          style: TextStyle(color: Colors.white),
        ),
        brightness: Brightness.dark,
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
                            child: Text('Calculate Difference', style: TextStyle(color: Colors.white),),
                            onPressed: state.viewModel.isFetchButtonEnabled
                                ? () => { BlocProvider.of<MainBloc>(context).add(MainFetchDifferenceButtonPressEvent()) }
                                : null,
                          ),
                          ElevatedButton(
                            child: Text('Download', style: TextStyle(color: Colors.white),),
                            onPressed: state.viewModel.isDownloadButtonEnabled
                                ? () => { BlocProvider.of<MainBloc>(context).add(MainDownloadDifferenceButtonPressEvent()) }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Container(
                      width: double.infinity,
                      child: _resultLog(state)
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  ListView _resultLog(MainBlocState state) {
    List<Text> entries = [];

    for (String log in state.viewModel.logs) {
      entries.add(Text(
        log,
        style: TextStyle(
          fontSize: 10.0,
          color: (log.startsWith('E:') ? Colors.red : Colors.black87)
        ),
      ));
    }

    return ListView(
      shrinkWrap: true,
      children: [...entries],
    );
  }
}
