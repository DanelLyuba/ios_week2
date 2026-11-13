import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Offline / timeout / server-error state with a working retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: NovaColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: NovaColors.line),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 32,
                color: NovaColors.steel,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connection lost',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: NovaColors.muted,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
