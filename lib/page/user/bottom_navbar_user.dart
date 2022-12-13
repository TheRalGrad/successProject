part of '../pages.dart';

class BottomNavigationBarUserScreen extends StatefulWidget {
  const BottomNavigationBarUserScreen({Key? key}) : super(key: key);
  @override
  _BottomNavigationBarUserScreenState createState() =>
      _BottomNavigationBarUserScreenState();
}

class _BottomNavigationBarUserScreenState extends State {
  int _selectedIndex = 1;

  final _buildScreens = [
    const ListTransactionUser(),
    const MainPage(),
    const ProfileUser(),
  ];

  @override
  void initState() {
    Future.microtask(() {
      String userId = context.read<UserProvider>().user!.uid!;
      context.read<TransactionProvider>().getAllTransaction(false, userId);
      context.read<DoctorProvider>().getAllDoctor(userId);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        snakeShape: SnakeShape.rectangle,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
