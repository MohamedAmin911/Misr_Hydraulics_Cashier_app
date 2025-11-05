import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'firestore_service.dart';

class ConnectivityState {
  final bool hasInternet;
  final bool firestoreReachable;
  bool get online => hasInternet && firestoreReachable;

  const ConnectivityState({
    required this.hasInternet,
    required this.firestoreReachable,
  });

  ConnectivityState copyWith({bool? hasInternet, bool? firestoreReachable}) =>
      ConnectivityState(
        hasInternet: hasInternet ?? this.hasInternet,
        firestoreReachable: firestoreReachable ?? this.firestoreReachable,
      );
}

final connectivityStateProvider = StreamProvider<ConnectivityState>((
  ref,
) async* {
  final db = ref.watch(firestoreProvider);
  final fsService = FirestoreService(db);
  final connectivity = Connectivity();
  final internetChecker = InternetConnection.createInstance();

  // Initial
  bool hasInternet = await internetChecker.hasInternetAccess;
  bool pingOk = await fsService.ping();
  yield ConnectivityState(hasInternet: hasInternet, firestoreReachable: pingOk);

  final connectivityStream = connectivity.onConnectivityChanged;
  final internetStream = internetChecker.onStatusChange;
  final controller = StreamController<ConnectivityState>();

  Future<void> pushState() async {
    final internet = await internetChecker.hasInternetAccess;
    final ping = await fsService.ping();
    controller.add(
      ConnectivityState(hasInternet: internet, firestoreReachable: ping),
    );
  }

  final sub1 = connectivityStream.listen((_) => pushState());
  final sub2 = internetStream.listen((_) => pushState());

  // periodic ping to firestore
  final timer = Timer.periodic(const Duration(seconds: 15), (_) => pushState());

  ref.onDispose(() {
    sub1.cancel();
    sub2.cancel();
    timer.cancel();
    controller.close();
  });

  yield* controller.stream;
});
