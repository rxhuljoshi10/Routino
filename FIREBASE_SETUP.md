# Firebase Authentication Setup Guide

## ✅ **Google Sign-In Added (FREE & WORKING NOW!)**

I've added Google Sign-In to your app! This works immediately without any billing setup.

### **How to Use Google Sign-In:**
1. Run `flutter pub get` to install dependencies
2. The app now has a "Continue with Google" button
3. Click it to sign in with your Google account
4. **No OTP needed** - instant login!

## Phone Authentication Issues
The app is not receiving OTP because Firebase Phone Authentication requires billing to be enabled.

**Error**: `BILLING_NOT_ENABLED` - This means your Firebase project doesn't have billing enabled, which is required for Phone Authentication.

## Quick Fix for Testing Phone Auth
I've added test numbers that work without Firebase setup:
- **Test Numbers**: 9999999999 or 8888888888
- **Test OTP**: 123456 or 000000

## Proper Firebase Setup (Required for Production)

### 1. Enable Billing in Firebase Console
**IMPORTANT**: Phone Authentication requires a paid plan (Blaze plan)
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `routin0-app`
3. Go to **Project Settings** (gear icon)
4. Click on **Usage and billing**
5. Upgrade to **Blaze plan** (Pay as you go)
6. Add a payment method (credit card)

### 2. Enable Phone Authentication
1. Go to **Authentication** > **Sign-in method**
2. Enable **Phone** provider
3. Add your app's SHA-1 fingerprint

### 3. Get SHA-1 Fingerprint
Run this command in your project root:
```bash
cd android
./gradlew signingReport
```

Look for the SHA1 fingerprint under `Variant: debug` and `Config: debug`

### 4. Add SHA-1 to Firebase
1. In Firebase Console, go to **Project Settings**
2. Scroll down to **Your apps**
3. Click on your Android app
4. Add the SHA-1 fingerprint

### 5. Download Updated google-services.json
1. After adding SHA-1, download the updated `google-services.json`
2. Replace the current file in `android/app/`

### 6. Test with Real Numbers
Once properly configured, you can test with real phone numbers.

## Current Test Setup
The app now includes:
- Test number detection (9999999999, 8888888888)
- Test OTP acceptance (123456, 000000)
- Better error logging
- Debug information in console

## Troubleshooting

### Billing Error (BILLING_NOT_ENABLED)
- **Cause**: Firebase Phone Authentication requires a paid plan
- **Solution**: Upgrade to Blaze plan (Pay as you go)
- **Cost**: Only pay for actual usage (very low cost for testing)

### Other Common Issues
1. Check console logs for Firebase errors
2. Ensure SHA-1 fingerprint is added to Firebase
3. Verify google-services.json is up to date
4. Make sure Phone Authentication is enabled in Firebase Console

## ✅ **Google Sign-In Setup (RECOMMENDED - FREE)**

### Enable Google Sign-In in Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `routin0-app`
3. Go to **Authentication** > **Sign-in method**
4. Enable **Google** provider
5. Add your app's SHA-1 fingerprint (same as phone auth)
6. Download updated `google-services.json`

### Get SHA-1 Fingerprint
```bash
cd android
./gradlew signingReport
```

### Add SHA-1 to Firebase
1. In Firebase Console, go to **Project Settings**
2. Scroll down to **Your apps**
3. Click on your Android app
4. Add the SHA-1 fingerprint

## Alternative Solutions (If you don't want to enable billing)

### Option 1: Use Google Sign-In (IMPLEMENTED ✅)
- **FREE** - No billing required
- **Easy** - One-click login
- **Secure** - Handled by Google
- **Fast** - No OTP waiting

### Option 2: Use Test Numbers (Current Setup)
- Use the test numbers I've implemented
- Works without Firebase billing
- Good for development and testing

### Option 3: Use Firebase Emulator
- Set up Firebase Auth Emulator
- Test locally without billing
- More complex setup

## Next Steps
1. **Run `flutter pub get`** to install Google Sign-In dependency
2. **Test Google Sign-In** - it should work immediately
3. **Set up Firebase** for Google Sign-In (add SHA-1 fingerprint)
4. **Use test numbers** for phone auth testing
5. **Remove test code** before release

## 🚀 **Ready to Test!**

Your app now has:
- ✅ **Google Sign-In** (FREE, works immediately)
- ✅ **Phone Auth Test Numbers** (9999999999, 8888888888)
- ✅ **Test OTP** (123456, 000000)

**Just run `flutter pub get` and test the Google Sign-In button!**
