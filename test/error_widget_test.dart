import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather/core/constant/app_constants.dart';
import 'package:weather/widgets/error_widget.dart' as ew;

void main() {
  testWidgets('shows Open Settings button when location permission denied', (tester) async {
    const message = 'Location permission denied';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ew.ErrorDisplayWidget(
            message: message,
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text(AppConstants.openSettings), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}


