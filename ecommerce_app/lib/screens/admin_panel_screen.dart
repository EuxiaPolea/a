import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_chat_list_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  // ... your existing form controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ADMIN ACTIONS CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Actions',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kRichBlack,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Manage Orders Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_checkout_outlined),
                      label: Text(
                        'Manage All Orders',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        // Your existing orders management
                      },
                    ),

                    const SizedBox(height: 12),

                    // View User Chats Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: Text(
                        'View User Chats',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AdminChatListScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ADD PRODUCT CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Product',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kRichBlack,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Your existing form fields with new styling
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        prefixIcon: Icon(Icons.coffee, color: kBrown),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.attach_money, color: kBrown),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description, color: kBrown),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        // Your existing add product logic
                      },
                      child: Text(
                        'Add Product',
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}