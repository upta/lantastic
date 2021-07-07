import 'dart:math';

import 'package:app/data/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WheelService {
  final _db = FirebaseFirestore.instance;

  Future adjustWeights(
    WheelDoc wheel,
  ) async {
    await _db
        .doc(
          "wheels/${wheel.id}",
        )
        .set(
          Map<String, dynamic>.from({
            "options": wheel.options.map(
              (a) => {
                "child": a.child,
                "color": _colorToHex(a.color),
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
    await _db.doc("wheels/main").set(
          Map<String, dynamic>.from(
            {
              "selected": null,
              "spin": 0.0,
              "options": [
                {
                  "child": "aram",
                  "color": _colorToHex(Colors.blueAccent),
                  "label": "Aram",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.greenAccent),
                  "label": "GeoGuessr",
                  "weight": 1,
                },
                {
                  "child": "choice",
                  "color": _colorToHex(Colors.redAccent),
                  "label": "Choice",
                  "weight": 1,
                },
              ]
            },
          ),
        );

    await _db.doc("wheels/choice").set(
          Map<String, dynamic>.from(
            {
              "selected": null,
              "spin": 0.0,
              "options": [
                {
                  "color": _colorToHex(Colors.blueAccent.shade700),
                  "label": "Brian",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.orangeAccent.shade700),
                  "label": "Chris",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.greenAccent.shade700),
                  "label": "James",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.redAccent.shade700),
                  "label": "Dave",
                  "weight": 1,
                },
              ]
            },
          ),
        );

    await _db.doc("wheels/aram").set(
          Map<String, dynamic>.from(
            {
              "selected": null,
              "spin": 0.0,
              "options": [
                {
                  "color": _colorToHex(Colors.cyanAccent.shade400),
                  "label": "KDA",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.orangeAccent.shade400),
                  "label": "Assists",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.tealAccent.shade400),
                  "label": "Damage to Champions",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.limeAccent.shade700),
                  "label": "Damage Overall",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.pinkAccent.shade400),
                  "label": "Kills",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.indigoAccent.shade400),
                  "label": "Damage Mitigated",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.yellowAccent.shade700),
                  "label": "Gold",
                  "weight": 1,
                },
                {
                  "color": _colorToHex(Colors.purpleAccent.shade200),
                  "label": "Creep Score",
                  "weight": 1,
                },
              ]
            },
          ),
        );
  }

  Future spin(
    WheelDoc wheel,
  ) async {
    final spin = Random().nextDouble();
    final selected = _findSelectedOption(
      wheel.options,
      spin,
    );

    await _db
        .doc(
          "wheels/${wheel.id}",
        )
        .set(
          Map<String, dynamic>.from({
            "selected": selected.label,
            "spin": spin,
          }),
          SetOptions(
            merge: true,
          ),
        );
  }

  Stream<WheelDoc> stream(
    String wheelId,
  ) {
    return _db
        .doc(
          "wheels/$wheelId",
        )
        .snapshots()
        .map(
          (a) => WheelDoc.fromMap(
            id: a.id,
            data: a.data() as Map<String, dynamic>,
          ),
        );
  }

  String _colorToHex(Color color) => "#${color.value.toRadixString(16)}";

  WheelDocOption _findSelectedOption(
    List<WheelDocOption> options,
    double percent,
  ) {
    var sum = options
        .map((a) => a.weight)
        .reduce((value, element) => value + element);

    var min = 0.0;

    for (var option in options) {
      var portion = option.weight / sum;
      var max = min + portion;

      if (percent >= min && percent <= max) {
        return option;
      }

      min += portion;
    }

    throw Exception("No option selected, outside of bounds.");
  }
}
