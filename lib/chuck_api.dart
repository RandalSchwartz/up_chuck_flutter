import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;
import 'dart:math' hide log;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final _clientProvider = Provider<http.Client>(
  (ref) {
    log('building clientProvider');
    return http.Client();
  },
);

const _categories = [
  "animal",
  "career",
  "celebrity",
  "dev",
  "fashion",
  "food",
  "history",
  "money",
  "movie",
  "music",
  "political",
  "religion",
  "science",
  "sport",
  "travel",
];

final _chuckAPIUrl = Uri.https(
  'api.chucknorris.io',
  '/jokes/random',
);

final _random = Random();

final getChuckProvider = FutureProvider<String>(
  (ref) async {
    log('building getChuckProvider');
    // throw Exception('test');
    await Future.delayed(const Duration(seconds: 3));
    final client = ref.watch(_clientProvider);
    final category = _categories[_random.nextInt(_categories.length)];
    log('category: $category');
    final response = await client.get(
      _chuckAPIUrl.replace(
        queryParameters: {
          'category': category,
        },
      ),
    );

    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      return data['value'] as String;
    }
    throw Exception('value is missing in $data');
  },
);
