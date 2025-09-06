import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _verificationId;
  Timer? _resendTimer;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state stream - listen to login/logout changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;
  
  // Send OTP to phone number
  Future<bool> sendOTP(String phoneNumber) async {
    try {
      // Validate phone number
      if (phoneNumber.isEmpty || phoneNumber.length != 10) {
        throw 'Please enter a valid 10-digit phone number';
      }
      
      // Format phone number for India (+91)
      String formattedPhone = '+91$phoneNumber';
      
      // Use Completer to handle async callback properly
      final completer = Completer<bool>();
      
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            if (!completer.isCompleted) {
              completer.complete(true);
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.completeError('Auto-verification failed: ${e.toString()}');
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Firebase Auth Error: ${e.code} - ${e.message}');
          if (!completer.isCompleted) {
            completer.completeError(_getErrorMessage(e));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print('OTP sent successfully to $formattedPhone');
          _verificationId = verificationId;
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        timeout: Duration(seconds: 60),
      );
      
      return await completer.future;
    } catch (e) {
      throw _getErrorMessage(e);
    }
  }
  
  // Verify OTP and sign in
  Future<bool> verifyOTP(String otp) async {
    try {
      // Validate OTP
      if (otp.isEmpty || otp.length != 6) {
        throw 'Please enter a valid 6-digit OTP';
      }
      
      if (_verificationId == null) {
        throw 'No verification ID found. Please request OTP again.';
      }
      
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      
      UserCredential result = await _auth.signInWithCredential(credential);
      
      if (result.user != null) {
        return true;
      }
      
      return false;
    } catch (e) {
      throw _getErrorMessage(e);
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _verificationId = null;
      _resendTimer?.cancel();
      _resendTimer = null;
    } catch (e) {
      throw _getErrorMessage(e);
    }
  }
  
  // Resend OTP
  Future<bool> resendOTP(String phoneNumber) async {
    return await sendOTP(phoneNumber);
  }
  
  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return false;
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      return userCredential.user != null;
    } catch (e) {
      throw _getErrorMessage(e);
    }
  }
  
  // Google Sign-Out
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      throw _getErrorMessage(e);
    }
  }
  
  // Get user-friendly error messages
  String _getErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-phone-number':
          return 'The phone number provided is invalid.';
        case 'invalid-verification-code':
          return 'Invalid OTP. Please check and try again.';
        case 'invalid-verification-id':
          return 'Invalid verification ID. Please request OTP again.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'quota-exceeded':
          return 'SMS quota exceeded. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'operation-not-allowed':
          return 'Phone authentication is not enabled.';
        default:
          return 'Authentication failed: ${e.message ?? 'Unknown error'}';
      }
    }
    return e.toString();
  }
  
  // Test method for Firebase test numbers
  Future<bool> testOTP(String phoneNumber) async {
    // Firebase test numbers for development
    final testNumbers = [
      '+91 9999999999', // Test number 1
      '+91 8888888888', // Test number 2
    ];
    
    String formattedPhone = '+91$phoneNumber';
    
    if (testNumbers.contains(formattedPhone)) {
      // For test numbers, simulate OTP sending
      _verificationId = 'test_verification_id_${DateTime.now().millisecondsSinceEpoch}';
      return true;
    }
    
    return await sendOTP(phoneNumber);
  }
  
  // Verify test OTP
  Future<bool> verifyTestOTP(String otp) async {
    // For test numbers, accept any 6-digit OTP
    if (otp == '123456' || otp == '000000') {
      // Simulate successful login
      return true;
    }
    return await verifyOTP(otp);
  }
  
  // Dispose resources
  void dispose() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }
}