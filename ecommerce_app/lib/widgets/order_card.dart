import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderCard({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final Timestamp? timestamp = orderData['createdAt'];
    final String formattedDate;

    if (timestamp != null) {
      formattedDate = DateFormat('MM/dd/yyyy - hh:mm a')
          .format(timestamp.toDate());
    } else {
      formattedDate = 'Date not available';
    }

    // Use the VAT-inclusive total price
    final double totalPrice = (orderData['totalPrice'] ?? 0).toDouble();
    final double subtotal = (orderData['subtotal'] ?? 0).toDouble();
    final double vat = (orderData['vat'] ?? 0).toDouble();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ₱${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Chip(
                  label: Text(
                    orderData['status'] ?? 'Unknown',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _getStatusColor(orderData['status']),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Items: ${orderData['itemCount']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Subtotal: ₱${subtotal.toStringAsFixed(2)} + VAT: ₱${vat.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.deepPurple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}