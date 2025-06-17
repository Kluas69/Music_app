import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/screens/album_screen.dart';
import 'package:music_app/screens/artist_screen.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:music_app/screens/library_screen.dart';
import 'package:music_app/screens/login_screen.dart';
import 'package:music_app/screens/now_playing_screen.dart';
import 'package:music_app/screens/playlist_screen.dart';
import 'package:music_app/screens/profile_screen.dart';
import 'package:music_app/screens/search_screen.dart';
import 'package:music_app/screens/signup_screen.dart';
import 'package:music_app/screens/upload_audio_screen.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/widgets/audio_player_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AudioPlayerManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1DB954),
        scaffoldBackgroundColor: const Color(0xFF121212),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1DB954),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/album': (context) => const AlbumScreen(),
        '/artist': (context) => const ArtistScreen(),
        '/library': (context) => const LibraryScreen(),
        '/playlist': (context) => const PlaylistScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/upload': (context) => const UploadAudioScreen(),
        '/edit_profile': (context) =>
            const _PlaceholderScreen(title: 'Edit Profile'),
        '/subscription': (context) =>
            const _PlaceholderScreen(title: 'Subscription'),
        '/settings': (context) => const _PlaceholderScreen(title: 'Settings'),
        '/podcast': (context) => const _PlaceholderScreen(title: 'Podcast'),
        '/notifications': (context) =>
            const _PlaceholderScreen(title: 'Notifications'),
        '/create_playlist': (context) =>
            const _PlaceholderScreen(title: 'Create Playlist'),
        '/see_all': (context) => const _PlaceholderScreen(title: 'See All'),
      },
      onGenerateRoute: (settings) {
        try {
          switch (settings.name) {
            case '/now_playing':
              final song = settings.arguments as Song?;
              if (song != null) {
                return MaterialPageRoute(
                  builder: (_) => NowPlayingScreen(song: song),
                  settings: settings,
                );
              }
              debugPrint('Error: No song provided for /now_playing');
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Error: No song provided')),
                ),
                settings: settings,
              );
            case '/search_results':
              final query = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text('Results for "${query ?? ''}"')),
                  body: const Center(child: Text('Search results placeholder')),
                ),
                settings: settings,
              );
            default:
              debugPrint('Unknown route: ${settings.name}');
              return MaterialPageRoute(
                builder: (_) =>
                    const Scaffold(body: Center(child: Text('Page not found'))),
                settings: settings,
              );
          }
        } catch (e) {
          debugPrint('Route generation error: $e');
          return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: Center(child: Text('Navigation error: $e'))),
            settings: settings,
          );
        }
      },
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title placeholder')),
    );
  }
}
