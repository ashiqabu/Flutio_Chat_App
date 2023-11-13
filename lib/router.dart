import 'package:flutter/material.dart';
import 'package:sample_project2/features/group/screens/create_group_screen.dart';
import 'package:sample_project2/features/select_contacts/screens/select_contact_screen.dart';
import 'package:sample_project2/features/chat/screens/mobile_chat_screen.dart';
import 'package:sample_project2/model/status_model.dart';

import 'common/widgets/error.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/user_information_screen.dart';
import 'features/status/screens/status_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OtpScreen.routeName:
      final verficationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OtpScreen(
                verificatioId: verficationId,
              ));

    case UserInformatioScreen.routeName:
      //final verficationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => const UserInformatioScreen());

    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'] ?? false;
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
                isGroupChat: isGroupChat,
                profilePic: profilePic,
              ));

    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => StatusScreen(
                status: status,
              ));

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());

    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(
                  error: errormessage,
                ),
              ));
  }
}
