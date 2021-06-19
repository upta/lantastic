import 'package:app/models.dart';
import 'package:app/widgets/chart.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = OptionGroup(options: [
      Option(
        label: "ARAM",
        weight: 1,
      ),
      Option(
        label: "GeoGuesser",
        weight: 1,
      ),
      Option(
        label: "Choice",
        weight: 1,
      ),
    ]);

    return Container(
      child: Scaffold(
        body: Chart(
          optionGroup: options,
        ),
      ),
    );
  }
}
