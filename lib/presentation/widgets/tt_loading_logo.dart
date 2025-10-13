import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TtLoadingLogo extends StatefulWidget {
  final Duration duration;
  final double minScale;
  final double maxScale;

  const TtLoadingLogo({
    super.key,

    this.duration = const Duration(milliseconds: 800),
    this.minScale = 0.8,
    this.maxScale = 1.2,
  });

  @override
  TtLoadingLogoState createState() => TtLoadingLogoState();
}

class TtLoadingLogoState extends State<TtLoadingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: SvgPicture.asset('assets/images/tt_ico.svg', height: 80),
      ),
    );
  }
}
