import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/section_model.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.section,
    required this.chapterCount,
  });

  final SectionModel section;
  final int chapterCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/chapters?section=${section.id}'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.nameTamil,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                section.nameEnglish,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '$chapterCount அதிகாரங்கள்',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
