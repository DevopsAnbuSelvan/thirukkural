import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/kural_model.dart';
import '../../providers/app_state.dart';

Future<void> copyKural(BuildContext context, KuralModel kural) async {
  await Clipboard.setData(ClipboardData(text: kural.copyText));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('குறள் நகலெடுக்கப்பட்டது')),
  );
}

Future<void> shareKural(BuildContext context, KuralModel kural) async {
  try {
    await SharePlus.instance.share(
      ShareParams(text: kural.shareText, subject: 'திருக்குறள்'),
    );
  } catch (_) {
    await Clipboard.setData(ClipboardData(text: kural.shareText));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('பகிர முடியவில்லை. குறள் நகலெடுக்கப்பட்டது'),
      ),
    );
  }
}

Future<void> toggleFavorite(BuildContext context, int number) {
  return AppState.read(context).toggleFavorite(number);
}
