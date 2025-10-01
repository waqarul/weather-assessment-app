import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/core/constant/app_constants.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 24),
            Text(AppConstants.errorTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text(AppConstants.retry),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (message.toLowerCase().contains('location permission denied'))
                  OutlinedButton.icon(
                    onPressed: openAppSettings,
                    icon: const Icon(Icons.settings),
                    label: const Text(AppConstants.openSettings),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}