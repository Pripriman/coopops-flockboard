import 'dart:io' show Platform;

class RouteBlob {
  static const String _android =
      'Y29vY0RHOXdjMTl5YjI5emRDOXdiR0YwWm05eWJRcmM3SHBoY205dmMzUmZjMlZ5ZG1WeQ';
  static const String _ios =
      'Y2k5dmN5OXliMjl6ZEY5d2JHRjBabTl5YlFyYzdIcGhjbTl2YzNSZmMyVnlkbVZ5YzJsdg';

  static String forPlatform() => Platform.isIOS ? _ios : _android;
}
