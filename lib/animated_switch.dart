library animated_switch;

import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

/// Customable and attractive Switch button.
/// You can change the widget
/// [width] and [height] properties.
///
/// As well as the classical Switch Widget
/// from flutter material, the following
/// arguments are required:
///
/// * [value] determines whether this switch is on or off.
/// * [onChanged] is called when the user toggles the switch on or off.
///
/// If you don't set these arguments you would
/// experiment errors related to animationController
/// states or any other undesirable behavior, please
/// don't forget to set them.
///
class AnimatedSwitch extends StatefulWidget {
  // Initial value
  final bool value;
  // Colors
  final Color colorOn;
  final Color colorOff;
  final Color indicatorColor;
  // Animation
  final Duration animationDuration;
  // Icons
  final IconData? iconOn;
  final IconData? iconOff;
  // Size
  final double? width;
  final double? height;
  // Text
  final String? textOff;
  final String? textOn;
  final TextStyle? textStyle;
  // Callbacks
  final Function? onTap;
  final Function? onDoubleTap;
  final Function? onSwipe;
  final Function(bool value)? onChanged;

  const AnimatedSwitch(
      {Key? key,
      this.value = false,
      this.textOff,
      this.textOn,
      this.colorOn = Colors.green,
      this.colorOff = Colors.red,
      this.indicatorColor = Colors.white,
      this.iconOff,
      this.iconOn,
      this.animationDuration = const Duration(milliseconds: 300),
      this.width,
      this.height,
      this.textStyle,
      this.onTap,
      this.onDoubleTap,
      this.onSwipe,
      this.onChanged})
      : super(key: key);

  @override
  AnimatedSwitchState createState() => AnimatedSwitchState();
}

class AnimatedSwitchState extends State<AnimatedSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _animation;
  double _animationValue = 0.0;

  late bool value;

  // Sizes
  static const double _defaultHeight = 15;
  late final double _height;
  late final double _width;
  late final double _borderRadius;
  late final double _textWidth;
  late final double _textHorizontalPadding;
  late final double _iconSize;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, lowerBound: 0.0, upperBound: 1.0, duration: widget.animationDuration);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.addListener(() {
      setState(() {
        if (_animation != null) _animationValue = _animation!.value;
      });
    });
    value = widget.value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setSwitchState();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Setting sizes
    final TextStyle? textStyle = widget.textStyle ?? DefaultTextStyle.of(context).style;
    final double textHeight = textStyle?.fontSize ?? _defaultHeight;
    _height = (widget.height != null && widget.height! > textHeight) ? widget.height! : textHeight * 1.5;
    _width = (widget.width != null && widget.width! > _height) ? widget.width! : _height * 2.5;
    _borderRadius = _height / 2;
    _textHorizontalPadding = _height / 10;
    _textWidth = _width - _height;
    _iconSize = _height * .75;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color? transitionColor = Color.lerp(widget.colorOff, widget.colorOn, _animationValue);

    final double opacityOff = 1 - _animationValue;
    final double opacityOn = _animationValue;

    Widget? icons;

    if (widget.iconOff != null || widget.iconOn != null) {
      icons = Container(
        height: _height - 2,
        width: _height - 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.indicatorColor),
        child: Stack(
          children: [
            if (widget.iconOff != null) _buildIconWidget(icon: widget.iconOff!, opacity: opacityOn, color: transitionColor),
            if (widget.iconOn != null) _buildIconWidget(icon: widget.iconOn!, opacity: opacityOff, color: transitionColor),
          ],
        ),
      );
    }

    Widget indicator = Container(
      height: _height - 2,
      width: _height - 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.indicatorColor),
      child: icons,
    );

    if (icons != null) {
      indicator = Transform.rotate(
        angle: lerpDouble(0, 2 * pi, _animationValue) ?? 0,
        child: indicator,
      );
    }

    return GestureDetector(
      onDoubleTap: () {
        _action();
        if (widget.onDoubleTap != null) widget.onDoubleTap!();
      },
      onTap: () {
        _action();
        if (widget.onTap != null) widget.onTap!();
      },
      onPanEnd: (details) {
        _action();
        if (widget.onSwipe != null) widget.onSwipe!();
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(1),
          width: _width,
          height: _height,
          decoration: BoxDecoration(color: transitionColor, borderRadius: BorderRadius.circular(_borderRadius)),
          child: Stack(
            children: [
              if (widget.textOff != null) _buildTextWidget(right: true, opacity: opacityOff, offset: _animationValue, text: widget.textOff!),
              if (widget.textOn != null) _buildTextWidget(right: false, opacity: opacityOn, offset: 1 - _animationValue, text: widget.textOn!),
              Positioned(
                left: (_textWidth) * _animationValue,
                child: indicator,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Building widgets
  Widget _buildIconWidget({required IconData icon, required double opacity, Color? color}) => Center(
      child: Opacity(
          opacity: opacity,
          child: Icon(
            icon,
            size: _iconSize,
            color: color,
          )));

  Widget _buildTextWidget({required bool right, required double opacity, required double offset, required String text}) => Positioned(
        right: right ? 0 : null,
        left: right ? null : 0,
        top: 0,
        bottom: 0,
        child: Transform.translate(
          offset: Offset(10 * offset, 0), //original
          child: Opacity(
            opacity: opacity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: _textHorizontalPadding),
              alignment: Alignment.center,
              width: _textWidth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: widget.textStyle,
                ),
              ),
            ),
          ),
        ),
      );

  _action() {
    _setSwitchState(changeState: true);
  }

  _setSwitchState({bool changeState = false}) {
    setState(() {
      if (changeState) value = !value;
      (value) ? _animationController.forward() : _animationController.reverse();

      if (widget.onChanged != null) widget.onChanged!(value);
    });
  }
}
