// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:intl/intl.dart';

// //     <uses-permission android:name="com.android.vending.BILLING" />

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) => const MaterialApp(home: DemoPage());
// }

// class DemoPage extends StatefulWidget {
//   const DemoPage({super.key});

//   @override
//   State<DemoPage> createState() => _DemoPageState();
// }

// class _DemoPageState extends State<DemoPage> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   final String _productID = 'PREMIUM_PLAN';

//   bool _available = true;
//   List<ProductDetails> _products = [];
//   final List<PurchaseDetails> _purchases = [];
//   late StreamSubscription<List<PurchaseDetails>>? _subscription;

//   @override
//   void initState() {
//     final purchaseUpdated = _inAppPurchase.purchaseStream;

//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       setState(() {
//         _purchases.addAll(purchaseDetailsList);
//         _listenToPurchaseUpdated(purchaseDetailsList);
//       });
//     }, onDone: () {
//       _subscription!.cancel();
//     }, onError: (error) {
//       _subscription!.cancel();
//     });

//     _initialize();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _subscription?.cancel();
//   }

//   Future<void> _initialize() async {
//     _available = await _inAppPurchase.isAvailable();

//     final products = await _getProducts(
//       productIds: <String>{_productID},
//     );

//     setState(() {
//       _products = products;
//     });
//   }

//   Future<void> _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     for (final e in purchaseDetailsList) {
//       switch (e.status) {
//         case PurchaseStatus.pending:
//           //  _showPendingUI();
//           break;
//         case PurchaseStatus.purchased:
//         case PurchaseStatus.restored:
//           // bool valid = await _verifyPurchase(purchaseDetails);
//           // if (!valid) {
//           //   _handleInvalidPurchase(purchaseDetails);
//           // }
//           break;
//         case PurchaseStatus.error:
//           print('purchaseDetails.error');
//           // _handleError(purchaseDetails.error!);
//           break;
//         default:
//           break;
//       }

//       if (e.pendingCompletePurchase) {
//         await _inAppPurchase.completePurchase(e);
//       }
//     }
//   }

//   Future<List<ProductDetails>> _getProducts(
//       {required Set<String> productIds}) async {
//     final response = await _inAppPurchase.queryProductDetails(productIds);

//     return response.productDetails;
//   }

//   ListTile _buildProduct({required ProductDetails product}) => ListTile(
//         leading: const Icon(Icons.attach_money),
//         title: Text('${product.title} - ${product.price}'),
//         subtitle: Text(product.description),
//         trailing: ElevatedButton(
//           onPressed: () {
//             _subscribe(product: product);
//           },
//           child: const Text(
//             'Subscribe',
//           ),
//         ),
//       );

//   ListTile _buildPurchase({required PurchaseDetails purchase}) {
//     if (purchase.error != null) {
//       return ListTile(
//         title: Text('${purchase.error}'),
//         subtitle: Text(purchase.status.toString()),
//       );
//     }

//     String? transactionDate;
//     if (purchase.status == PurchaseStatus.purchased) {
//       final date = DateTime.fromMillisecondsSinceEpoch(
//         int.parse(purchase.transactionDate!),
//       );
//       transactionDate = ' @ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(date)}';
//     }

//     return ListTile(
//       title: Text('${purchase.productID} ${transactionDate ?? ''}'),
//       subtitle: Text(purchase.status.toString()),
//     );
//   }

//   void _subscribe({required ProductDetails product}) {
//     final purchaseParam = PurchaseParam(productDetails: product);
//     _inAppPurchase.buyNonConsumable(
//       purchaseParam: purchaseParam,
//     );
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('In App Purchase 1.0.8'),
//         ),
//         body: _available
//             ? Column(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Current Products ${_products.length}'),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _products.length,
//                           itemBuilder: (context, index) => _buildProduct(
//                             product: _products[index],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Past Purchases: ${_purchases.length}'),
//                         Expanded(
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: _purchases.length,
//                             itemBuilder: (context, index) => _buildPurchase(
//                               purchase: _purchases[index],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             : const Center(
//                 child: Text('The Store Is Not Available'),
//               ),
//       );
// }
