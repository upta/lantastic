import 'package:app/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class Chart extends StatelessWidget {
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

  late final List<PieChartSectionData> _sections;
  final _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TweenAnimationBuilder(
        curve: Curves.easeInOut,
        duration: Duration(seconds: 3),
        tween: Tween<double>(
          begin: 0.0,
          end: 720,
        ),
        builder: (_, double angle, __) {
          return PieChart(PieChartData(
            sections: _sections,
            startDegreeOffset: angle,
          ));
        },
      ),
    );
  }
}
