import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/chat_screen.dart';
import 'package:ecommerce_app/screens/profile_screen.dart';
import 'package:ecommerce_app/screens/admin_panel_screen.dart';
import 'package:ecommerce_app/screens/orders_screen.dart';
import 'package:ecommerce_app/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userRole = 'user';
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    if (_currentUser != null) {
      final userDoc = await _firestore.collection('users').doc(_currentUser!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userRole = userDoc.data()?['role'] ?? 'user';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // LOGO IN APPBAR
        title: Container(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // You can replace this with your actual logo asset
              // Image.asset('assets/images/app_logo.png', height: 32),
              Icon(Icons.local_cafe, color: kBrown, size: 28),
              const SizedBox(width: 8),
              Text(
                'Brew Haven',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kRichBlack,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Cart Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // Navigate to cart screen
                },
              ),
              if (cartProvider.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartProvider.items.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          // Orders Icon
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
          ),

          // Admin Panel (if admin)
          if (_userRole == 'admin')
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                );
              },
            ),

          // Profile Icon
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kBrown),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading products',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No products available',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new items',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index].data() as Map<String, dynamic>;
                return ProductCard(
                  productId: products[index].id,
                  productName: product['name'] ?? 'Unnamed Product',
                  price: (product['price'] ?? 0).toDouble(),
                  imageUrl: product['imageUrl'] ?? '',
                  description: product['description'] ?? '',
                );
              },
            ),
          );
        },
      ),

      // CONTACT ADMIN FLOATING ACTION BUTTON
      floatingActionButton: _userRole == 'user'
          ? StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('chats').doc(_currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          int unreadCount = 0;

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data();
            if (data != null) {
              unreadCount = (data as Map<String, dynamic>)['unreadByUserCount'] ?? 0;
            }
          }

          return Badge(
            label: Text('$unreadCount'),
            isLabelVisible: unreadCount > 0,
            child: FloatingActionButton.extended(
              icon: const Icon(Icons.support_agent),
              label: Text(
                'Support',
                style: GoogleFonts.lato(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatRoomId: _currentUser!.uid,
                    ),
                  ),
                );
              },
            ),
          );
        },
      )
          : null,
    );
  }
}