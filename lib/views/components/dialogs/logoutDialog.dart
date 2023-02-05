import 'package:instagram_clone/views/components/constants/string.dart';
import 'package:instagram_clone/views/components/dialogs/alertDialog.dart';

class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
          buttons: const {
            Strings.cancel: false,
            Strings.logOut: true,
          },
          message: Strings.areYouSureThatYouWantToLogOutOfTheApp,
          title: Strings.logOut,
        );
}
