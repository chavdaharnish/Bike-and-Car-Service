import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int totalAmount = 0;
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1761NCYXNz6QmS',
      'amount': totalAmount * 100,
      'name': 'Rapid Service',
      'description': 'Test Payment',
      'prefill': {'contract': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS:" + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR:"  + response.message);

        // + response.code.toString() + " - "
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL WALLET" + response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: LimitedBox(
              maxWidth: 150,
              child: TextField(
                maxLength: 5,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(hintText: 'Amount',counterText: ""),
                onChanged: (value) {
                  setState(() {
                    totalAmount = num.parse(value);
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          // ignore: deprecated_member_use
          FlatButton(
            child: Text(
              'Make Payment',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              openCheckout();
            },
          )
        ],
      ),
    );
  }
}
