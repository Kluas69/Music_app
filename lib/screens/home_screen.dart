import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/audio_player_manager.dart';
import '../widgets/song_tile.dart';
import '../widgets/now_playing_tab.dart';
import '../models/song.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> playlists = [
    {
      'name': 'Top Hits',
      'color': Colors.purple,
      'image': 'assets/images/3.jpg',
    },
    {
      'name': 'Chill Vibes',
      'color': Colors.teal,
      'image': 'assets/images/4.jpg',
    },
    {
      'name': 'Workout Mix',
      'color': Colors.red,
      'image': 'assets/images/1.jpg',
    },
    {
      'name': 'Party Anthems',
      'color': Colors.orange,
      'image': 'assets/images/album1.jpg',
    },
    {
      'name': 'Indie Gems',
      'color': Colors.blue,
      'image': 'assets/images/2.jpg',
    },
    {'name': 'R&B Soul', 'color': Colors.pink, 'image': 'assets/images/4.jpg'},
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
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
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.001),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 600),
          child: Text(
            _getGreeting(),
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: const [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black54,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/search'),
            splashColor: const Color(0xFF1DB954).withOpacity(0.3),
          ),
          // IconButton(
          //   icon: const Icon(Icons.upload, color: Colors.white, size: 28),
          //   onPressed: () => Navigator.pushNamed(context, '/upload'),
          //   splashColor: const Color(0xFF1DB954).withOpacity(0.3),
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1DB954), Color(0xFF080808)],
                  stops: [0.0, 0.5],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/1.jpg',
                      fit: BoxFit.cover,
                      color: Colors.black54,
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.black87),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 800),
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/playlist',
                                  arguments: 'Daily Mix',
                                ),
                                child: Container(
                                  height: isTablet ? 220 : 180,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.green[700]!,
                                        Colors.green[900]!,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.asset(
                                            'assets/images/2.jpg',
                                            fit: BoxFit.cover,
                                            colorBlendMode: BlendMode.darken,
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                                      color: Colors.grey[900],
                                                    ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Daily Mix',
                                              style: TextStyle(
                                                fontSize: isTablet ? 26 : 22,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Curated just for you',
                                              style: TextStyle(
                                                fontSize: isTablet ? 16 : 14,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your Playlists',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.black54,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isTablet ? 3 : 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.4,
                                  ),
                              itemCount: playlists.length,
                              itemBuilder: (context, index) => AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/playlist',
                                    arguments: playlists[index]['name'],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Image.asset(
                                              playlists[index]['image'],
                                              fit: BoxFit.cover,
                                              colorBlendMode: BlendMode.darken,
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color:
                                                        playlists[index]['color']
                                                            .withOpacity(0.8),
                                                  ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              playlists[index]['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.black87,
                                                    offset: Offset(1.0, 1.0),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            Text(
                              'New Releases',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.black54,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Song.mockSongs.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No songs available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: Song.mockSongs.length,
                                    itemBuilder: (context, index) =>
                                        AnimatedOpacity(
                                          opacity: 1.0,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          child: SongTile(
                                            song: Song.mockSongs[index],
                                            onTap: () {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((
                                                    _,
                                                  ) async {
                                                    final audioPlayerManager =
                                                        Provider.of<
                                                          AudioPlayerManager
                                                        >(
                                                          context,
                                                          listen: false,
                                                        );
                                                    await audioPlayerManager
                                                        .playSong(
                                                          Song.mockSongs[index],
                                                        );
                                                    if (ModalRoute.of(
                                                          context,
                                                        )?.settings.name !=
                                                        '/now_playing') {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/now_playing',
                                                        arguments: Song
                                                            .mockSongs[index],
                                                      );
                                                    }
                                                  });
                                            },
                                          ),
                                        ),
                                  ),
                            SizedBox(height: size.height * 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const NowPlayingTab(),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: const Color(0xFF1DB954).withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.grey[600],
          activeColor: Colors.white,
          tabBackgroundColor: Colors.transparent,
          tabBackgroundGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1DB954), Color(0xFF0D9044)],
          ),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 300),
          tabBorderRadius: 20,
          haptic: true,
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
              iconSize: 24,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GButton(
              icon: Icons.library_music,
              text: 'Library',
              iconSize: 24,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
              iconSize: 24,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
