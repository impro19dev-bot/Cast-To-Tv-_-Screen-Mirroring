enum StreamPlatform { youtube, vimeo }

abstract final class MediaLinkRules {
  static bool isValid(String input, StreamPlatform platform) {
    return switch (platform) {
      StreamPlatform.youtube => _isYoutube(input),
      StreamPlatform.vimeo => _isVimeo(input),
    };
  }

  static String? normalize(String input, StreamPlatform platform) {
    final trimmed = input.trim();
    if (!isValid(trimmed, platform)) return null;
    final uri = _parse(trimmed)!;
    return switch (platform) {
      StreamPlatform.youtube => _normalizeYoutube(uri),
      StreamPlatform.vimeo => _normalizeVimeo(uri),
    };
  }

  static String hint(StreamPlatform platform) => switch (platform) {
        StreamPlatform.youtube => 'https://www.youtube.com/watch?v=...',
        StreamPlatform.vimeo => 'https://vimeo.com/123456789',
      };

  static String label(StreamPlatform platform) => switch (platform) {
        StreamPlatform.youtube => 'YouTube',
        StreamPlatform.vimeo => 'Vimeo',
      };

  static bool _isYoutube(String input) {
    final uri = _parse(input);
    if (uri == null) return false;
    final host = uri.host.replaceFirst('www.', '').toLowerCase();
    if (host == 'youtu.be') return uri.pathSegments.isNotEmpty;
    if (host == 'youtube.com' || host == 'm.youtube.com') {
      if (uri.pathSegments.isEmpty) return false;
      if (uri.pathSegments.first == 'watch') {
        return uri.queryParameters.containsKey('v');
      }
      return {'embed', 'shorts', 'live'}.contains(uri.pathSegments.first);
    }
    return false;
  }

  static bool _isVimeo(String input) {
    final uri = _parse(input);
    if (uri == null) return false;
    final host = uri.host.replaceFirst('www.', '').toLowerCase();
    if (host != 'vimeo.com' && host != 'player.vimeo.com') return false;
    final id = _vimeoId(uri);
    return id != null && RegExp(r'^\d+$').hasMatch(id);
  }

  static Uri? _parse(String input) {
    final value = input.trim();
    if (value.isEmpty) return null;
    final withScheme = value.contains('://') ? value : 'https://$value';
    return Uri.tryParse(withScheme);
  }

  static String _normalizeYoutube(Uri uri) {
    final host = uri.host.replaceFirst('www.', '').toLowerCase();
    if (host == 'youtu.be') {
      return 'https://www.youtube.com/watch?v=${uri.pathSegments.first}';
    }
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'watch') {
      return 'https://www.youtube.com/watch?v=${uri.queryParameters['v']}';
    }
    return uri.replace(scheme: 'https').toString();
  }

  static String _normalizeVimeo(Uri uri) {
    return 'https://vimeo.com/${_vimeoId(uri)}';
  }

  static String? _vimeoId(Uri uri) {
    if (uri.host.contains('player.vimeo.com') &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'video') {
      return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
    }
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
  }
}
