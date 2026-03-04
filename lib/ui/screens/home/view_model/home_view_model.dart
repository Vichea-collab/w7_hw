import 'package:flutter/widgets.dart';

import '../../../../data/repositories/history/user_history_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/songs/song.dart';
import '../../../states/player_state.dart';

class HomeViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  final UserHistoryRepository _userHistoryRepository;
  final PlayerState _playerState;

  List<Song> _allSongs = [];
  List<Song> _recentSongs = [];

  HomeViewModel({
    required SongRepository songRepository,
    required UserHistoryRepository userHistoryRepository,
    required PlayerState playerState,
  }) : _songRepository = songRepository,
       _userHistoryRepository = userHistoryRepository,
       _playerState = playerState;

  void init() {
    _allSongs = _songRepository.fetchSongs();
    _refreshRecentSongsFromHistory();

    _playerState.addListener(_onPlayerStateChanged);
    notifyListeners();
  }

  List<Song> get recentSongs => _recentSongs.take(3).toList();

  List<Song> get recommendedSongs {
    final recentIds = _recentSongs.map((song) => song.id).toSet();
    final suggestions = _allSongs
        .where((song) => !recentIds.contains(song.id))
        .take(3)
        .toList();

    if (suggestions.isNotEmpty) return suggestions;
    return _allSongs.take(3).toList();
  }

  bool isPlaying(Song song) => _playerState.currentSong?.id == song.id;

  void play(Song song) {
    _playerState.start(song);
  }

  void stop() {
    _playerState.stop();
  }

  void _onPlayerStateChanged() {
    final currentSong = _playerState.currentSong;
    if (currentSong != null) {
      _userHistoryRepository.addSongId(currentSong.id);
      _refreshRecentSongsFromHistory();
    }

    notifyListeners();
  }

  void _refreshRecentSongsFromHistory() {
    final recentIds = _userHistoryRepository.fetchRecentSongIds();
    _recentSongs = _mapIdsToSongs(recentIds);

    if (_recentSongs.isEmpty) {
      _recentSongs = _allSongs.take(3).toList();
    }
  }

  List<Song> _mapIdsToSongs(List<String> ids) {
    return ids
        .map((id) => _songRepository.fetchSongById(id))
        .whereType<Song>()
        .toList();
  }

  @override
  void dispose() {
    _playerState.removeListener(_onPlayerStateChanged);
    super.dispose();
  }
}
