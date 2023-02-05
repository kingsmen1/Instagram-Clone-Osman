import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/postSettings/providers/post_settings_provider.dart';
import 'package:instagram_clone/views/components/dialogs/alertDialog.dart';
import 'package:instagram_clone/views/components/dialogs/logoutDialog.dart';
import 'package:instagram_clone/views/constants/strings.dart';
import 'package:instagram_clone/views/create_new_post/create_new_post_view.dart';
import 'package:instagram_clone/views/tabs/homeView/home_view.dart';
import 'package:instagram_clone/views/tabs/search/search_view.dart';
import 'package:instagram_clone/views/tabs/user_posts/user_posts_view.dart';

//~ConsumerStatefulWidget
class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    //~DefaultTabController : used for creating tabs View.(how to create tabs)
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.appName,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                //pick a video first
                final videoFile = await ImagePickerHelper.pickVideoFromGallery;
                if (videoFile == null) {
                  return;
                }

                //refreshing postSettingProvider
                ref.refresh(postSettingProvider);

                //go to the create new post screen
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateNewPostView(
                        fileToPost: videoFile,
                        fileType: FileType.video,
                      ),
                    ),
                  );
                }
              },
              icon: const FaIcon(FontAwesomeIcons.film),
            ),
            IconButton(
              onPressed: () async {
                //pick and image first
                final image = await ImagePickerHelper.pickImageFromGallery;
                if (image == null) {
                  return;
                }

                //refresh postSetting provider
                ref.refresh(postSettingProvider);

                if (mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CreateNewPostView(
                        fileToPost: image,
                        fileType: FileType.image,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add_photo_alternate_outlined),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogOut = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if (shouldLogOut) {
                  await ref.read(authStateProvider.notifier).logout();
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          //" bottom "This widget appears across the bottom of the app bar.
          //Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget]
          // can be used at the bottom of an app bar.
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.person,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.home,
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [
          UserPostsView(),
          SearchView(),
          HomeView(),
        ]),
      ),
    );
  }
}
