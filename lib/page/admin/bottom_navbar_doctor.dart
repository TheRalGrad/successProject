part of '../pages.dart';

class BottomNavigationBarDoctor extends StatefulWidget {
  const BottomNavigationBarDoctor({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarDoctorState createState() =>
      _BottomNavigationBarDoctorState();
}

class _BottomNavigationBarDoctorState extends State {
  int _selectedIndex = 1;

  final _buildScreens = [
    const ListDoctorTransaction(),
    const MainPageDoctor(),
    const DoctorProfile(),
  ];

  @override
  void initState() {
    Future.microtask(() {
      String adminId = context.read<DoctorProvider>().admin!.uid!;
      context.read<TransactionProvider>().getAllTransaction(true, adminId);
      context.read<QueueProvider>().get7Queue(adminId);
      context.read<PatientProvider>().get7Patient(adminId);
    });
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: _buildScreens[_selectedIndex],
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        currentIndex: _selectedIndex,
        elevation: 4,
        padding: const EdgeInsets.all(12),
        snakeViewColor: Colors.blueAccent[100],
        selectedItemColor: Colors.green[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        snakeShape: SnakeShape.rectangle,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            label: 'review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
