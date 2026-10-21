import 'package:flutter/foundation.dart';
import 'models/event.dart';
import 'models/profile.dart';

class Routes {
  static const shell = '/';
  static const detail = '/detail';
  static const form = '/form';
}

class DetailArgs {
  const DetailArgs({
    required this.event,
    required this.profile,
    required this.onUpdate,
    required this.goToProfile,
  });
  final Event event;
  final Profile profile;
  final void Function(Event) onUpdate;
  final VoidCallback goToProfile;
}