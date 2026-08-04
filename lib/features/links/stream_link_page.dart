import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/media_link_rules.dart';
import '../../core/utils/responsive.dart';
import '../../l10n/strings.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';
import '../browser/web_browser_page.dart';

class StreamLinkPage extends StatefulWidget {
  const StreamLinkPage({super.key, required this.platform});

  final StreamPlatform platform;

  @override
  State<StreamLinkPage> createState() => _StreamLinkPageState();
}

class _StreamLinkPageState extends State<StreamLinkPage> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    final s = AppStrings.of(context);
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() => _error = s.pasteFirst);
      return;
    }
    if (!MediaLinkRules.isValid(input, widget.platform)) {
      setState(() {
        _error = widget.platform == StreamPlatform.youtube
            ? s.invalidYoutube
            : s.invalidVimeo;
      });
      return;
    }
    final url = MediaLinkRules.normalize(input, widget.platform);
    if (url == null) {
      setState(() => _error = s.invalidUrl);
      return;
    }
    await Haptics.light();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => WebBrowserPage(initialUrl: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final label = MediaLinkRules.label(widget.platform);
    final pad = Breakpoints.pad(context);

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(title: label),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, 8, pad, MediaQuery.paddingOf(context).bottom + 24),
        children: [
          Text(s.pasteLink(label), style: TextStyle(height: 1.45, color: context.muted)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: s.linkLabel(label),
              hintText: MediaLinkRules.hint(widget.platform),
              errorText: _error,
            ),
            keyboardType: TextInputType.url,
            autocorrect: false,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: s.openInBrowser,
            icon: Icons.open_in_browser_rounded,
            onPressed: _open,
          ),
          const SizedBox(height: 16),
          CautionBanner(message: s.notAffiliated),
        ],
      ),
    );
  }
}
