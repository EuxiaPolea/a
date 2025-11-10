// ... existing imports
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  // ... existing code
}

class _ChatScreenState extends State<ChatScreen> {
  // ... existing code

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userName ?? 'Brew Haven Support',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: kRichBlack,
        elevation: 0,
      ),
      // ... rest of the existing build method
    );
  }
}