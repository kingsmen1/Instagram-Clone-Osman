import 'package:flutter/material.dart';

import 'package:instagram_clone/views/constants/strings.dart';
import 'package:instagram_clone/views/login/components/divider.dart';
import 'package:instagram_clone/views/login/components/facebookButton.dart';
import 'package:instagram_clone/views/login/components/googleButton.dart';
import 'package:instagram_clone/views/login/components/login_view_singnup_links.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              Text(
                Strings.welcomeToAppName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const DividerWithMargin(),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              const FacebookButton(),
              const SizedBox(
                height: 20,
              ),
              const GoogleButtton(),
              const DividerWithMargin(),
              const LoginViewSignupLink()
            ],
          ),
        ),
      ),
    );
  }
}
