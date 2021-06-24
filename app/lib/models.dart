import 'dart:math';

import 'package:app/widgets/calculate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

@immutable
class WheelDocOption {
  WheelDocOption({
    required this.color,
    required this.label,
    required this.weight,
  });

  WheelDocOption.fromMap(
    Map data,
  ) {
    color = _hexStringToColor(data["color"]);
    label = data["label"];
    weight = data["weight"];
  }

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

class WheelService {
  final _db = FirebaseFirestore.instance;

  Stream<WheelDoc> stream(
    String wheelId,
  ) {
    return _db.doc("wheels/$wheelId").snapshots().map(
          (a) => WheelDoc.fromMap(
            id: a.id,
            data: a.data() as Map<String, dynamic>,
          ),
        );
  }

  Future roll(
    WheelDoc wheel,
  ) async {
    final spin = Random().nextDouble();
    final selected = WeightedAverage.findSelectedOption(
      wheel.options,
      spin,
    );

    await _db.doc("wheels/${wheel.id}").set(
          Map<String, dynamic>.from({
            "selected": selected.label,
            "spin": spin,
          }),
          SetOptions(
            merge: true,
          ),
        );
  }

  Future adjustWeights(
    WheelDoc wheel,
  ) async {
    await _db.doc("wheels/${wheel.id}").set(
          Map<String, dynamic>.from({
            "options": wheel.options.map(
              (a) => {
                "color": "#${a.color.value.toRadixString(16)}",
                "label": a.label,
                "weight": a.weight * (a != wheel.selected ? 2.5 : 1),
              },
            )
          }),
          SetOptions(
            merge: true,
          ),
        );
  }

  void seed() async {
    await _db.doc("wheels/main").set(Map<String, dynamic>.from({
          "selected": null,
          "spin": 0.0,
          "options": [
            {
              "color": "#FF0000",
              "label": "Aram",
              "weight": 1,
            },
            {
              "color": "#00FF00",
              "label": "GeoGuessr",
              "weight": 1,
            },
            {
              "color": "#0000FF",
              "label": "Choice",
              "weight": 1,
            },
          ]
        }));
  }
}
