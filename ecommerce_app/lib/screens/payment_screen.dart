import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/order_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { card, gcash, bank }

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.card;
  bool _isLoading = false;

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      await cartProvider.placeOrder();
      await cartProvider.clearCart();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.gcash:
        return 'GCash';
      case PaymentMethod.bank:
        return 'Bank Transfer';
    }
  }

  IconData _getPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.gcash:
        return Icons.phone_android;
      case PaymentMethod.bank:
        return Icons.account_balance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedTotal = '₱${widget.totalAmount.toStringAsFixed(2)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Summary Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formattedTotal,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total amount to pay',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Payment Method Selection
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method Options
            Card(
              child: Column(
                children: [
                  // Credit/Debit Card
                  RadioListTile<PaymentMethod>(
                    title: const Text('Credit/Debit Card'),
                    subtitle: const Text('Pay with your card'),
                    secondary: const Icon(Icons.credit_card, color: Colors.blue),
                    value: PaymentMethod.card,
                    groupValue: _selectedMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),
                  const Divider(height: 1),

                  // GCash
                  RadioListTile<PaymentMethod>(
                    title: const Text('GCash'),
                    subtitle: const Text('Pay via GCash mobile app'),
                    secondary: const Icon(Icons.phone_android, color: Colors.green),
                    value: PaymentMethod.gcash,
                    groupValue: _selectedMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),
                  const Divider(height: 1),

                  // Bank Transfer
                  RadioListTile<PaymentMethod>(
                    title: const Text('Bank Transfer'),
                    subtitle: const Text('Transfer from your bank account'),
                    secondary: const Icon(Icons.account_balance, color: Colors.orange),
                    value: PaymentMethod.bank,
                    groupValue: _selectedMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Selected Payment Method Info
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(_getPaymentMethodIcon(_selectedMethod), color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected: ${_getPaymentMethodName(_selectedMethod)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You will be redirected to complete the payment',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Pay Now Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
              onPressed: _isLoading ? null : _processPayment,
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Pay Now ($formattedTotal)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Security Note
            Text(
              'Your payment is secure and encrypted',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}