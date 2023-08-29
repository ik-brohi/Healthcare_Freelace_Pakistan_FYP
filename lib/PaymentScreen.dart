import 'package:healthcare_pakistan/homepage.dart';

import '/myOrderpage.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  void _processPayment() {
    // Here, you would implement the logic to process the payment using a payment gateway or API
    String cardNumber = cardNumberController.text;
    String expiryDate = expiryDateController.text;
    String cvv = cvvController.text;

    // Implement your payment processing logic here
    // Example: Call a payment API with the card details
    // Once the payment is successful, you can navigate to a success screen
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController accountNumberController = TextEditingController();
    String accountNumberError = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/jazzcash.png'), // Replace with the actual image path
              SizedBox(height: 16.0),
              TextField(
                controller: accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  errorText: accountNumberError.isNotEmpty ? accountNumberError : null,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (accountNumberController.text.isEmpty) {
                    setState(() {
                      accountNumberError = 'Account number is required';
                    });
                    return; // Don't proceed if the account number is empty
                  } else {
                    setState(() {
                      accountNumberError = '';
                    });
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  await Future.delayed(Duration(seconds: 2));

                  Navigator.pop(context); // Close loading dialog

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Payment Done'),
                        content: Text('Payment completed! Kindly wait until the doctor accepts your request.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context); // Close success dialog

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
