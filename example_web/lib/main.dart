import 'package:example_web/blocs/blocs.dart';
import 'package:example_web/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:networking/networking.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => NetworkingBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final urlTextEditingController = TextEditingController(
    text:
        'https://raw.githubusercontent.com/dart-pacotes/networking/master/README.md',
  );

  final payloadTextEditingController = TextEditingController();

  final verbTextEditingController = TextEditingController(
    text: HttpVerb.get.value,
  );

  final contentTypeTextEditingController = TextEditingController(
    text: ContentType.binary.value,
  );

  final relayProxyUrlTextEditingController = TextEditingController();

  var useRelayProxy = false;

  @override
  Widget build(BuildContext context) {
    final networkingBloc = context.read<NetworkingBloc>();

    final enablePayload = verbTextEditingController.text.startsWith('p');

    final verb = NetworkingHttpVerbExtension.of(
      verbTextEditingController.text,
    );

    final contentType = ContentTypeExtension.of(
      contentTypeTextEditingController.text,
    );

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
            if (state is NetworkingRequestInProgress) {
              showAppDialog(
                context: context,
                dialogBuilder: (dialogContext) {
                  return const BackgroundlessCircularProgressIndicatorDialog();
                },
              );
            } else if (state is NetworkingRequestFailure) {
              Navigator.of(context).popUntil(
                ModalRoute.withName(Navigator.defaultRouteName),
              );

              showAppDialog(
                context: context,
                dialogBuilder: (dialogContext) {
                  return NetworkingRequestFailureDialog(
                    result: state,
                  );
                },
                barrierDismissible: true,
              );
            } else if (state is NetworkingRequestSuccess) {
              Navigator.of(context).popUntil(
                ModalRoute.withName(Navigator.defaultRouteName),
              );

              showAppDialog(
                context: context,
                dialogBuilder: (dialogContext) {
                  return NetworkingRequestSuccessDialog(
                    result: state,
                  );
                },
                barrierDismissible: true,
              );
            }
          },
          child: Center(
            child: ListView(
              primary: false,
              children: [
                DropdownButton<HttpVerb>(
                  items: [
                    ...HttpVerb.values.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.value.toUpperCase()),
                      ),
                    ),
                  ],
                  hint: const Text('VERB'),
                  value: verb,
                  onChanged: (value) {
                    if (value != null) {
                      setState(
                        () {
                          verbTextEditingController.text = value.value;
                        },
                      );
                    }
                  },
                ),
                TextFormField(
                  controller: urlTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                TextFormField(
                  controller: payloadTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Payload',
                    prefixIcon: Icon(Icons.code),
                  ),
                  maxLines: 5,
                  enabled: enablePayload,
                ),
                DropdownButton<ContentType>(
                  items: [
                    ...ContentType.values.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.value),
                      ),
                    ),
                  ],
                  hint: const Text('Content Type'),
                  value: contentType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(
                        () {
                          contentTypeTextEditingController.text = value.value;
                        },
                      );
                    }
                  },
                ),
                CheckboxListTile(
                  title: const Text('Use Relay Proxy'),
                  value: useRelayProxy,
                  onChanged: (value) {
                    setState(
                      () {
                        useRelayProxy = value ?? false;
                      },
                    );
                  },
                ),
                if (useRelayProxy)
                  TextFormField(
                    controller: relayProxyUrlTextEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Relay Proxy URL',
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var request = RequestEvent(
              headers: const {},
              url: urlTextEditingController.text,
              verb: verb,
              contentType: contentType,
              payload: payloadTextEditingController.text,
            );

            if (useRelayProxy) {
              request = RelayProxyRequestEvent(
                headers: request.headers,
                url: request.url,
                verb: request.verb,
                contentType: request.contentType,
                payload: request.payload,
                relayProxyUrl: relayProxyUrlTextEditingController.text,
              );
            }

            networkingBloc.add(request);
          },
          tooltip: 'Request',
          child: const Icon(Icons.arrow_right),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
