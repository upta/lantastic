import 'package:app/data.dart';
import 'package:app/widgets/wheel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class WheelScreen extends StatefulWidget {
  WheelScreen({
    Key? key,
    required this.wheelId,
  }) : super(key: key);

  final String wheelId;

  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  bool _isSpinShown = true;
  bool _isResultShown = false;

  @override
  Widget build(BuildContext context) {
    final wheelService = Provider.of<WheelService>(context, listen: false);

    return Container(
      child: Scaffold(
        body: StreamBuilder<WheelDoc?>(
          stream: wheelService.stream(widget.wheelId),
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
                    //   onPressed: wheelService.seed,
                    //   child: Text("seedith"),
                    // ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Wheel(
                            onSpinEnd: () async {
                              setState(() {
                                _isResultShown = true;
                              });

                              await Future.delayed(Duration(seconds: 1));
                              await wheelService.adjustWeights(wheel);
                              await Future.delayed(Duration(seconds: 1));

                              if (wheel.selected!.child != null) {
                                Navigator.of(context).pushNamed(
                                  "/",
                                  arguments: wheel.selected?.child,
                                );
                              }
                            },
                          ),
                          AnimatedVisibility(
                            child: Text(
                              wheel.selected?.label ?? "",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            isVisible: _isResultShown,
                          ),
                          AnimatedVisibility(
                            child: IconButton(
                              icon: const Icon(Icons.rotate_right),
                              color: Colors.white70,
                              iconSize: 120.0,
                              onPressed: () async {
                                setState(() {
                                  _isSpinShown = false;
                                });
                                await wheelService.roll(wheel);
                              },
                            ),
                            isVisible: _isSpinShown,
                          )
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

class AnimatedVisibility extends StatefulWidget {
  AnimatedVisibility({
    Key? key,
    required this.child,
    required this.isVisible,
  }) : super(key: key);

  final Widget child;
  final bool isVisible;

  @override
  _AnimatedVisibilityState createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
      value: widget.isVisible ? 1.0 : 0.0,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: Alignment.center,
      child: widget.child,
    );
  }
}
