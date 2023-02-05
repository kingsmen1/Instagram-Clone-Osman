import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/views/constants/app_colors.dart';
import 'package:instagram_clone/views/constants/strings.dart';

class FacebookButton extends ConsumerWidget {
  const FacebookButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.loginButtonColor,
          foregroundColor: AppColors.loginButtonTextColor,
        ),
        child: SizedBox(
          //Standart height for any button is 44.0
          height: 44.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.facebook,
                color: AppColors.facebookColor,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                Strings.facebook,
              )
            ],
          ),
        ));
  }
}
