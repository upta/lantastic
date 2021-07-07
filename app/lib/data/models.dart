import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

@immutable
class WheelDocOption {
  WheelDocOption({
    required this.child,
    required this.color,
    required this.label,
    required this.weight,
  });

  WheelDocOption.fromMap(
    Map data,
  ) {
    child = data["child"];
    color = _hexStringToColor(data["color"]);
    label = data["label"];
    weight = data["weight"];
  }

  late final String? child;
  late final Color color;
  late final String label;
  late final double weight;

  static _hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}

@immutable
class WheelDoc {
  WheelDoc({
    required this.id,
    required this.options,
    required this.selected,
    required this.spin,
  });

  WheelDoc.fromMap({
    required this.id,
    required Map<String, dynamic> data,
  }) {
    options = List<WheelDocOption>.from(
      (data["options"] as List).map(
        (e) => WheelDocOption.fromMap(e),
      ),
    );
    selected = options.firstWhereOrNull((a) => a.label == data["selected"]);
    spin = data["spin"];
  }

  late final String id;
  late final List<WheelDocOption> options;
  late final double spin;
  late final WheelDocOption? selected;
}
