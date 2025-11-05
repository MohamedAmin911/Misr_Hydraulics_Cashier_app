import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';

class StatusBanner extends ConsumerWidget {
  const StatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conn = ref.watch(connectivityStateProvider);
    return conn.when(
      data: (s) => s.online
          ? const SizedBox.shrink()
          : Material(
              color: Colors.red.shade600,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'لا يوجد اتصال مستقر بـ Firebase. يرجى التحقق من الإنترنت.',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
