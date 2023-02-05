import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';

//~MapView : using this for json Serialization.
@immutable
class UserInfoModel extends MapView<String, String?> {
  final UserId userId;
  final String displayName;
  final String? email;
  //*this will create to json.
  UserInfoModel({
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super(
          {
            FirebaseFieldName.userId: userId,
            FirebaseFieldName.displayName: displayName,
            FirebaseFieldName.email: email
          },
        );

  //*this will create instance of this class from json.
  UserInfoModel.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
            userId: userId,
            displayName: json[FirebaseFieldName.displayName] ?? '',
            email: json[FirebaseFieldName.email]);

  //~Hashcode / equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          other.runtimeType == runtimeType &&
          other.userId == userId &&
          other.displayName == displayName &&
          other.email == email;

  @override
  int get hashCode => Object.hashAll(
        [
          userId,
          displayName,
          email,
        ],
      );
}
