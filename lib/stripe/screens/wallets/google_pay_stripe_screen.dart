// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// import '../../config.dart';
// import '../../widgets/example_scaffold.dart';

// class GooglePayStripeScreen extends StatefulWidget {
//   const GooglePayStripeScreen({super.key});

//   @override
//   State<GooglePayStripeScreen> createState() => _GooglePayStripeScreenState();
// }

// class _GooglePayStripeScreenState extends State<GooglePayStripeScreen> {
//   Future<void> startGooglePay() async {
//     final googlePaySupported = await Stripe.instance.isPlatformPaySupported();
//     if (googlePaySupported) {
//       try {
//         // 1. fetch Intent Client Secret from backend
//         final response = await fetchPaymentIntentClientSecret();
//         final clientSecret = response['clientSecret'].toString();

//         // 2.present google pay sheet
//         await Stripe.instance.confirmPlatformPayPaymentIntent(
//           clientSecret: 'test',
//           confirmParams: const PlatformPayConfirmParams.googlePay(
//             googlePay: GooglePayParams(
//               amount: 1000,
//               currencyCode: 'USD',
//               merchantCountryCode: 'US',
//             ),
//           ),
//         );

//         await Stripe.instance.presentGooglePay(
//           PresentGooglePayParams(clientSecret: clientSecret),
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Google Pay payment successfully completed')),
//         );
//       } catch (e) {
//         log('Error during google pay',
//             error: e, stackTrace: (e as Error?)?.stackTrace);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Google pay is not supported on this device')),
//       );
//     }
//   }

//   Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
//     final url = Uri.parse('$kApiUrl/create-payment-intent');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'email': 'example@gmail.com',
//         'currency': 'usd',
//         'request_three_d_secure': 'any',
//       }),
//     );
//     return json.decode(response.body) as Map<String, dynamic>;
//   }

//   @override
//   Widget build(BuildContext context) => ExampleScaffold(
//         title: 'Google Pay',
//         tags: const ['Android'],
//         padding: const EdgeInsets.all(16),
//         children: [
//           if (defaultTargetPlatform == TargetPlatform.android)
//             SizedBox(
//               height: 75,
//               child: GooglePayButton(
//                 onTap: startGooglePay,
//               ),
//             )
//           else
//             const Text('Google Pay is not available in this device'),
//         ],
//       );
// }
