part of '../pages.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({Key? key}) : super(key: key);
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56.0),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 64,
                          backgroundImage: (imageFile != null
                              ? FileImage(imageFile!)
                              : value.user!.profileUrl != "" &&
                                      imageFile == null
                                  ? NetworkImage(value.user!.profileUrl!)
                                  : null) as ImageProvider<Object>?,
                          child:
                              imageFile != null || value.user!.profileUrl != ""
                                  ? null
                                  : const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 86,
                                      ),
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 120,
                        child: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          child: Center(
                              child: IconButton(
                            onPressed: () async {
                              final imgSource = await imgSourceDialog();

                              if (imgSource != null) {
                                await _pickImage(value.user!, imgSource);
                              }
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    child: Card(
                      elevation: 4,
                      child: Row(
                        children: [
                          const SizedBox(width: 56),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name : ${value.user!.name}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Email : ${value.user!.email}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Phone Number : ${value.user!.phoneNumber}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Department : ${value.user!.address}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 42),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          // Signout from FirebaseAuth
                          await FirebaseAuth.instance.signOut();

                          // Reloading the FirebaseAuth user, because sometime it stuck
                          await FirebaseAuth.instance.currentUser!.reload();

                          // Also call getUser again, for checking the FirebaseAuth with userChanges, which triggered when signOut()
                          // So it will be redirected to splash page again
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .getUser(null);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong"),
                            ),
                          );
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: AppTheme.dangerColor,
                      height: 40,
                      minWidth: 150,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  imgSourceDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Take Picture From"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Ink(
                decoration: const ShapeDecoration(
                  color: AppTheme.primaryColor,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.photo_camera, color: Colors.white),
                  onPressed: () =>
                      Navigator.of(context).pop(ImageSource.camera),
                ),
              ),
              Ink(
                decoration: const ShapeDecoration(
                  color: AppTheme.primaryColor,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.photo, color: Colors.white),
                  onPressed: () =>
                      Navigator.of(context).pop(ImageSource.gallery),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            )
          ],
        );
      },
    );
  }

  _pickImage(UserModel user, ImageSource imgSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imgSource);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      await _cropImage();

      // Updating photo profile
      await _updatePhotoProfile(user);

      // Refreshing user data
      await Provider.of<UserProvider>(context, listen: false).getUser(null);
    }
    return;
  }

  _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
      });
    }
  }

  _updatePhotoProfile(UserModel user) async {
    try {
      // Get file name
      String fileName = imageFile!.path.split("/").last;

      // Get firebase storage reference (Firebase Storage path)
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Photo Profile/${user.uid}/$fileName');

      // Save the image to firebase storage
      final dataImage = await ref.putFile(imageFile!);

      // Get the img url from firebase storage
      String photoPath = await dataImage.ref.getDownloadURL();

      // Updating profile url
      await FirebaseFirestore.instance.doc("users/${user.uid}").update(
        {
          'profile_url': photoPath,
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
