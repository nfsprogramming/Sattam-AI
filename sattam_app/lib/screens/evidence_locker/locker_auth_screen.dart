import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import 'evidence_locker_screen.dart';

class LockerAuthScreen extends StatefulWidget {
  const LockerAuthScreen({super.key});

  @override
  State<LockerAuthScreen> createState() => _LockerAuthScreenState();
}

class _LockerAuthScreenState extends State<LockerAuthScreen> {
  String _enteredPin = '';
  String? _savedPin;
  bool _isSettingPin = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _checkSavedPin();
  }

  Future<void> _checkSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('locker_pin');
    setState(() {
      _savedPin = pin;
      _isSettingPin = pin == null;
    });
  }

  void _onKeyPress(String key) {
    if (_enteredPin.length < 4) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin += key;
        _hasError = false;
      });
      
      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _hasError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    // Delay slightly so the user sees the last dot filled
    await Future.delayed(const Duration(milliseconds: 200));

    if (_isSettingPin) {
      // Save new PIN
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locker_pin', _enteredPin);
      if (mounted) {
        _navigateToLocker();
      }
    } else {
      // Verify existing PIN
      if (_enteredPin == _savedPin) {
        if (mounted) {
          _navigateToLocker();
        }
      } else {
        HapticFeedback.heavyImpact();
        setState(() {
          _enteredPin = '';
          _hasError = true;
        });
      }
    }
  }

  void _navigateToLocker() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EvidenceLockerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_savedPin == null && !_isSettingPin) {
      return Scaffold(
        backgroundColor: context.colors.bgBase,
        body: Center(child: CircularProgressIndicator(color: context.colors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.lock_rounded, size: 64, color: context.colors.primary),
            const SizedBox(height: 24),
            Text(
              _isSettingPin ? 'Set Locker PIN' : 'Enter Locker PIN',
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isSettingPin ? 'Create a 4-digit PIN to secure your evidence' : 'Enter your 4-digit PIN to access the vault',
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 48),
            
            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasError 
                        ? Colors.red 
                        : isFilled ? context.colors.primary : context.colors.surfaceContainerHigh,
                    border: Border.all(
                      color: _hasError 
                          ? Colors.red 
                          : isFilled ? context.colors.primary : context.colors.borderSubtle,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            if (_hasError)
              Text(
                'Incorrect PIN. Try again.',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              const SizedBox(height: 16),
              
            const Spacer(),
            
            // Keypad
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 24),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 24),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 72), // Empty space for alignment
                      _buildKey('0'),
                      _buildActionKey(Icons.backspace_rounded, _onBackspace),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKey(key)).toList(),
    );
  }

  Widget _buildKey(String text) {
    return GestureDetector(
      onTap: () => _onKeyPress(text),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.surfaceContainer,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        color: Colors.transparent,
        child: Center(
          child: Icon(icon, color: context.colors.textPrimary, size: 28),
        ),
      ),
    );
  }
}
