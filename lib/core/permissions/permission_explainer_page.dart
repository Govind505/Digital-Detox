import 'package:flutter/material.dart';

class PermissionExplainerPage extends StatelessWidget {
  const PermissionExplainerPage({
    required this.title,
    required this.whyNeeded,
    required this.whatCollected,
    required this.onContinue,
    super.key,
  });

  final String title;
  final String whyNeeded;
  final String whatCollected;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Why this permission is needed', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(whyNeeded),
            const SizedBox(height: 16),
            Text('What is collected', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(whatCollected),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(onPressed: onContinue, child: const Text('Continue')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
