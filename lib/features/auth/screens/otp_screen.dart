import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';

import '../../../colors.dart';

class OtpScreen extends ConsumerWidget {
  final String verificatioId;
  static const String routeName = '/otp-screen';
  const OtpScreen({super.key, required this.verificatioId});

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(context, verificatioId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Text('We have sent an SMS with a code'),
          SizedBox(
            width: size.width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (val.length == 6) {
                  verifyOTP(ref, context, val.trim());
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}
