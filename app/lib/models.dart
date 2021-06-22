import 'dart:math';

import 'package:app/widgets/calculate.dart';
import 'package:flutter/cupertino.dart';

class Option {
  Option({
    required this.color,
    required this.label,
    required this.weight,
  });

  Option.fromMap(
    Map data,
  ) {
    color = data["color"]; // TODO: fix this when firebasing it
    label = data["label"];
    weight = data["weight"];
  }

  late Color color;
  late String label;
  late double weight;
}

class OptionGroup {
  OptionGroup({
    required this.options,
  });

  OptionGroup.fromMap(
    Map data,
  ) {
    options = data["options"];
  }

  late final List<Option> options;
}

class WheelState with ChangeNotifier {
  WheelState({
    required this.options,
  });

  late List<Option> options;
  Option? selected;
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
