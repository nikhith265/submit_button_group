import 'package:flutter/material.dart';
import 'package:submit_button_group/submit_button_group.dart';

class SubmitButtonsGroup extends StatefulWidget with ButtonConstants {
  ///Create a custom [Widget] to display a group of two buttons with an in-build loading action.
  ///In default Widget shows two buttons, the primary button and the secondary button.
  /// The primary button shows the nature of a submit button and the secondary button shows the nature of a close button.
  ///  Both are customizable and perform as needed.

  ///[loading] accepts a [ValueNotifier] with value [bool], which determines
  /// wether to display a [loaderWidget] or buttons.
  ///if the veritable is [Null],[Widget] performs as an ordinary buttons.
  final ValueNotifier<bool>? loading;

  ///[onSubmit] create a [VoidCallback] in primary button on click action.
  ///this can't be [Null].
  final VoidCallback onSubmit;

  ///[onCancel] create a [VoidCallback] in secondary button on click action.
  ///On null [Widget] default Call back action will be performed.
  final VoidCallback? onCancel;

  ///[secondaryButtonColor] add a color to the secondary button.
  ///On null default color [ButtonConstants.secondaryButtonColor] will be used.
  final Color? secondaryButtonColor;

  ///[secondaryButtonText] add a text to the secondary button.
  ///On null default text [ButtonConstants.secondaryButtonText] will be used.
  final String? secondaryButtonText;

  ///[secondaryButtonTextStyle] add a text style to the secondary button text.
  ///On null default text style [ButtonConstants.secondaryButtonText] will be used.
  final TextStyle? secondaryButtonTextStyle;

  ///[primeButtonColor] add a color to the primary button.
  ///On null default color [ButtonConstants.secondaryButtonColor] will be used.
  final Color? primeButtonColor;

  ///[primeButtonText] add a text to the primary button.
  ///On null default text [ButtonConstants.primeButtonText] will be used.
  final String? primeButtonText;

  ///[primeButtonTextStyle] add a text style to the primary button text.
  ///On null default text [ButtonConstants.primeButtonTextStyle] will be used.
  final TextStyle? primeButtonTextStyle;

  ///[groupElevation] add a elevation to the buttons.
  ///On null default elevation [ButtonConstants.groupElevation] will be used.
  final double? groupElevation;

  ///[crossAxisWidth] sets the width between two buttons.
  ///On null default width [ButtonConstants.crossAxisWidth] will be used.
  final double? crossAxisWidth;

  ///[hidePrimeButton] accepts a [bool], hides primary button if [value] is true.
  final bool hidePrimeButton;

  ///[hideSecondaryButton] accepts a [bool], hides secondary button if [value] is true.
  final bool hideSecondaryButton;

  ///[isExpand] accepts a [bool], sets button to accept maximum available width if [value] is true.
  final bool isExpand;

  ///[buttonSize] set size of buttons.
  ///use default if [value] is [Null].
  final Size? buttonSize;

  ///[loaderWidget] shows on loading,
  ///on [Null] shows default [CircularProgressIndicator].
  final Widget? loaderWidget;

  ///[primeButtonIcon] add a icon to the primary button.
  final Widget? primeButtonIcon;

  ///[secondaryButtonIcon] add a icon to the secondary button.
  final Widget? secondaryButtonIcon;

  ///[buttonShape] add a shape to the buttons.
  final OutlinedBorder? buttonShape;

  ///[primeButtonGradient] add a gradient to the primary button.
  final Gradient? primeButtonGradient;

  ///[secondaryButtonGradient] add a gradient to the secondary button.
  final Gradient? secondaryButtonGradient;

  const SubmitButtonsGroup(
      {Key? key,
      this.loading,
      required this.onSubmit,
      this.onCancel,
      this.buttonSize,
      this.hidePrimeButton = false,
      this.hideSecondaryButton = false,
      this.isExpand = false,
      this.crossAxisWidth = ButtonConstants.crossAxisWidth,
      this.groupElevation = ButtonConstants.groupElevation,
      this.secondaryButtonText = ButtonConstants.secondaryButtonText,
      this.secondaryButtonTextStyle = ButtonConstants.secondaryButtonTextStyle,
      this.primeButtonColor = ButtonConstants.primeButtonColor,
      this.secondaryButtonColor = ButtonConstants.secondaryButtonColor,
      this.primeButtonText = ButtonConstants.primeButtonText,
      this.primeButtonTextStyle = ButtonConstants.primeButtonTextStyle,
      this.loaderWidget,
      this.primeButtonIcon,
      this.secondaryButtonIcon,
      this.buttonShape,
      this.primeButtonGradient,
      this.secondaryButtonGradient})
      : super(key: key);

  @override
  State<SubmitButtonsGroup> createState() => _SubmitButtonsGroup();
}

