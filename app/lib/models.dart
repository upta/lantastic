import 'dart:math';

import 'package:app/widgets/calculate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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
    selected =
        null; //data["selected"];  need to translate whatever we are storing in firestore to one of the option instances from the list
    spin = data["spin"];
  }

  late final String id;
  late final List<WheelDocOption> options;
  late final double spin;
  late final WheelDocOption? selected;
}

class WheelState with ChangeNotifier {
  WheelState({
    required this.options,
  });

  late List<WheelDocOption> options;
  WheelDocOption? selected;
  double spin = 0.0;

  void roll() {
    spin = Random().nextDouble();
    selected = WeightedAverage.findSelectedOption(options, spin);
    notifyListeners();
  }

  void adjustWeights() {
    options.forEach((option) {
      if (option != selected) {
        option.weight += 1;
      }
    });

    notifyListeners();
  }
}

class WheelService {
  DocumentReference ref = FirebaseFirestore.instance.doc("wheels/main");

  Stream<WheelDoc> stream() {
    return ref.snapshots().map(
          (a) => WheelDoc.fromMap(
            id: a.id,
            data: a.data() as Map<String, dynamic>,
          ),
        );
  }
}
