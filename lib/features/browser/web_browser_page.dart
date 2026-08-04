import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/url_tools.dart';
import '../../l10n/strings.dart';
import '../../platform/airplay_views.dart';
import '../../services/haptics.dart';
import '../../ui/components.dart';

class WebBrowserPage extends StatefulWidget {
  const WebBrowserPage({super.key, this.initialUrl = AppConfig.browserHomeUrl});

  final String initialUrl;

  @override
  State<WebBrowserPage> createState() => _WebBrowserPageState();
}

class _WebBrowserPageState extends State<WebBrowserPage> {
  late final WebViewController _web;
  late final TextEditingController _url;
  bool _loading = true;
  bool _canBack = false;
  bool _canForward = false;
  double _progress = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _url = TextEditingController(text: widget.initialUrl);
    _web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (!mounted) return;
            setState(() => _progress = p / 100);
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _loading = true;
              _error = null;
            });
          },
          onPageFinished: (_) => _syncNav(),
          onWebResourceError: (e) {
            if (!mounted) return;
            setState(() {
              _loading = false;
              _error = e.description.isNotEmpty ? e.description : AppStrings.of(context).pageFailed;
            });
          },
        ),
      );
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(widget.initialUrl));
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _syncNav() async {
    final back = await _web.canGoBack();
    final forward = await _web.canGoForward();
    final current = await _web.currentUrl();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _canBack = back;
      _canForward = forward;
      if (current != null) _url.text = current;
    });
  }

  Future<void> _load(String raw) async {
    final normalized = UrlTools.normalizeBrowserUrl(raw);
    if (normalized == null) {
      if (!mounted) return;
      setState(() {
        _error = AppStrings.of(context).invalidUrl;
        _loading = false;
      });
      return;
    }
    await _web.loadRequest(Uri.parse(normalized));
  }

  Future<void> _go() async {
    await Haptics.selection();
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    await _load(_url.text);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pad = Breakpoints.pad(context);

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: FeatureAppBar(
        title: s.browser,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: RoutePickerButton(width: 40, height: 40),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_loading)
            LinearProgressIndicator(
              value: _progress > 0 ? _progress : null,
              minHeight: 3,
              backgroundColor: Colors.transparent,
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(pad, 8, pad, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _url,
                    decoration: InputDecoration(hintText: s.enterUrl),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _go(),
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _go,
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _canBack
                    ? () {
                        Haptics.selection();
                        _web.goBack();
                      }
                    : null,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              IconButton(
                onPressed: _canForward
                    ? () {
                        Haptics.selection();
                        _web.goForward();
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
              IconButton(
                onPressed: () {
                  Haptics.selection();
                  _web.reload();
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
              IconButton(
                onPressed: () {
                  _url.text = AppConfig.browserHomeUrl;
                  _go();
                },
                icon: const Icon(Icons.home_rounded),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(pad, 0, pad, 16),
              child: _error != null
                  ? EmptyPanel(
                      icon: Icons.wifi_off_rounded,
                      title: s.pageFailed,
                      message: _error!,
                      action: PrimaryButton(
                        label: s.tryAgain,
                        icon: Icons.refresh_rounded,
                        onPressed: _go,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: WebViewWidget(controller: _web),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