class _SubmitButtonsGroup extends State<SubmitButtonsGroup> {
  bool _loading = false;
  @override
  void initState() {
    if (_isLoadingAvailable()) {
      widget.loading!.addListener(_handleLoading);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? _buildLoading() : _buildButtons();
  }

  Widget _buildLoading() => Center(
      child: widget.loaderWidget ?? const CircularProgressIndicator.adaptive());

  Widget _buildButtons() {
    Widget _secondaryButton = _buildSecondaryButton();
    Widget _primaryButton = _buildPrimaryButton();

    if (widget.hideSecondaryButton) return Center(child: _primaryButton);
    if (widget.hidePrimeButton) return Center(child: _secondaryButton);

    return Row(children: [
      Expanded(child: _secondaryButton),
      _crossAxisSpaceWidget(),
      Expanded(child: _primaryButton),
    ]);
  }

  SizedBox _crossAxisSpaceWidget() =>
      SizedBox(width: _isButtonGroupAvailable ? 10 : 0);

  Widget _buildPrimaryButton() {
    Widget child = Text(widget.primeButtonText ?? '');
    if (widget.primeButtonIcon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.primeButtonIcon!,
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    if (widget.primeButtonGradient != null) {
      child = Ink(
        decoration: BoxDecoration(
          gradient: widget.primeButtonGradient,
          borderRadius: widget.buttonShape is RoundedRectangleBorder
              ? (widget.buttonShape as RoundedRectangleBorder).borderRadius
              : BorderRadius.circular(4), // Default border radius
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: widget.isExpand ? const BoxConstraints(minHeight: 40, minWidth: double.maxFinite) : BoxConstraints(minHeight: _getButtonSize()?.height ?? 40, minWidth: _getButtonSize()?.width ?? 0),
          child: child,
        ),
      );
    }

    if (widget.primeButtonIcon != null && widget.primeButtonGradient == null) {
      return ElevatedButton.icon(
        style: _primaryButtonStyle(),
        onPressed: widget.onSubmit,
        icon: widget.primeButtonIcon!,
        label: Text(widget.primeButtonText ?? ''),
      );
    }

    return ElevatedButton(
      style: _primaryButtonStyle(),
      onPressed: widget.onSubmit,
      child: child,
    );
  }

  Widget _buildSecondaryButton() {
    VoidCallback? _onCancel = widget.onCancel ?? () => Navigator.pop(context);
    Widget child = Text(widget.secondaryButtonText ?? '');

    if (widget.secondaryButtonIcon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.secondaryButtonIcon!,
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    if (widget.secondaryButtonGradient != null) {
      child = Ink(
        decoration: BoxDecoration(
          gradient: widget.secondaryButtonGradient,
          borderRadius: widget.buttonShape is RoundedRectangleBorder
              ? (widget.buttonShape as RoundedRectangleBorder).borderRadius
              : BorderRadius.circular(4), // Default border radius
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: widget.isExpand ? const BoxConstraints(minHeight: 40, minWidth: double.maxFinite) : BoxConstraints(minHeight: _getButtonSize()?.height ?? 40, minWidth: _getButtonSize()?.width ?? 0),
          child: child,
        ),
      );
    }

    if (widget.secondaryButtonIcon != null && widget.secondaryButtonGradient == null) {
      return ElevatedButton.icon(
        style: _secondaryButtonStyle(),
        onPressed: _onCancel,
        icon: widget.secondaryButtonIcon!,
        label: Text(widget.secondaryButtonText ?? ''),
      );
    }

    return ElevatedButton(
      style: _secondaryButtonStyle(),
      onPressed: _onCancel,
      child: child,
    );
  }

  ButtonStyle _secondaryButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: widget.secondaryButtonTextStyle!.color,
      minimumSize: _getButtonSize(),
      elevation: widget.groupElevation,
      backgroundColor: widget.secondaryButtonGradient != null
          ? Colors.transparent
          : widget.secondaryButtonColor,
      surfaceTintColor:
          widget.secondaryButtonGradient != null ? Colors.transparent : null,
      shadowColor:
          widget.secondaryButtonGradient != null ? Colors.transparent : null,
      textStyle: widget.secondaryButtonTextStyle,
      shape: widget.buttonShape,
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: widget.primeButtonTextStyle!.color,
      minimumSize: _getButtonSize(),
      elevation: widget.groupElevation,
      backgroundColor: widget.primeButtonGradient != null
          ? Colors.transparent
          : widget.primeButtonColor,
      surfaceTintColor:
          widget.primeButtonGradient != null ? Colors.transparent : null,
      shadowColor: widget.primeButtonGradient != null ? Colors.transparent : null,
      textStyle: widget.primeButtonTextStyle,
      shape: widget.buttonShape,
    );
  }

  Size? _getButtonSize() {
    if (widget.isExpand) return const Size(double.maxFinite, 40);
    return widget.buttonSize;
  }

  bool get _isButtonGroupAvailable =>
      widget.hidePrimeButton == false && widget.hideSecondaryButton == false;

  _isLoadingAvailable() => widget.loading != null;

  _handleLoading() {
    setState(() {
      _loading = widget.loading!.value;
    });
  }
}
