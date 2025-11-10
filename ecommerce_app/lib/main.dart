import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth_wrapper.dart';
import 'providers/cart_provider.dart';
import 'services/auth_service.dart';

// NEW APP COLOR PALETTE - Coffee Shop Theme
const Color kRichBlack = Color(0xFF1D1F24);
const Color kBrown = Color(0xFF8B5E3C);
const Color kLightBrown = Color(0xFFD2B48C);
const Color kOffWhite = Color(0xFFF8F4F0);
const Color kCream = Color(0xFFFFF8F0);
const Color kDarkBrown = Color(0xFF5D4037);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Brew Haven', // Updated app name for coffee theme

        // COMPREHENSIVE THEME DATA
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kBrown,
            brightness: Brightness.light,
            primary: kBrown,
            onPrimary: Colors.white,
            secondary: kLightBrown,
            background: kOffWhite,
            surface: Colors.white,
            onSurface: kRichBlack,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: kOffWhite,

          // GOOGLE FONT - Lato
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),

          // GLOBAL BUTTON STYLES
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kBrown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: kBrown,
              textStyle: GoogleFonts.lato(fontWeight: FontWeight.w500),
            ),
          ),

          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: kBrown,
              side: BorderSide(color: kBrown),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.lato(fontWeight: FontWeight.w500),
            ),
          ),

          // GLOBAL TEXT FIELD STYLES
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBrown, width: 2.0),
            ),
            labelStyle: TextStyle(color: kBrown.withOpacity(0.8)),
            hintStyle: TextStyle(color: Colors.grey.shade500),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),

          // GLOBAL CARD STYLES
          cardTheme: CardTheme(
            elevation: 2,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.black12,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
          ),

          // GLOBAL APPBAR STYLE
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: kRichBlack,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.lato(
              color: kRichBlack,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: const IconThemeData(color: kRichBlack),
          ),

          // BOTTOM NAVIGATION BAR THEME
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: kBrown,
            unselectedItemColor: Colors.grey.shade600,
            elevation: 2,
          ),

          // FLOATING ACTION BUTTON THEME
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: kBrown,
            foregroundColor: Colors.white,
          ),
        ),

        home: const AuthWrapper(),
      ),
    );
  }
}