class Option {
  Option({
    required this.label,
    required this.weight,
  });

  Option.fromMap(
    Map data,
  ) {
    label = data["label"];
    weight = data["weight"];
  }

  late final String label;
  late final double weight;
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
