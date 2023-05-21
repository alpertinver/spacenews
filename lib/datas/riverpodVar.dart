import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacenews/main.dart';

final InitialLinkProvider = StateProvider<String>((ref) {
  String link =
      'https://api.spaceflightnewsapi.net/v4/articles/?format=json&has_event=true&has_launch=true&limit=20';
  return link;
});

final PreviousLinkProvider = StateProvider<String>((ref) {
  String link =
      'https://api.spaceflightnewsapi.net/v4/articles/?format=json&has_event=true&has_launch=true&limit=20';
  return link;
});

final NextLinkProvider = StateProvider<String>((ref) {
  String link =
      'https://api.spaceflightnewsapi.net/v4/articles/?format=json&has_event=true&has_launch=true&limit=20';
  return link;
});

final DatalarMapFProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  var a;

  return a;
});

final CountProvider = StateProvider<int>((ref) {
  int a = 5;
  return a;
});

final GosterProvider = StateProvider<dynamic>((ref) {
  var a;
  return a;
});

final DisclaimerTFProvider = StateProvider<bool>((ref) {
  var a;
  a = false;
  return a;
});

class MapDatasToPage {
  final TitleProvider = StateProvider<String>((ref) {
    var Title = 'a';
    return Title;
  });

  final ImageUrlProvider = StateProvider<String>((ref) {
    var ImageUrl = 'a';
    return ImageUrl;
  });

  final SummaryProvider = StateProvider<String>((ref) {
    var Summary = 'a';
    return Summary;
  });
  final NewsSiteProvider = StateProvider<String>((ref) {
    var NewsSite = 'a';
    return NewsSite;
  });

  final PublishTimeProvider = StateProvider<String>((ref) {
    var publishtimeD = 'a';
    return publishtimeD;
  });

  final UrlDProvider = StateProvider<String>((ref) {
    var UrlDp = 'a';
    return UrlDp;
  });
}
