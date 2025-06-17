import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/now_playing_tab.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<Map<String, dynamic>> genres = [
    {'name': 'Pop', 'color': Colors.purple},
    {'name': 'Hip-Hop', 'color': Colors.red},
    {'name': 'Rock', 'color': Colors.blue},
    {'name': 'Jazz', 'color': Colors.orange},
    {'name': 'Electronic', 'color': Colors.teal},
    {'name': 'Classical', 'color': Colors.indigo},
    {'name': 'R&B', 'color': Colors.pink},
    {'name': 'Reggae', 'color': Colors.green},
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
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
        backgroundColor: Colors.black.withOpacity(0.4),
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
            'Search',
            style: TextStyle(
              fontSize: isTablet ? 28 : 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
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
        leading: null,
        actions: [
          AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white, size: 28),
              onPressed: () {},
              splashColor: const Color(0xFF1DB954).withOpacity(0.3),
            ),
          ),
          AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
              splashColor: const Color(0xFF1DB954).withOpacity(0.3),
            ),
          ),
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
                  colors: [Color(0xFF1DB954), Color(0xFF121212)],
                  stops: [0.0, 0.4],
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
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Songs, artists, or playlists',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {});
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.grey[900]!.withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1DB954),
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  Navigator.pushNamed(
                                    context,
                                    '/search_results',
                                    arguments: value,
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle(context, 'Browse All', isTablet),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isTablet ? 3 : 2,
                                    crossAxisSpacing: isTablet ? 16 : 10,
                                    mainAxisSpacing: isTablet ? 16 : 10,
                                    childAspectRatio: isTablet ? 1.2 : 1.4,
                                  ),
                              itemCount: genres.length,
                              itemBuilder: (context, index) => AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/playlist',
                                    arguments: genres[index]['name'],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: genres[index]['color'].withOpacity(
                                        0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        genres[index]['name'],
                                        style: TextStyle(
                                          fontSize: isTablet ? 20 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
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
      // bottomNavigationBar: BottomNavBar(
      //   onTabChange: (index) {
      //     if (index == 0) Navigator.pushReplacementNamed(context, '/home');
      //     if (index == 1) Navigator.pushReplacementNamed(context, '/library');
      //     if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
      //   },
      // ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 28 : 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/see_all'),
            child: Text(
              'See All',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: isTablet ? 18 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
