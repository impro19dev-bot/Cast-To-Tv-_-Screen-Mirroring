import 'package:flutter_test/flutter_test.dart';

import 'package:cast_screen_mirroring/core/utils/media_link_rules.dart';
import 'package:cast_screen_mirroring/core/utils/url_tools.dart';

void main() {
  test('normalizes browser URLs', () {
    expect(UrlTools.normalizeBrowserUrl('example.com'), 'https://example.com');
    expect(UrlTools.normalizeBrowserUrl(''), isNull);
  });

  test('validates YouTube and Vimeo links', () {
    expect(
      MediaLinkRules.isValid(
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        StreamPlatform.youtube,
      ),
      isTrue,
    );
    expect(
      MediaLinkRules.isValid('https://vimeo.com/123456789', StreamPlatform.vimeo),
      isTrue,
    );
    expect(
      MediaLinkRules.isValid('https://example.com', StreamPlatform.youtube),
      isFalse,
    );
  });
}
