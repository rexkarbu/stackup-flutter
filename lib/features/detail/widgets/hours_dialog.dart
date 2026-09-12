import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HoursDialog extends StatefulWidget {
  final double currentHours;
  final ValueChanged<double> onSave;

  const HoursDialog({
    super.key,
    required this.currentHours,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required double currentHours,
    required ValueChanged<double> onSave,
  }) {
    return showDialog(
      context: context,
      builder: (_) => HoursDialog(
        currentHours: currentHours,
        onSave: onSave,
      ),
    );
  }

  @override
  State<HoursDialog> createState() => _HoursDialogState();
}

class _HoursDialogState extends State<HoursDialog> {
  late double _hours;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _hours = widget.currentHours;
    _controller = TextEditingController(
      text: _hours % 1 == 0 ? _hours.toInt().toString() : _hours.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addHours(double delta) {
    setState(() {
      _hours = (_hours + delta).clamp(0.0, 99999.0);
      _controller.text =
          _hours % 1 == 0 ? _hours.toInt().toString() : _hours.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.schedule_rounded, color: AppColors.secondary, size: 22),
          SizedBox(width: 8),
          Text(
            'Catat Jam Bermain',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Jam Saat Ini',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              suffixText: 'Jam',
              suffixStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed >= 0) {
                _hours = parsed;
              }
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'TAMBAH CEPAT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildQuickButton('+1 jam', 1.0),
              const SizedBox(width: 8),
              _buildQuickButton('+2 jam', 2.0),
              const SizedBox(width: 8),
              _buildQuickButton('+5 jam', 5.0),
            ],
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
            widget.onSave(_hours);
            Navigator.of(context).pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  Widget _buildQuickButton(String label, double value) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.cardBorder),
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.card,
        ),
        onPressed: () => _addHours(value),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
