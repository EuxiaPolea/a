import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  final String description;

  const ProductCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  void _addToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(productId, productName, price, imageUrl);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart'),
        backgroundColor: kBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card gets its rounded corners and shadow from theme
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IMAGE SECTION - Takes 60% of card
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: kOffWhite,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: const AlwaysStoppedAnimation<Color>(kBrown),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: kLightBrown.withOpacity(0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.coffee_maker_outlined,
                            size: 40,
                            color: kBrown.withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Brew Haven',
                            style: GoogleFonts.lato(
                              color: kBrown.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // TEXT SECTION - Takes 40% of card
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Description (truncated)
                  Text(
                    description,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Price and Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Price
                      Text(
                        '₱${price.toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kBrown,
                        ),
                      ),

                      // Add to Cart Button
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: kBrown,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () => _addToCart(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}