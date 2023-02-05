import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/userId_provider.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/image_upload/models/thumnail_request.dart';
import 'package:instagram_clone/state/image_upload/providers/image_upload_provider.dart';
import 'package:instagram_clone/state/postSettings/models/post_settings.dart';
import 'package:instagram_clone/state/postSettings/providers/post_settings_provider.dart';
import 'package:instagram_clone/views/components/file_thumbnail_view.dart';
import 'package:instagram_clone/views/constants/strings.dart';

//~StatefulHookConsumerWidget : we using to get isMounted property as its only availble in stateful widget.
class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;
  const CreateNewPostView({
    super.key,
    required this.fileToPost,
    required this.fileType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest =
        ThumbnailRequest(file: widget.fileToPost, fileType: widget.fileType);
    final postSettings = ref.watch(postSettingProvider);

    final postController =
        useTextEditingController(); //a textEdittingController provided by flutter hooks
    final isPostButtonEnabled = useState(false);
    //^revise
    useEffect(() {
      void listner() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listner);

      return () {
        postController.removeListener(listner);
      };
    }, [postController] //by this we say if postController changes rebuild this.
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.createNewPost,
        ),
        actions: [
          IconButton(
            onPressed: isPostButtonEnabled.value
                ? () async {
                    //getting userId from provider.
                    final userId = ref.read(
                      userIdProvider,
                    );
                    if (userId == null) {
                      return;
                    }
                    //getting message from textEdittingController.
                    final message = postController.text;

                    //uploading post.
                    final bool isUpload =
                        await ref.read(imageUploadProvider.notifier).upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              postSettings: postSettings,
                              userId: userId,
                            );
                    if (isUpload && mounted) {
                      Navigator.pop(context);
                    }
                  }
                : null,
            icon: const Icon(
              Icons.send,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //thumbnail
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: postController,
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
              ),
            ),
            //spreading PostSettings enum values and building listTiles of that length
            ...PostSettings.values.map(
              (postSetting) => ListTile(
                //postSetting can be allowComments , allowLikes
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  //*special widget
                  value: postSettings[postSetting] ?? false,
                  onChanged: (isOn) {
                    ref.read(postSettingProvider.notifier).setSettings(
                          postSetting,
                          isOn,
                        );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
