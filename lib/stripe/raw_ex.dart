  // postRequest(
              //     url: '${hostUrl}stripePayment',
              //     formData: {'amount': _controller.text}).then((value) async {
              //   if (value.status) {
              // try {
              //   final mode = value.data['mode'];
              // if (mode == 'TEST') {
              //   stripe.Stripe.publishableKey =
              //       'pk_test_';
              // } else {
              //   stripe.Stripe.publishableKey =
              //       'pk_live_';
              // }

              // final paymentIntent = value.data['intent'];
              // await stripe.Stripe.instance.initPaymentSheet(
              //   paymentSheetParameters:
              //       stripe.SetupPaymentSheetParameters(
              //           paymentIntentClientSecret:
              //               paymentIntent!['client_secret'].toString(),
              //           // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
              //           googlePay: const stripe.PaymentSheetGooglePay(
              //             testEnv: true,
              //             currencyCode: 'IN',
              //             merchantCountryCode: '+91',
              //           ),
              //           style: ThemeMode.system,
              //           merchantDisplayName: 'King Technologies'),
              // );

              // displayPaymentSheet();
              // } on Exception catch (e, s) {
              // postRequest(url: '${hostUrl}stripeDeposit', formData: {
              //   'amount': _controller.text,
              //   'coupon_id': _currentCouponID,
              //   'status': 'FAILED'
              // });

              // _pp = Provider.of<PrimaryProvider>(context, listen: false);
              // _pp.updateWallet();

              // debugPrint('exception:$e$s');
              // setState(() => _isLoading = false);
              // }
              // } else {
              //   setState(() => _isLoading = false);
              //   showToast(value.message);
              // }
              // });
