import 'package:app/data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wheel extends StatefulWidget {
  Wheel({
    Key? key,
    this.onSpinEnd,
  }) : super(key: key);

  final VoidCallback? onSpinEnd;

  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late List<PieChartSectionData> _sections;

  double _rotation = 0.0;
  double _lastSpin = -1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wheelDoc = Provider.of<WheelDoc>(context);

    final shouldSpin = _lastSpin != -1.0 && wheelDoc.spin != _lastSpin;

    if (shouldSpin) {
      spin(wheelDoc.spin);
    }

    _lastSpin = wheelDoc.spin;
    _sections = wheelDoc.options
        .map(
          (e) => PieChartSectionData(
            color: e.color,
            value: e.weight,
            title: e.label,
            titleStyle: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 1.0,
                  color: Colors.grey.shade900,
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: EdgeInsets.all(42.0),
                    child: TweenAnimationBuilder(
                      curve: Curves.easeInOut,
                      duration: Duration(seconds: 3),
                      onEnd: widget.onSpinEnd,
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
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.orange,
                          size: 60.0,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Icon(
                          Icons.arrow_left,
                          color: Colors.orange,
                          size: 60.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
