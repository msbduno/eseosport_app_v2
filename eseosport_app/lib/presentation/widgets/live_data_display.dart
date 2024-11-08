import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/live_data_viewmodel.dart';

class LiveDataDisplay extends StatelessWidget {
  const LiveDataDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveDataViewModel>(
      builder: (context, viewModel, child) {
        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Données en direct',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildDataRow(
                  context,
                  'Vitesse',
                  '${viewModel.currentSpeed.toStringAsFixed(1)} km/h',
                ),
                if (viewModel.currentAltitude != null)
                  _buildDataRow(
                    context,
                    'Altitude',
                    '${viewModel.currentAltitude!.toStringAsFixed(1)} m',
                  ),
                if (viewModel.currentBPM != null)
                  _buildDataRow(
                    context,
                    'BPM',
                    viewModel.currentBPM.toString(),
                  ),
                _buildDataRow(
                  context,
                  'Heure',
                  _formatDateTime(viewModel.timestamp),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }
}