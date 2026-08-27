import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';
import '../../models/chapter_model.dart';
import '../../models/section_model.dart';
import '../../providers/app_state.dart';
import 'widgets/chapter_card.dart';

class ChaptersScreen extends StatefulWidget {
  const ChaptersScreen({
    super.key,
    this.initialSectionId,
  });

  final int? initialSectionId;

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  int? _selectedSectionId;

  @override
  void initState() {
    super.initState();
    _selectedSectionId = widget.initialSectionId;
  }

  @override
  void didUpdateWidget(covariant ChaptersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSectionId != widget.initialSectionId) {
      _selectedSectionId = widget.initialSectionId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = AppState.of(context).repository;
    final sections = repository.getSections();
    final padding = Responsive.horizontalPadding(context);
    final maxWidth = Responsive.contentMaxWidth(context);
    final isDesktop = !Responsive.isMobile(context);

    final filteredSections = _selectedSectionId == null
        ? sections
        : sections.where((s) => s.id == _selectedSectionId).toList();

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(title: const Text('அதிகாரங்கள்')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
            children: [
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'அதிகாரங்கள்',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('அனைத்தும்'),
                    selected: _selectedSectionId == null,
                    onSelected: (_) => setState(() => _selectedSectionId = null),
                  ),
                  for (final section in sections)
                    FilterChip(
                      label: Text(section.nameTamil),
                      selected: _selectedSectionId == section.id,
                      onSelected: (_) =>
                          setState(() => _selectedSectionId = section.id),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              for (final section in filteredSections) ...[
                _SectionHeader(
                  section: section,
                  chapterCount:
                      repository.getChaptersBySection(section.id).length,
                ),
                const SizedBox(height: 12),
                ..._chapterList(
                  repository.getChaptersBySection(section.id),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _chapterList(List<ChapterModel> chapters) {
    return [
      for (final chapter in chapters)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ChapterCard(
            chapter: chapter,
            onTap: () => context.push('/chapter/${chapter.id}'),
          ),
        ),
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.section,
    required this.chapterCount,
  });

  final SectionModel section;
  final int chapterCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.nameTamil, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          '$chapterCount Chapters · ${section.nameEnglish}',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
