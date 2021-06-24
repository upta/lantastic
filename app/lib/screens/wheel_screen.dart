import 'package:app/models.dart';
import 'package:app/widgets/wheel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WheelScreen extends StatelessWidget {
  WheelScreen({
    Key? key,
    required this.wheelId,
  }) : super(key: key);

  final String wheelId;

  @override
  Widget build(BuildContext context) {
    final wheelService = Provider.of<WheelService>(context, listen: false);

    return Container(
      child: Scaffold(
        body: StreamBuilder<WheelDoc?>(
          stream: wheelService.stream(wheelId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }

            final wheel = snapshot.data!;

            return Provider<WheelDoc>.value(
              value: wheel,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async => await wheelService.roll(wheel),
                    child: Text("roll"),
                  ),
                  ElevatedButton(
                    onPressed: () async =>
                        await wheelService.adjustWeights(wheel),
                    child: Text("wigeth"),
                  ),
                  ElevatedButton(
                    onPressed: wheelService.seed,
                    child: Text("seedith"),
                  ),
                  Expanded(
                    child: Wheel(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
