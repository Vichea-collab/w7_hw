import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/songs/song.dart';
import '../../../states/settings_state.dart';
import '../../../theme/theme.dart';
import '../view_model/home_view_model.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final settingsState = context.watch<AppSettingsState>();

    return Container(
      color: settingsState.theme.backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("Home", style: AppTextStyles.heading)),
            const SizedBox(height: 36),
            Text(
              "Your recent songs",
              style: AppTextStyles.label.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 8),
            ...viewModel.recentSongs.map(
              (song) => HomeSongRow(
                song: song,
                isPlaying: viewModel.isPlaying(song),
                onPlay: () => viewModel.play(song),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSongRow extends StatelessWidget {
  const HomeSongRow({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onPlay,
  });

  final Song song;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPlay,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: Text(song.title, style: AppTextStyles.label)),
            if (isPlaying)
              const Text("Playing", style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}
