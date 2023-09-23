import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double? userRating;

  PaymentPage({this.userRating});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double? selectedDenomination;
  TextEditingController feedbackController = TextEditingController();

  final List<double> denominations = [10.0, 20.0, 50.0, 100.0];

  @override
  void initState() {
    super.initState();
    selectedDenomination = denominations.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate the Lawyer: ${widget.userRating ?? 0.0}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Select an Incentive Amount:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: denominations.map((denomination) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDenomination = denomination;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: denomination == selectedDenomination
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$$denomination',
                      style: TextStyle(
                        fontSize: 16,
                        color: denomination == selectedDenomination
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Feedback (Optional):',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Provide your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement payment logic here, using selectedDenomination
                // You can also use feedbackController.text for feedback submission

                // For demonstration purposes, show a success message
                _showPaymentSuccessDialog();
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Thank you for your payment!'),
              if (feedbackController.text.isNotEmpty)
                Text('Feedback: ${feedbackController.text}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }
}
