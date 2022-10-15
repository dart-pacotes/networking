import 'package:example_web/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:networking/networking.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networkingBloc = context.read<NetworkingBloc>();

    final urlTextEditingController = TextEditingController();

    return MaterialApp(
      title: 'Networking Playground',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Playground'),
        ),
        body: BlocListener<NetworkingBloc, NetworkingState>(
          listener: (context, state) {
            if (state is NetworkingRequestInProgress) {}
          },
          child: Center(
            child: ListView(
              primary: false,
              children: [
                TextFormField(
                  controller: urlTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            networkingBloc.add(
              RequestEvent(
                headers: const {},
                payload: '',
                url: urlTextEditingController.text,
                verb: HttpVerb.get,
              ),
            );
          },
          tooltip: 'Request',
          child: const Icon(Icons.arrow_right),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
