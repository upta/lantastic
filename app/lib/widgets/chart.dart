import 'dart:math';

import 'package:app/models.dart';
import 'package:app/widgets/calculate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class Chart extends StatefulWidget {
  Chart({
    Key? key,
    required this.optionGroup,
  }) : super(key: key) {
    _sections = optionGroup.options
        .map(
          (e) => PieChartSectionData(
            color: _randomColor.randomMaterialColor(),
            value: e.weight,
            title: e.label,
          ),
        )
        .toList();
  }

  final OptionGroup optionGroup;
  final _randomColor = RandomColor();

  late final List<PieChartSectionData> _sections;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Option? _selected;

  double _rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(_rotation.toString()),
          Text(
            _selected?.label ?? "Nothing Selected",
          ),
          ElevatedButton(
            onPressed: roll,
            child: Text("roll"),
          ),
          Expanded(
            child: TweenAnimationBuilder(
              curve: Curves.easeInOut,
              duration: Duration(seconds: 3),
              tween: Tween<double>(
                begin: 0.0,
                end: _rotation,
              ),
              builder: (_, double angle, __) {
                return PieChart(PieChartData(
                  sections: widget._sections,
                  startDegreeOffset: angle,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  void roll() {
    setState(() {
      final percent = Random().nextDouble();

      _selected = WeightedAverage.findSelectedOption(
        widget.optionGroup,
        percent,
      );

      var adjustment = 360 - (_rotation % 360);

      _rotation += adjustment + (720 - (percent * 360));
    });
  }
}
