part of '../pages.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key}) : super(key: key);
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Consumer<DoctorProvider>(
        builder: (BuildContext context, value, Widget? child) {
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
                              : value.admin!.profileUrl != "" &&
                                      imageFile == null
                                  ? NetworkImage(value.admin!.profileUrl!)
                                  : null) as ImageProvider<Object>?,
                          child:
                              imageFile != null || value.admin!.profileUrl != ""
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
                                await _pickImage(value.admin, imgSource);
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
                                "Name : ${value.admin!.name}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Email : ${value.admin!.email}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Phone Number : ${value.admin!.phoneNumber}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Address : ${value.admin!.address}",
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditDoctorProfile(admin: value.admin),
                        ));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blueAccent[100],
                      height: 40,
                      minWidth: 150,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          // ลงชื่อออก FirebaseAuth
                          await FirebaseAuth.instance.signOut();

                          // โหลดผู้ใช้ FirebaseAuth อีกครั้ง เผื่อพลาด
                          await FirebaseAuth.instance.currentUser!.reload();

                          // เช็ค fibase auth ใหม่
                          // เปลี่ยนเส้นทางไป สแปลช
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .getUser(Provider.of<DoctorProvider>(context,
                                  listen: false));
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
                      color: Colors.blueAccent[100],
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
          title: const Text("Upload your picture"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Ink(
                decoration: const ShapeDecoration(
                  color: AppTheme.primaryColor,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera, color: Colors.white),
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

  _pickImage(Doctor? dokter, ImageSource imgSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imgSource);

    imageFile = pickedImage != null ? File(pickedImage.path) : null;

    if (imageFile != null) {
      await _cropImage();
      await _updatePhotoProfile(dokter!);
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

  _updatePhotoProfile(Doctor admin) async {
    try {
      // รับค่าชื่อ
      String fileName = imageFile!.path.split("/").last;

      // รับข้อมูลอ้างอิงที่เก็บข้อมูล firebase (เส้นทางที่เก็บข้อมูล Firebase)
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Photo Profile/${admin.uid}/$fileName');

      // บันทึกภาพไปยังที่เก็บข้อมูล firebase
      final dataImage = await ref.putFile(imageFile!);

      // รับ img url จากที่เก็บข้อมูล firebase
      String imgUrl = await dataImage.ref.getDownloadURL();

      // กำลังอัปเดต URL โปรไฟล์
      await FirebaseFirestore.instance.doc("admin/${admin.uid}").update(
        {
          'profile_url': imgUrl,
        },
      );

      Doctor newData = admin;
      newData.profileUrl = imgUrl;

      // ตั้งค่า แอดมินที่ใช้อย่ด้วย img Url ใหม่ ดังนั้นจึงไม่จำเป็นต้องรับข้อมูลจาก Firestore
      Provider.of<DoctorProvider>(context, listen: false).setDoctor = newData;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}
