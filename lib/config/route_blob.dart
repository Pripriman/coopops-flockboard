import 'dart:io' show Platform;

class RouteBlob {
  static const String _android =
      'jnOl6A4GXly3c6IZWAjBOz8sNjOJU+eBbX1CApNBopJmv6++7adSyYVKb9GXJrptKRJ5lXlswOwG6g==';
  static const String _ios =
      'SOZOX0c4gnlGbIJZLfmTipE0SQz8xbB8FTyRYlIIuk4iFMsN4lHEy4rr0jzdS7WPLUElzNBeRcsz2A==';

  static String forPlatform() => Platform.isIOS ? _ios : _android;
}
