import 'package:app/models.dart';
import 'package:app/widgets/wheel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class WheelScreen extends StatelessWidget {
  WheelScreen({
    Key? key,
    required this.wheelId,
  }) : super(key: key);

  final String wheelId;
  final _labelKey = GlobalKey<_SelectedLabelState>();

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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ElevatedButton(
                    //   onPressed: () async =>
                    //       await wheelService.adjustWeights(wheel),
                    //   child: Text("wigeth"),
                    // ),
                    // ElevatedButton(
                    //   onPressed: wheelService.seed,
                    //   child: Text("seedith"),
                    // ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Wheel(
                            onSpinEnd: () async {
                              _labelKey.currentState?._controller.forward(
                                  from:
                                      0.0); // do it using didChangeDependencies
                              await Future.delayed(Duration(seconds: 3));

                              if (wheel.selected!.child != null) {
                                Navigator.of(context).pushNamed(
                                  "/",
                                  arguments: wheel.selected?.child,
                                );
                              }
                            },
                          ),
                          _SelectedLabel(
                            key: _labelKey,
                            label: wheel.selected?.label,
                          ),
                          _SpinButton(
                            onPressed: () async =>
                                await wheelService.roll(wheel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SelectedLabel extends StatefulWidget {
  _SelectedLabel({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String? label;
  final _state = _SelectedLabelState();

  void show() {
    _state._controller.forward(from: 0.0);
  }

  @override
  _SelectedLabelState createState() => _state;
}

class _SelectedLabelState extends State<_SelectedLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInExpo,
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: Alignment.center,
      child: Text(widget.label ?? ""),
    );
  }
}

class _SpinButton extends StatefulWidget {
  const _SpinButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  _SpinButtonState createState() => _SpinButtonState();
}

class _SpinButtonState extends State<_SpinButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInExpo,
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: Alignment.center,
      child: IconButton(
        icon: const Icon(Icons.accessible_forward_sharp),
        color: Colors.purpleAccent,
        iconSize: 120.0,
        onPressed: () {
          setState(() {
            widget.onPressed!();
            _controller.reverse();
          });
        },
      ),
    );
  }
}
