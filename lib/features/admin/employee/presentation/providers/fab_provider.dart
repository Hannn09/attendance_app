import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class FabConfig {
  final bool visible;
  final VoidCallback? onPressed;

  const FabConfig({this.visible = false, this.onPressed});

  FabConfig copyWith({bool? visible, VoidCallback? onPressed}) {
    return FabConfig(
      visible: visible ?? this.visible,
      onPressed: onPressed ?? this.onPressed,
    );
  }
}

class FabNotifier extends StateNotifier<FabConfig> {
  FabNotifier() : super(const FabConfig());

  void show(VoidCallback onPressed) =>
      state = FabConfig(visible: true, onPressed: onPressed);

  void hide() => state = const FabConfig(visible: false);
}

final fabProvider = StateNotifierProvider<FabNotifier, FabConfig>(
  (ref) => FabNotifier(),
);
