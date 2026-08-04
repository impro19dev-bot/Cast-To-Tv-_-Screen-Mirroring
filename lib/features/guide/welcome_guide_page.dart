import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../data/prefs_store.dart';
import '../../l10n/strings.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';
import '../hub/root_shell.dart';

class WelcomeGuidePage extends StatefulWidget {
  const WelcomeGuidePage({super.key, this.markComplete = true});

  final bool markComplete;

  @override
  State<WelcomeGuidePage> createState() => _WelcomeGuidePageState();
}

class _WelcomeGuidePageState extends State<WelcomeGuidePage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await Haptics.light();
    if (widget.markComplete) {
      await PrefsStore.instance.setOnboardingDone(true);
    }
    if (!mounted) return;
    if (widget.markComplete) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const RootShell()),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pages = [
      (Icons.photo_library_outlined, s.guideTitle1, s.guideBody1),
      (Icons.screen_share_outlined, s.guideTitle2, s.guideBody2),
      (Icons.language_rounded, s.guideTitle3, s.guideBody3),
    ];

    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(s.skip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = pages[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: Palette.brand.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.$1, size: 44, color: Palette.brand),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          page.$2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: context.ink,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          page.$3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: context.muted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? Palette.brand : context.muted.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: PrimaryButton(
                label: _index == pages.length - 1 ? s.getStarted : s.next,
                onPressed: () async {
                  await Haptics.selection();
                  if (_index == pages.length - 1) {
                    await _finish();
                  } else {
                    await _controller.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
