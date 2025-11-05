import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:shared/shared.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      overrides: [
        productRepositoryProvider.overrideWith(
          (ref) => ref.watch(productRepositoryImplProvider),
        ),
        categoryRepositoryProvider.overrideWith(
          (ref) => ref.watch(categoryRepositoryImplProvider),
        ),
        sellerRepositoryProvider.overrideWith(
          (ref) => ref.watch(sellerRepositoryImplProvider),
        ),
        transactionRepositoryProvider.overrideWith(
          (ref) => ref.watch(transactionRepositoryImplProvider),
        ),
      ],
      child: const AdminApp(),
    ),
  );
}
