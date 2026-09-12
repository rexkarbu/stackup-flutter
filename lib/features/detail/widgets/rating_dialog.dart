import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_colors.dart';

class RatingDialog extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingSelected;

  const RatingDialog({
    super.key,
    required this.initialRating,
    required this.onRatingSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required double initialRating,
    required ValueChanged<double> onRatingSelected,
  }) {
    return showDialog(
      context: context,
      builder: (_) => RatingDialog(
        initialRating: initialRating,
        onRatingSelected: onRatingSelected,
      ),
    );
  }

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating > 0 ? widget.initialRating : 4.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber, size: 24),
          SizedBox(width: 8),
          Text(
            'Beri Rating Game',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selamat telah menyelesaikan game ini! Berapa rating yang ingin kamu berikan?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Rating Display Number
          Text(
            _rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 12),

          // Rating Bar Stars
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star_rounded,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            widget.onRatingSelected(_rating);
            Navigator.of(context).pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
