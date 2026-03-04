import 'user_history_repository.dart';

class UserHistoryRepositoryMock implements UserHistoryRepository {
  final List<String> _recentSongIds = ['101', '102'];

  @override
  List<String> fetchRecentSongIds() {
    return List.unmodifiable(_recentSongIds);
  }

  @override
  void addSongId(String songId) {
    _recentSongIds.removeWhere((id) => id == songId);
    _recentSongIds.insert(0, songId);

    if (_recentSongIds.length > 10) {
      _recentSongIds.removeRange(10, _recentSongIds.length);
    }
  }
}
