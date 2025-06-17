import 'package:flutter/material.dart';
import 'package:music_app/widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Prevent redundant navigation
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/library');
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/search'),
            splashColor: const Color(0xFF1DB954).withOpacity(0.3),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
            splashColor: const Color(0xFF1DB954).withOpacity(0.3),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF121212),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/images/artist1.jpg',
                            ),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'ZAHID',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Music lover | Always chasing new beats',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '1.2K',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 40),
                            Column(
                              children: [
                                Text(
                                  '800',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: ListTile(
                            leading: const Icon(
                              Icons.edit,
                              color: Color(0xFF1DB954),
                            ),
                            title: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, '/edit_profile'),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: ListTile(
                            leading: const Icon(
                              Icons.upload_file,
                              color: Color(0xFF1DB954),
                            ),
                            title: Text(
                              'Upload Audio',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, '/upload'),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: ListTile(
                            leading: const Icon(
                              Icons.star,
                              color: Color(0xFF1DB954),
                            ),
                            title: Text(
                              'Subscription Status',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, '/subscription'),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: ListTile(
                            leading: const Icon(
                              Icons.settings,
                              color: Color(0xFF1DB954),
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, '/settings'),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Color(0xFF1DB954),
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              // Implement logout functionality
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const NowPlayingTab(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/library');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
        },
      ),
    );
  }
}
