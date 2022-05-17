import 'package:networking/networking.dart';
import 'package:test/test.dart';

void main() {
  group(
    'request',
    () {
      group(
        'http verb',
        () {
          test(
            'value function always returns the name of the verb in lowercase',
            () {
              final lowercaseVerbs = [
                'get',
                'post',
                'put',
                'patch',
                'delete',
              ]..sort();

              final verbValues = HttpVerb.values.map((e) => e.value).toList()
                ..sort();

              expect(
                lowercaseVerbs,
                equals(verbValues),
              );
            },
          );
        },
      );
    },
  );
}
