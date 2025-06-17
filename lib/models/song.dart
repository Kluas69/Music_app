class Song {
  final String title;
  final String artist;
  final String album;
  final String images;
  final Duration duration;
  final String audioPath;

  Song({
    required this.title,
    required this.artist,
    required this.album,
    required this.images,
    required this.duration,
    required this.audioPath,
  });

  static List<Song> mockSongs = [
    Song(
      title: "Dreams",
      artist: "Luna Waves",
      album: "Moonlit Nights",
      images: "assets/images/1.jpg",
      duration: const Duration(minutes: 3, seconds: 45),
      audioPath: "assets/audio/1.mp3",
    ),
    Song(
      title: "Echoes",
      artist: "Stellar Vibes",
      album: "Cosmic Journey",
      images: "assets/images/2.jpg",
      duration: const Duration(minutes: 4, seconds: 10),
      audioPath: "assets/audio/2.mp3",
    ),
    Song(
      title: "Horizon",
      artist: "Dawn Riders",
      album: "Sunrise Tunes",
      images: "assets/images/3.jpg",
      duration: const Duration(minutes: 3, seconds: 30),
      audioPath: "assets/audio/3.mp3",
    ),
  ];
}
