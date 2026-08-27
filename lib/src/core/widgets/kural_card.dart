import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/kural_model.dart';
import '../../providers/app_state.dart';
import '../utils/kural_actions.dart';

class KuralCard extends StatelessWidget {
  const KuralCard({
    super.key,
    required this.kural,
    this.showActions = true,
    this.onTap,
    this.compact = false,
  });

  final KuralModel kural;
  final bool showActions;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppState.of(context);
    final isFavorite = appState.isFavorite(kural.number);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap ?? () => context.push('/kural/${kural.number}'),
        child: Padding(
          padding: EdgeInsets.all(compact ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'குறள் ${kural.number}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: compact ? 10 : 14),
              Text(
                kural.line1,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                kural.line2,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              if (showActions) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: isFavorite ? 'பிடித்தவை நீக்கு' : 'பிடித்தவை',
                      onPressed: () => toggleFavorite(context, kural.number),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? theme.colorScheme.error : null,
                      ),
                    ),
                    IconButton(
                      tooltip: 'பகிர்',
                      onPressed: () => shareKural(context, kural),
                      icon: const Icon(Icons.share_outlined),
                    ),
                    IconButton(
                      tooltip: 'நகலெடு',
                      onPressed: () => copyKural(context, kural),
                      icon: const Icon(Icons.copy_outlined),
                    ),
                    IconButton(
                      tooltip: 'விவரம்',
                      onPressed: () => context.push('/kural/${kural.number}'),
                      icon: const Icon(Icons.open_in_new),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
