import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PostDateTimeView extends ConsumerWidget {
  final DateTime dateTime;
  const PostDateTimeView({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //~date formating using intl package.
    final formatter =
        DateFormat('d MMMM, yyyy, hh:mm a'); //date , month , year , time.
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        formatter.format(dateTime),
      ),
    );
  }
}
