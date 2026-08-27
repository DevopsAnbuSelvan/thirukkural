import 'package:flutter/material.dart';

import '../../core/utils/kural_actions.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/error_widget.dart';
import '../../models/kural_model.dart';
import '../../providers/app_state.dart';

class KuralDetailScreen extends StatelessWidget {
  const KuralDetailScreen({
    super.key,
    required this.number,
  });

  final int number;

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final kural = appState.repository.getKural(number);
    final padding = Responsive.horizontalPadding(context);
    final maxWidth = Responsive.contentMaxWidth(context);

    if (kural == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('குறள்')),
        body: const AppErrorWidget(message: 'குறள் கிடைக்கவில்லை'),
      );
    }

    final isFavorite = appState.isFavorite(kural.number);

    return Scaffold(
      appBar: AppBar(
        title: Text('குறள் ${kural.number}'),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'பிடித்தவை நீக்கு' : 'பிடித்தவை',
            onPressed: () => toggleFavorite(context, kural.number),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Theme.of(context).colorScheme.error : null,
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
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(padding, 8, padding, 32),
            children: [
              _KuralHero(kural: kural),
              const SizedBox(height: 20),
              if (Responsive.isMobile(context))
                ..._mobileSections(context, kural)
              else
                ..._desktopSections(context, kural),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _mobileSections(BuildContext context, KuralModel kural) {
    return [
      _ExpandableMeaning(
        title: 'English Translation',
        body: kural.translation,
        initiallyExpanded: true,
      ),
      _ExpandableMeaning(title: 'தமிழ் விளக்கம் (mv)', body: kural.mv),
      _ExpandableMeaning(title: 'தமிழ் விளக்கம் (sp)', body: kural.sp),
      _ExpandableMeaning(title: 'தமிழ் விளக்கம் (mk)', body: kural.mk),
      _ExpandableMeaning(title: 'ஆங்கில விளக்கம்', body: kural.explanation),
      _ExpandableMeaning(title: 'English Couplet', body: kural.couplet),
      _ExpandableMeaning(title: 'Transliteration', body: kural.transliteration),
    ];
  }

  List<Widget> _desktopSections(BuildContext context, KuralModel kural) {
    return [
      _MeaningBlock(title: 'English Translation', body: kural.translation),
      _MeaningBlock(title: 'தமிழ் விளக்கம் (mv)', body: kural.mv),
      _MeaningBlock(title: 'தமிழ் விளக்கம் (sp)', body: kural.sp),
      _MeaningBlock(title: 'தமிழ் விளக்கம் (mk)', body: kural.mk),
      _MeaningBlock(title: 'ஆங்கில விளக்கம்', body: kural.explanation),
      _MeaningBlock(title: 'English Couplet', body: kural.couplet),
      _MeaningBlock(title: 'Transliteration', body: kural.transliteration),
    ];
  }
}

class _KuralHero extends StatelessWidget {
  const _KuralHero({required this.kural});

  final KuralModel kural;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'குறள் ${kural.number}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              kural.line1,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(height: 1.5),
            ),
            Text(
              kural.line2,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeaningBlock extends StatelessWidget {
  const _MeaningBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    if (body.trim().isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(body, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableMeaning extends StatelessWidget {
  const _ExpandableMeaning({
    required this.title,
    required this.body,
    this.initiallyExpanded = false,
  });

  final String title;
  final String body;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    if (body.trim().isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          title: Text(title, style: theme.textTheme.titleMedium),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(body, style: theme.textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
