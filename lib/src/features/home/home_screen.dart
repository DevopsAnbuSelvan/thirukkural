import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/section_card.dart';
import '../../providers/app_state.dart';
import 'widgets/daily_kural_card.dart';
import 'widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final repository = appState.repository;
    final daily = repository.getDailyKural();
    final sections = repository.getSections();
    final padding = Responsive.horizontalPadding(context);
    final maxWidth = Responsive.contentMaxWidth(context);
    final isDesktop = !Responsive.isMobile(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text(AppConstants.appNameTamil),
              actions: [
                IconButton(
                  tooltip: 'அமைப்புகள்',
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
            children: [
              Text(
                isDesktop ? 'இன்றைய திருக்குறள்' : 'இன்றைய குறள்',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: isDesktop ? TextAlign.center : TextAlign.start,
              ),
              const SizedBox(height: 16),
              DailyKuralCard(kural: daily),
              const SizedBox(height: 28),
              Text(
                'விரைவு செயல்கள்',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 520;
                  final actions = [
                    QuickActionCard(
                      icon: Icons.search,
                      label: 'தேடல்',
                      onTap: () => context.go('/search'),
                    ),
                    QuickActionCard(
                      icon: Icons.casino_outlined,
                      label: 'Random',
                      onTap: () {
                        final kural = repository.getRandomKural();
                        context.push('/kural/${kural.number}');
                      },
                    ),
                  ];

                  if (wide) {
                    return Row(
                      children: [
                        Expanded(child: actions[0]),
                        const SizedBox(width: 12),
                        Expanded(child: actions[1]),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      actions[0],
                      const SizedBox(height: 12),
                      actions[1],
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Text(
                'பால்கள்',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final useGrid = constraints.maxWidth > 700;
                  final cards = sections.map((section) {
                    final count =
                        repository.getChaptersBySection(section.id).length;
                    return SectionCard(section: section, chapterCount: count);
                  }).toList();

                  if (!useGrid) {
                    return Column(
                      children: [
                        for (var i = 0; i < cards.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          cards[i],
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(child: cards[i]),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
