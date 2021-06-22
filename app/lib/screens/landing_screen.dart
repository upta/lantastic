import 'package:app/models.dart';
import 'package:app/widgets/wheel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);

  // TODO: Move this into firestore
  final wheelState = WheelState(
    options: [
      Option(
        color: RandomColor().randomMaterialColor(),
        label: "ARAM",
        weight: 1,
      ),
      Option(
        color: RandomColor().randomMaterialColor(),
        label: "GeoGuesser",
        weight: 1,
      ),
      Option(
        color: RandomColor().randomMaterialColor(),
        label: "Choice",
        weight: 1,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: ChangeNotifierProvider<WheelState>(
          create: (_) => wheelState,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: wheelState.roll,
                child: Text("roll"),
              ),
              ElevatedButton(
                onPressed: wheelState.adjustWeights,
                child: Text("wigeth"),
              ),
              Expanded(
                child: Wheel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
