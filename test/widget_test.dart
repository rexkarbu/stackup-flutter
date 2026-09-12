import 'package:flutter_test/flutter_test.dart';
import 'package:stackup/core/theme/app_colors.dart';
import 'package:stackup/models/game_enums.dart';

void main() {
  test('AppColors getStatusColor returns correct palette', () {
    expect(AppColors.getStatusColor(GameStatus.backlog), AppColors.statusBacklog);
    expect(AppColors.getStatusColor(GameStatus.playing), AppColors.statusPlaying);
    expect(AppColors.getStatusColor(GameStatus.completed), AppColors.statusCompleted);
    expect(AppColors.getStatusColor(GameStatus.dropped), AppColors.statusDropped);
  });
}
