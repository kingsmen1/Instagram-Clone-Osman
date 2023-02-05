import 'package:flutter/material.dart';
import 'package:instagram_clone/views/components/richText/base_text.dart';
import 'package:instagram_clone/views/components/richText/rich_text_widget.dart';
import 'package:instagram_clone/views/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

@immutable
class LoginViewSignupLink extends StatelessWidget {
  const LoginViewSignupLink({super.key});

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
      styleForAll: Theme.of(context).textTheme.subtitle1?.copyWith(
            height: 1.5,
          ),
      texts: [
        BaseText.plain(
          text: Strings.dontHaveAnAccount,
        ),
        BaseText.plain(
          text: Strings.signUpOn,
        ),
        BaseText.link(
          text: Strings.facebook,
          onTap: () => launchUrl(
            Uri.parse(
              Strings.facebookSignupUrl,
            ),
          ),
        ),
        BaseText.plain(
          text: Strings.orCreateAnAccountOn,
        ),
        BaseText.link(
          text: Strings.google,
          onTap: () => launchUrl(
            Uri.parse(
              Strings.googleSignupUrl,
            ),
          ),
        )
      ],
    );
  }
}
