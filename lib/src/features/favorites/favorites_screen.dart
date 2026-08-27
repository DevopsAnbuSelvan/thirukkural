import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/kural_card.dart';
import '../../providers/app_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final favorites = appState.getFavoriteKurals();
    final padding = Responsive.horizontalPadding(context);
    final maxWidth = Responsive.contentMaxWidth(context);
    final isDesktop = !Responsive.isMobile(context);

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('பிடித்தவை')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: favorites.isEmpty
              ? Center(
                  child: Text(
                    'பிடித்த குறள்கள் இல்லை',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
                  itemCount: favorites.length + (isDesktop ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isDesktop && index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'பிடித்தவை',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    }
                    final kural = favorites[isDesktop ? index - 1 : index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: KuralCard(kural: kural, compact: true),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
