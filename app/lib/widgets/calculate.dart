import 'package:app/models.dart';

class WeightedAverage {
  static Option findSelectedOption(
    OptionGroup group,
    double percent,
  ) {
    // add validation that group has options
    // and percent is between 0.0 and 1.0

    var sum = group.options
        .map((a) => a.weight)
        .reduce((value, element) => value + element);

    var min = 0.0;

    for (var option in group.options) {
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
