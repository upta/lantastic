import 'package:app/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wheel extends StatefulWidget {
  Wheel({
    Key? key,
  }) : super(key: key) {}

  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late List<PieChartSectionData> _sections;
  WheelState? _wheelState;

  double _rotation = 0.0;
  double _lastSpin = -1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wheelState = Provider.of<WheelState>(context);
    final shouldSpin = _wheelState != null && wheelState.spin != _lastSpin;

    if (shouldSpin) {
      spin(wheelState.spin);
      _lastSpin = wheelState.spin;
    }

    _wheelState = wheelState;
    updateSections();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            _wheelState?.selected?.label ?? "Nothing Selected",
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
                return PieChart(
                  PieChartData(
                    sections: _sections,
                    startDegreeOffset: angle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void spin(double percent) {
    setState(() {
      var adjustment = 360 - (_rotation % 360);

      _rotation += adjustment + (720 - (percent * 360));
    });
  }

  void updateSections() {
    _sections = _wheelState!.options
        .map(
          (e) => PieChartSectionData(
            color: e.color,
            value: e.weight,
            title: e.label,
          ),
        )
        .toList();
  }
}
