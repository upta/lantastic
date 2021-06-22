import 'package:app/models.dart';
import 'package:app/widgets/wheel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);

  final WheelService _wheelService = WheelService();

  final wheelState = WheelState(
    options: [
      WheelDocOption(
        color: Colors.brown[800]!,
        label: "ARAM",
        weight: 1,
      ),
      WheelDocOption(
        color: RandomColor().randomMaterialColor(),
        label: "GeoGuesser",
        weight: 1,
      ),
      WheelDocOption(
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
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<WheelState>(
              create: (_) => wheelState,
            ),
            Provider<WheelService>(
              create: (_) => _wheelService,
            ),
            StreamProvider<WheelDoc?>.value(
              value: _wheelService.stream(),
              initialData: null,
            ),
          ],
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
