import 'package:flutter/material.dart';

import '../../cast/cast_item.dart';
import '../../cast/cast_session_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/media_link_rules.dart';
import '../../l10n/strings.dart';
import '../../ui/components.dart';
import '../browser/web_browser_page.dart';
import '../links/media_url_cast_page.dart';
import '../links/stream_link_page.dart';
import '../photos/photos_page.dart';
import '../photos/slideshow_page.dart';
import '../videos/videos_page.dart';

class CastTab extends StatelessWidget {
  const CastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);
    final session = CastSessionProvider.of(context);

    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(pad, 16, pad, 28),
          children: [
            Text(
              s.mediaCast,
              style: TextStyle(
                fontSize: Breakpoints.title(context),
                fontWeight: FontWeight.w800,
                color: context.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(s.wifiNotice, style: TextStyle(color: context.muted, height: 1.4)),
            const SizedBox(height: 18),
            GradientTile(
              title: s.mediaUrl,
              subtitle: s.mediaUrlBody,
              colors: Palette.mediaGradient,
              icon: Icons.link_rounded,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MediaUrlCastPage(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
              children: [
                MediaChip(
                  label: s.photos,
                  icon: Icons.slideshow_rounded,
                  tint: Palette.amber,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const PhotosPage()),
                  ),
                ),
                MediaChip(
                  label: s.videos,
                  icon: Icons.videocam_outlined,
                  tint: Palette.coral,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const VideosPage()),
                  ),
                ),
                MediaChip(
                  label: s.youtube,
                  icon: Icons.play_arrow_rounded,
                  tint: Palette.coral,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const StreamLinkPage(platform: StreamPlatform.youtube),
                    ),
                  ),
                ),
                MediaChip(
                  label: s.vimeo,
                  icon: Icons.play_circle_outline,
                  tint: Palette.brand,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const StreamLinkPage(platform: StreamPlatform.vimeo),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GradientTile(
              title: s.browser,
              subtitle: s.guideBody3,
              colors: const [Palette.leaf, Palette.teal],
              icon: Icons.language_rounded,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const WebBrowserPage()),
              ),
            ),
            if (session.hasQueue) ...[
              const SizedBox(height: 18),
              Text(
                s.nowCasting,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.ink,
                ),
              ),
              const SizedBox(height: 8),
              SoftCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(session.current?.title ?? ''),
                  subtitle: Text(
                    '${session.index + 1} / ${session.queue.length}',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    final item = session.current;
                    if (item == null) return;
                    if (item.isPhoto) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SlideshowPage(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
            if (session.recent.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                s.recentCasts,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.ink,
                ),
              ),
              const SizedBox(height: 8),
              SoftCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < session.recent.length && i < 5; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      ListTile(
                        title: Text(session.recent[i].title),
                        subtitle: Text(session.recent[i].kind.name),
                        trailing: const Icon(Icons.cast_rounded, size: 18),
                        onTap: () {
                          final item = session.recent[i];
                          if (item.isPhoto) {
                            session.setPhotoQueue([item], startSlideshow: false);
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SlideshowPage(),
                              ),
                            );
                          } else if (item.kind == CastItemKind.networkMedia) {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    MediaUrlCastPage(initialUrl: item.source),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            CautionBanner(message: s.notAffiliated),
          ],
        ),
      ),
    );
  }
}
