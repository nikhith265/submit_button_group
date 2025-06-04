import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:submit_button_group/submit_button_group.dart';

void main() {
  group('SubmitButtonsGroup Tests', () {
    // Helper to pump the widget
    Future<void> pumpSubmitButtonsGroup(
      WidgetTester tester, {
      required VoidCallback onSubmit,
      VoidCallback? onCancel,
      ValueNotifier<bool>? loading,
      String? primeButtonText,
      String? secondaryButtonText,
      Widget? primeButtonIcon,
      Widget? secondaryButtonIcon,
      OutlinedBorder? buttonShape,
      Gradient? primeButtonGradient,
      Gradient? secondaryButtonGradient,
      Color? primeButtonColor,
      Color? secondaryButtonColor,
      bool hidePrime = false,
      bool hideSecondary = false,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubmitButtonsGroup(
              onSubmit: onSubmit,
              onCancel: onCancel ?? () {},
              loading: loading ?? ValueNotifier(false),
              primeButtonText: primeButtonText ?? 'Submit',
              secondaryButtonText: secondaryButtonText ?? 'Cancel',
              primeButtonIcon: primeButtonIcon,
              secondaryButtonIcon: secondaryButtonIcon,
              buttonShape: buttonShape,
              primeButtonGradient: primeButtonGradient,
              secondaryButtonGradient: secondaryButtonGradient,
              primeButtonColor: primeButtonColor,
              secondaryButtonColor: secondaryButtonColor,
              hidePrimeButton: hidePrime,
              hideSecondaryButton: hideSecondary,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(); // Process all frames
    }

    testWidgets('Renders basic buttons without optional features', (WidgetTester tester) async {
      await pumpSubmitButtonsGroup(tester, onSubmit: () {});

      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
      expect(find.byType(Icon), findsNothing);
      expect(find.byType(Ink), findsNothing); // No Ink widget for gradient

      final primaryButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Submit'));
      final secondaryButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Cancel'));

      expect(primaryButton.style?.backgroundColor?.resolve({}), isNot(Colors.transparent));
      expect(secondaryButton.style?.backgroundColor?.resolve({}), isNot(Colors.transparent));
    });

    testWidgets('Renders primeButtonIcon and secondaryButtonIcon', (WidgetTester tester) async {
      await pumpSubmitButtonsGroup(
        tester,
        onSubmit: () {},
        primeButtonIcon: const Icon(Icons.add_circle),
        secondaryButtonIcon: const Icon(Icons.remove_circle),
      );

      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle), findsOneWidget);

      // Check if icons are part of the buttons
      expect(find.descendant(of: find.widgetWithText(ElevatedButton, 'Submit'), matching: find.byIcon(Icons.add_circle)), findsOneWidget);
      expect(find.descendant(of: find.widgetWithText(ElevatedButton, 'Cancel'), matching: find.byIcon(Icons.remove_circle)), findsOneWidget);
    });

    testWidgets('Applies custom buttonShape', (WidgetTester tester) async {
      final testShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0));
      await pumpSubmitButtonsGroup(
        tester,
        onSubmit: () {},
        buttonShape: testShape,
      );

      final primaryButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Submit'));
      final secondaryButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Cancel'));

      // For ElevatedButton, the shape is often under MaterialStateProperty
      final primaryShape = primaryButton.style?.shape?.resolve({});
      final secondaryShape = secondaryButton.style?.shape?.resolve({});

      expect(primaryShape, isA<RoundedRectangleBorder>());
      expect((primaryShape as RoundedRectangleBorder).borderRadius, BorderRadius.circular(12.0));
      expect(secondaryShape, isA<RoundedRectangleBorder>());
      expect((secondaryShape as RoundedRectangleBorder).borderRadius, BorderRadius.circular(12.0));
    });

    testWidgets('Applies primeButtonGradient and makes background transparent', (WidgetTester tester) async {
      const testGradient = LinearGradient(colors: [Colors.cyan, Colors.deepPurple]);
      await pumpSubmitButtonsGroup(
        tester,
        onSubmit: () {},
        primeButtonGradient: testGradient,
        primeButtonText: 'GradientSubmit',
      );

      final primaryButtonFinder = find.widgetWithText(ElevatedButton, 'GradientSubmit');
      expect(primaryButtonFinder, findsOneWidget);

      final primaryButton = tester.widget<ElevatedButton>(primaryButtonFinder);
      expect(primaryButton.style?.backgroundColor?.resolve({}), Colors.transparent, reason: "Background should be transparent for gradient");
      expect(primaryButton.style?.surfaceTintColor?.resolve({}), Colors.transparent, reason: "Surface tint should be transparent for gradient");
      // shadowColor might also be transparent, but let's focus on background and Ink

      final inkWidgetFinder = find.descendant(of: primaryButtonFinder, matching: find.byType(Ink));
      expect(inkWidgetFinder, findsOneWidget, reason: "Ink widget should be present for gradient");
      final inkWidget = tester.widget<Ink>(inkWidgetFinder);
      expect((inkWidget.decoration as BoxDecoration).gradient, testGradient);
    });

    testWidgets('Applies secondaryButtonGradient and makes background transparent', (WidgetTester tester) async {
      const testGradient = LinearGradient(colors: [Colors.orange, Colors.pink]);
      await pumpSubmitButtonsGroup(
        tester,
        onSubmit: () {},
        secondaryButtonGradient: testGradient,
        secondaryButtonText: 'GradientCancel',
      );

      final secondaryButtonFinder = find.widgetWithText(ElevatedButton, 'GradientCancel');
      expect(secondaryButtonFinder, findsOneWidget);

      final secondaryButton = tester.widget<ElevatedButton>(secondaryButtonFinder);
      expect(secondaryButton.style?.backgroundColor?.resolve({}), Colors.transparent);
      expect(secondaryButton.style?.surfaceTintColor?.resolve({}), Colors.transparent);

      final inkWidgetFinder = find.descendant(of: secondaryButtonFinder, matching: find.byType(Ink));
      expect(inkWidgetFinder, findsOneWidget);
      final inkWidget = tester.widget<Ink>(inkWidgetFinder);
      expect((inkWidget.decoration as BoxDecoration).gradient, testGradient);
    });

    testWidgets('Icon and Gradient work together on primary button', (WidgetTester tester) async {
      const testGradient = LinearGradient(colors: [Colors.yellow, Colors.amber]);
      await pumpSubmitButtonsGroup(
        tester,
        onSubmit: () {},
        primeButtonText: 'IconGradientSubmit',
        primeButtonIcon: const Icon(Icons.star),
        primeButtonGradient: testGradient,
      );

      final primaryButtonFinder = find.widgetWithText(ElevatedButton, 'IconGradientSubmit');
      expect(primaryButtonFinder, findsOneWidget);

      // Verify icon is within the button structure (could be inside Ink now)
      expect(find.descendant(of: primaryButtonFinder, matching: find.byIcon(Icons.star)), findsOneWidget);

      // Verify gradient (Ink widget)
      final inkWidgetFinder = find.descendant(of: primaryButtonFinder, matching: find.byType(Ink));
      expect(inkWidgetFinder, findsOneWidget);
      final inkWidget = tester.widget<Ink>(inkWidgetFinder);
      expect((inkWidget.decoration as BoxDecoration).gradient, testGradient);

      // Verify button style for transparency
      final primaryButton = tester.widget<ElevatedButton>(primaryButtonFinder);
      expect(primaryButton.style?.backgroundColor?.resolve({}), Colors.transparent);
    });

     testWidgets('Hides primary button correctly', (WidgetTester tester) async {
      await pumpSubmitButtonsGroup(
        tester,
        onSubmit: () {},
        primeButtonText: 'HiddenSubmit',
        secondaryButtonText: 'VisibleCancel',
        hidePrime: true,
      );

      expect(find.text('HiddenSubmit'), findsNothing);
      expect(find.text('VisibleCancel'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget); // Only secondary
    });

    testWidgets('Hides secondary button correctly', (WidgetTester tester) async {
      await pumpSubmitButtonsGroup(
        tester,
        onSubmit: () {},
        primeButtonText: 'VisibleSubmit',
        secondaryButtonText: 'HiddenCancel',
        hideSecondary: true,
      );

      expect(find.text('VisibleSubmit'), findsOneWidget);
      expect(find.text('HiddenCancel'), findsNothing);
      expect(find.byType(ElevatedButton), findsOneWidget); // Only primary
    });

  });
}
