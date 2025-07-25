import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/grievance_provider.dart';
import 'my_grievances_screen.dart';
import 'submit_grievance_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _screens = [
    _HomeContent(),
    MyGrievancesScreen(),
    SubmitGrievanceScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe0f7fa), Color(0xFFb2dfdb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFF00695c),
          title: const Text('Grievance Management', style: TextStyle(color: Colors.white)),
          actions: [
            if (user != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Hi, ${user.name}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: const Color(0xFF004d40),
            indicatorColor: Colors.white,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
                }
                return const TextStyle(color: Colors.white);
              },
            ),
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: Colors.black);
                }
                return const IconThemeData(color: Colors.white);
              },
            ),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.list_alt), label: 'Grievances'),
              NavigationDestination(icon: Icon(Icons.add_circle), label: 'Submit'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<GrievanceProvider>(context, listen: false).listenToUserGrievances(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final grievanceProvider = Provider.of<GrievanceProvider>(context);
    final grievances = grievanceProvider.grievances;
    final total = grievances.length;
    final pending = grievances.where((g) => g.status == 'Pending').length;
    final solved = grievances.where((g) => g.status == 'Resolved').length;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text('$total'),
                        backgroundColor: Colors.blue.shade100,
                        labelStyle: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                        avatar: const Icon(Icons.list_alt, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Solved', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text('$solved'),
                        backgroundColor: Colors.green.shade100,
                        labelStyle: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold),
                        avatar: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pending', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text('$pending'),
                        backgroundColor: Colors.orange.shade100,
                        labelStyle: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold),
                        avatar: const Icon(Icons.pending, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_people, size: 64, color: Colors.green.shade700),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to the Grievance Management System',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Submit, track, and resolve your academic grievances with ease.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 