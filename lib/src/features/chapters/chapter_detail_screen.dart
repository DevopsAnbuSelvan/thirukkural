import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/kural_card.dart';
import '../../providers/app_state.dart';

class ChapterDetailScreen extends StatelessWidget {
  const ChapterDetailScreen({
    super.key,
    required this.chapterId,
  });

  final int chapterId;

  @override
  Widget build(BuildContext context) {
    final repository = AppState.of(context).repository;
    final chapter = repository.getChapter(chapterId);
    final padding = Responsive.horizontalPadding(context);
    final maxWidth = Responsive.contentMaxWidth(context);

    if (chapter == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('அதிகாரம்')),
        body: const AppErrorWidget(message: 'அதிகாரம் கிடைக்கவில்லை'),
      );
    }

    final kurals = repository.getChapterKurals(chapter.id);

    return Scaffold(
      appBar: AppBar(title: Text(chapter.nameTamil)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
            itemCount: kurals.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.nameTamil,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        chapter.nameEnglish,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chapter.kuralRangeLabel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                );
              }

              final kural = kurals[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: KuralCard(
                  kural: kural,
                  compact: true,
                  onTap: () => context.push('/kural/${kural.number}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
