import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/utils/responsive.dart';
import '../../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final padding = Responsive.horizontalPadding(context);
    final maxWidth = Responsive.contentMaxWidth(context);
    final isDesktop = !Responsive.isMobile(context);

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('அமைப்புகள்')),
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
                    'அமைப்புகள்',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              Text('தீம்', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('வெளிச்சம்'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('இருள்'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('அமைப்பு'),
                    icon: Icon(Icons.settings_suggest_outlined),
                  ),
                ],
                selected: {appState.themeMode},
                onSelectionChanged: (values) {
                  appState.setThemeMode(values.first);
                },
              ),
              const SizedBox(height: 28),
              Text('எழுத்து அளவு', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SegmentedButton<AppFontSize>(
                segments: [
                  for (final size in AppFontSize.values)
                    ButtonSegment(
                      value: size,
                      label: Text(size.label),
                    ),
                ],
                selected: {appState.fontSize},
                onSelectionChanged: (values) {
                  appState.setFontSize(values.first);
                },
              ),
              const SizedBox(height: 32),
              Text(
                'திருக்குறள் · 1330 குறள்கள் · 133 அதிகாரங்கள்',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
