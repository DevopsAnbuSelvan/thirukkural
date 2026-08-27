import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/kural_model.dart';
import '../../../core/widgets/kural_card.dart';

/// Home daily highlight — wraps [KuralCard] for clarity at call sites.
class DailyKuralCard extends StatelessWidget {
  const DailyKuralCard({
    super.key,
    required this.kural,
  });

  final KuralModel kural;

  @override
  Widget build(BuildContext context) {
    return KuralCard(
      kural: kural,
      onTap: () => context.push('/kural/${kural.number}'),
    );
  }
}
