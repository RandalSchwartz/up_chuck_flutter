import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chuck_api.dart';

Future<void> main() async {
  // something to keep them entertained during initialization
  runApp(const Center(child: CircularProgressIndicator()));

  // initialize riverpod and wait until we have a quote
  final container = ProviderContainer();
  await container.read(getChuckProvider.future);

  // now run the app, holding on to the riverpod container
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(getChuckProvider);

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => ref.refresh(getChuckProvider),
          child: Center(
            child: FractionallySizedBox(
              heightFactor: 0.9,
              widthFactor: 0.9,
              child: Column(
                children: [
                  const Text('tap to refresh'),
                  Expanded(
                    child: Center(
                      child: quote.when(
                        data: (String data) {
                          final dotdot = quote.isRefreshing ? '\n...' : '';
                          return Text(
                            '$data$dotdot',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          );
                        },
                        error: (Object error, StackTrace? stackTrace) {
                          return Text('error: $error\nstackTrace: $stackTrace');
                        },
                        loading: () {
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  const Text(
                    'courtesy of https://api.chucknorris.io\n'
                    'source available at https://github.com/RandalSchwartz/up_chuck_flutter',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
