import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class AdminChatListScreen extends StatelessWidget {
  const AdminChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Chats'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('lastMessageAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}\n\n(Check Firestore indexes)',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No active chats'),
                  Text('Users will appear here when they message you'),
                ],
              ),
            );
          }

          final chatDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatDoc = chatDocs[index];
              final chatData = chatDoc.data() as Map<String, dynamic>;

              final String userId = chatDoc.id;
              final String userEmail = chatData['userEmail'] ?? 'User ID: $userId';
              final String lastMessage = chatData['lastMessage'] ?? 'No messages yet';
              final int unreadCount = chatData['unreadByAdminCount'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      userEmail.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    userEmail,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: unreadCount > 0
                      ? Badge(
                    label: Text('$unreadCount'),
                    child: const Icon(Icons.arrow_forward_ios, size: 16),
                  )
                      : const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatRoomId: userId,
                          userName: userEmail,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}