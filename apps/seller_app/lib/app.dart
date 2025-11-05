import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared/presentation/widgets/status_banner.dart';
import 'package:shared/shared.dart';

import 'features/auth/seller_guard.dart';
import 'features/products/presentation/products_tab.dart';
import 'features/cart/presentation/cart_tab.dart';
import 'features/transactions/presentation/my_transactions_tab.dart';

class SellerApp extends ConsumerWidget {
  const SellerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ELAboudy - نقطة بيع',
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
      home: const SellerGuard(),
    );
  }
}

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [ProductsTab(), CartTab(), MyTransactionsTab()];
    final titles = ['المنتجات', 'السلة', 'عملياتي'];

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
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'السلة',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'عملياتي',
            ),
          ],
        ),
      ),
    );
  }
}
