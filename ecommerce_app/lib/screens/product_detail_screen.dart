import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';

// Convert to StatefulWidget
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> productData;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productData,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.productData['name'] ?? 'No Name';
    final String description = widget.productData['description'] ?? 'No Description';
    final double price = (widget.productData['price'] ?? 0).toDouble();
    final String imageUrl = widget.productData['imageUrl'] ?? '';

    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 100),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 100),
              ),

            const SizedBox(height: 16),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₱${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(description),
                  const SizedBox(height: 30),

                  // Quantity Selector
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Decrement Button
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: _decrementQuantity,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey.shade100,
                                ),
                              ),

                              // Quantity Display
                              Container(
                                width: 60,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '$_quantity',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Increment Button
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: _incrementQuantity,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.blue.shade50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ₱${(price * _quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Add to Cart Button
                  ElevatedButton.icon(
                    onPressed: () {
                      cart.addItem(widget.productId, name, price, _quantity);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $_quantity x $name to cart!'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}