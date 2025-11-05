import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared/presentation/widgets/status_banner.dart';
import 'package:shared/shared.dart';

import 'features/auth/admin_guard.dart';
import 'features/products/presentation/products_tab.dart';
import 'features/sellers/presentation/sellers_tab.dart';
import 'features/transactions/presentation/transactions_tab.dart';
import 'features/analytics/presentation/analytics_tab.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ELAboudy - الإدارة',
      theme: buildAppTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 600, name: MOBILE),
          Breakpoint(start: 600, end: 1050, name: TABLET),
          Breakpoint(start: 1050, end: 1600, name: DESKTOP),
          Breakpoint(start: 1600, end: double.infinity, name: '4K'),
        ],
      ),
      home: const AdminGuard(),
    );
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      ProductsTab(),
      SellersTab(),
      TransactionsTab(),
      AnalyticsTab(),
    ];
    final titles = ['المنتجات', 'البائعون', 'العمليات', 'التحليلات'];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('ELAboudy — ${titles[index]}')),
        body: Column(
          children: [
            const StatusBanner(),
            Expanded(child: pages[index]),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'المنتجات',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_alt_outlined),
              label: 'البائعون',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'العمليات',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              label: 'التحليلات',
            ),
          ],
        ),
      ),
    );
  }
}
