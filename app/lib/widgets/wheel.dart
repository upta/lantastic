import 'package:app/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wheel extends StatefulWidget {
  Wheel({
    Key? key,
  }) : super(key: key);

  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late List<PieChartSectionData> _sections;

  double _rotation = 0.0;
  double _lastSpin = -1.0;
  String _selected = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wheelDoc = Provider.of<WheelDoc>(context);

    final shouldSpin = wheelDoc.spin != _lastSpin;

    if (shouldSpin) {
      spin(wheelDoc.spin);
      _lastSpin = wheelDoc.spin;
    }

    _selected = wheelDoc.selected?.label ?? "Nothing Selected";

    _sections = wheelDoc.options
        .map(
          (e) => PieChartSectionData(
            color: e.color,
            value: e.weight,
            title: e.label,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            _selected,
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
}
