import 'package:flutter/material.dart';

import 'package:instagram_clone/views/components/animations/emptyContentAnimation.dart';

class EmptyContentWithText extends StatelessWidget {
  final String text;
  const EmptyContentWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ),
          const EmptyContentAnimation()
        ],
      ),
    );
  }
}
