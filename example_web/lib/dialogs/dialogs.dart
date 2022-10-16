import 'package:example_web/blocs/blocs.dart';
import 'package:flutter/material.dart';

class BackgroundlessCircularProgressIndicatorDialog extends StatelessWidget {
  const BackgroundlessCircularProgressIndicatorDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class NetworkingRequestSuccessDialog extends StatelessWidget {
  final NetworkingRequestSuccess result;

  const NetworkingRequestSuccessDialog({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Response'),
      children: [
        TextFormField(
          initialValue: result.status.toString(),
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Status',
            prefixIcon: Icon(Icons.info),
            border: InputBorder.none,
          ),
        ),
        if (result.isImage)
          Image.memory(result.body)
        else
          TextFormField(
            initialValue: result.bodyDecoded ?? result.body.toString(),
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Body',
              prefixIcon: Icon(Icons.code),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        if (result.headers.isNotEmpty)
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Headers',
              prefixIcon: Icon(Icons.highlight),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ...result.headers.entries.map(
          (e) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: TextFormField(
                        initialValue: e.key,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: TextFormField(
                        initialValue: e.value,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class NetworkingRequestFailureDialog extends StatelessWidget {
  final NetworkingRequestFailure result;

  const NetworkingRequestFailureDialog({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        TextFormField(
          initialValue: result.reason,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Reason',
            prefixIcon: Icon(Icons.info),
            border: InputBorder.none,
          ),
        ),
        TextFormField(
          initialValue: result.stackTrace.toString(),
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Stacktrace',
            prefixIcon: Icon(Icons.error),
            border: InputBorder.none,
          ),
          maxLines: 5,
        ),
      ],
    );
  }
}

void showAppDialog({
  required BuildContext context,
  required Widget Function(BuildContext) dialogBuilder,
  RouteSettings? routeSettings,
  bool barrierDismissible = false,
}) {
  showDialog(
    context: context,
    builder: dialogBuilder,
    routeSettings: routeSettings,
    barrierDismissible: barrierDismissible,
  );
}
