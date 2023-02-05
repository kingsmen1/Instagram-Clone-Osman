import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/views/components/constants/string.dart';
import 'package:instagram_clone/views/components/dialogs/alertDialog.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  final String titleOfObjectToDelete;
  const DeleteDialog({
    required this.titleOfObjectToDelete,
  }) : super(
          title: '${Strings.delete} $titleOfObjectToDelete?',
          message:
              '${Strings.areYouSureYouWantToDeleteThis} $titleOfObjectToDelete?',
          buttons: const {
            Strings.cancel: false,
            Strings.delete: true,
          },
        );
}
