part of '../pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ///// Get data เพื่อ Show ในหน้าที อ. บอก
  final user = FirebaseAuth.instance.currentUser!;

  // document ID
  List<String> docIDs = [];

  // get docID
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('admin').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );
  }
  ////////////////

  late Size size;
  double height = 0;
  double width = 0;

  UserModel? currentUser;

  @override
  void initState() {
    getDocId();
    Future.microtask(() {
      setState(() {
        currentUser = context.read<UserProvider>().user!;
        size = MediaQuery.of(context).size;
        height = size.height;
        width = size.width;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Hello, ${currentUser?.name ?? 'Loading...'}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 24),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      backgroundImage: currentUser?.profileUrl != "" &&
                              currentUser?.profileUrl != null
                          ? NetworkImage(currentUser?.profileUrl ??
                              'https://i.pravatar.cc/50')
                          : null,
                      child: currentUser?.profileUrl != "" &&
                              currentUser?.profileUrl != null
                          ? null
                          : const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                    ),
                  ],
                ),
                Image.asset("assets/homepage.png"),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Work Post",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Consumer<DoctorProvider>(
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (value.listDoctor.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("no work today"),
                      );
                    }
// หน้าแสดงผลที่ อ. ให้แก้
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        ////////////////////////////////////////
                        itemCount: value.listDoctor.length,
                        itemBuilder: (context, index) {
                          final item = value.listDoctor[index];
                          final itemKonsultasi = item.consultationSchedule
                              .where((element) =>
                                  element.daySchedule!.intValue ==
                                  DateTime.now().weekday)
                              .first;

                          return _adminCard(item, itemKonsultasi, context);
                          ////////////////////////////////////////
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Admin Specialist",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 140,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildDoctorSpecialist(
                          specialist: "Accounting  Manager",
                          imgAsset: 'assets/acc.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Accounting Supervisor",
                          imgAsset: 'assets/admin.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Administrative Assistant",
                          imgAsset: 'assets/adminn.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Administrative Manager",
                          imgAsset: 'assets/Manager.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Air Hostess",
                          imgAsset: 'assets/Air Hostess.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Assistant Accounting",
                          imgAsset: 'assets/acount.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Audio Video Engineer",
                          imgAsset: 'assets/dj.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Customer",
                          imgAsset: 'assets/customer.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Dentist",
                          imgAsset: 'assets/Dentist.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Driver",
                          imgAsset: 'assets/driver.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Electrician",
                          imgAsset: 'assets/elect.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Finance",
                          imgAsset: 'assets/finance.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "General practitioners",
                          imgAsset: 'assets/prac.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Guard",
                          imgAsset: 'assets/guard.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "guide",
                          imgAsset: 'assets/driver.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Maintenance & Repair Technician",
                          imgAsset: 'assets/repair.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Mechanic",
                          imgAsset: 'assets/mec.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Surgeon",
                          imgAsset: 'assets/nurse.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Waitress",
                          imgAsset: 'assets/wait.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Student",
                          imgAsset: 'assets/student.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Professor",
                          imgAsset: 'assets/teacher.png',
                        ),
                        _buildDoctorSpecialist(
                          specialist: "Personnel",
                          imgAsset: 'assets/personal.png',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4.0,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ListDiagnosisUser(),
                        ),
                      );
                    },
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(Icons.receipt, color: Colors.white),
                    ),
                    title: const Text("Assessment results"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _adminCard(DataDoctor item, ConsultationSchedule itemKonsultasi,
      BuildContext context) {
    return Container(
      height: 146,
      margin: const EdgeInsets.only(bottom: 10, right: 8),
      child: Card(
        elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 8,
            ),
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey,
              backgroundImage: item.admin.profileUrl != ""
                  ? NetworkImage(item.admin.profileUrl!)
                  : null,
              child: item.admin.profileUrl != ""
                  ? null
                  : const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
            ),
            Container(
              margin: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${item.admin.name}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${item.admin.specialist}",
                    style: const TextStyle(
                        color: AppTheme.darkerPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "\$${NumberFormat("#,###").format(itemKonsultasi.price)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  item.admin.isBusy!
                      ? Container(
                          height: 25,
                          width: 121,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppTheme.warningColor,
                          ),
                          child: const Center(
                            child: Text(
                              "Consulting",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      : item.isBooked
                          ? Container(
                              height: 25,
                              width: 121,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppTheme.dangerColor,
                              ),
                              child: const Center(
                                child: Text(
                                  "received a work",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 121,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppTheme.primaryColor,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ConsultationDetail(
                                        dataDoctor: item,
                                      ),
                                    ),
                                  );
                                },
                                child: const Center(
                                  child: Text(
                                    "BOOK",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDoctorSpecialist(
      {required String specialist, required String imgAsset}) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 115,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ListDoctorSpecialist(specialist: specialist),
            ));
          },
          child: Column(
            children: [
              Image.asset(
                imgAsset,
                height: 73,
                width: 68,
              ),
              Text(
                specialist,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
