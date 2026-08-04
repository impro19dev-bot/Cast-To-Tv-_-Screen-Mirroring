import 'package:flutter/material.dart';

import '../core/constants/app_config.dart';

typedef _T = Map<String, String>;

class AppStrings {
  AppStrings(this._code);

  final String _code;

  static const supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('es'),
    Locale('ar'),
  ];

  static AppStrings of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return AppStrings(code);
  }

  static AppStrings forLocale(Locale locale) => AppStrings(locale.languageCode);

  String _t(_T map) => map[_code] ?? map['en']!;

  String get appName => AppConfig.appDisplayName;
  String get shortName => AppConfig.appShortName;

  String get wifiNotice => _t({
        'en':
            'Keep your phone and TV on the same Wi‑Fi network for discovery and casting.',
        'fr':
            'Gardez le téléphone et la TV sur le même Wi‑Fi pour la découverte et le cast.',
        'es':
            'Mantén el teléfono y la TV en la misma Wi‑Fi para descubrir y transmitir.',
        'ar':
            'أبقِ الهاتف والتلفاز على نفس شبكة Wi‑Fi للاكتشاف والبث.',
      });

  String get tabHome =>
      _t({'en': 'Home', 'fr': 'Accueil', 'es': 'Inicio', 'ar': 'الرئيسية'});
  String get tabCast =>
      _t({'en': 'Cast', 'fr': 'Cast', 'es': 'Cast', 'ar': 'البث'});
  String get tabMirror =>
      _t({'en': 'Mirror', 'fr': 'Miroir', 'es': 'Espejo', 'ar': 'المرآة'});
  String get tabMore =>
      _t({'en': 'More', 'fr': 'Plus', 'es': 'Más', 'ar': 'المزيد'});

  String get connectDevice => _t({
        'en': 'Connect a TV',
        'fr': 'Connecter une TV',
        'es': 'Conectar una TV',
        'ar': 'الاتصال بتلفاز',
      });
  String get connectHint => _t({
        'en': 'Open AirPlay route picker and troubleshooting tips',
        'fr': 'Ouvrir le sélecteur AirPlay et les conseils',
        'es': 'Abrir el selector AirPlay y consejos',
        'ar': 'افتح منتقي AirPlay ونصائح الاستكشاف',
      });

  String get screenMirror => _t({
        'en': 'Screen Mirror',
        'fr': 'Miroir d’écran',
        'es': 'Duplicar pantalla',
        'ar': 'انعكاس الشاشة',
      });
  String get screenMirrorHint => _t({
        'en': 'Control Center AirPlay + optional Wi‑Fi viewer',
        'fr': 'AirPlay via Centre de contrôle + visionneuse Wi‑Fi',
        'es': 'AirPlay desde Centro de control + visor Wi‑Fi',
        'ar': 'AirPlay من مركز التحكم + عارض Wi‑Fi اختياري',
      });

  String get remoteControl => _t({
        'en': 'Remote tips',
        'fr': 'Astuces télécommande',
        'es': 'Consejos de control',
        'ar': 'نصائح التحكم',
      });
  String get photos =>
      _t({'en': 'Photos', 'fr': 'Photos', 'es': 'Fotos', 'ar': 'الصور'});
  String get videos =>
      _t({'en': 'Videos', 'fr': 'Vidéos', 'es': 'Videos', 'ar': 'الفيديو'});
  String get browser => _t({
        'en': 'Browser',
        'fr': 'Navigateur',
        'es': 'Navegador',
        'ar': 'المتصفح',
      });
  String get youtube => 'YouTube';
  String get vimeo => 'Vimeo';
  String get mediaCast => _t({
        'en': 'Media cast',
        'fr': 'Cast média',
        'es': 'Cast de medios',
        'ar': 'بث الوسائط',
      });
  String get howItWorks => _t({
        'en': 'How it works',
        'fr': 'Comment ça marche',
        'es': 'Cómo funciona',
        'ar': 'كيف يعمل',
      });
  String get howItWorksHint => _t({
        'en': 'Honest limits, setup steps, and casting basics',
        'fr': 'Limites réelles, étapes et bases du cast',
        'es': 'Límites reales, pasos y conceptos básicos',
        'ar': 'حدود واضحة وخطوات الإعداد وأساسيات البث',
      });

  String get settings =>
      _t({'en': 'Settings', 'fr': 'Réglages', 'es': 'Ajustes', 'ar': 'الإعدادات'});
  String get language =>
      _t({'en': 'Language', 'fr': 'Langue', 'es': 'Idioma', 'ar': 'اللغة'});
  String get appearance => _t({
        'en': 'Appearance',
        'fr': 'Apparence',
        'es': 'Apariencia',
        'ar': 'المظهر',
      });
  String get haptics => _t({
        'en': 'Haptic feedback',
        'fr': 'Retour haptique',
        'es': 'Respuesta háptica',
        'ar': 'اهتزاز اللمس',
      });
  String get privacyPolicy => _t({
        'en': 'Privacy Policy',
        'fr': 'Politique de confidentialité',
        'es': 'Política de privacidad',
        'ar': 'سياسة الخصوصية',
      });
  String get termsOfUse => _t({
        'en': 'Terms of Use',
        'fr': 'Conditions d’utilisation',
        'es': 'Términos de uso',
        'ar': 'شروط الاستخدام',
      });
  String get support =>
      _t({'en': 'Support', 'fr': 'Assistance', 'es': 'Soporte', 'ar': 'الدعم'});
  String get contactUs => _t({
        'en': 'Contact Us',
        'fr': 'Contactez-nous',
        'es': 'Contáctanos',
        'ar': 'تواصل معنا',
      });
  String get shareApp => _t({
        'en': 'Share app',
        'fr': 'Partager l’app',
        'es': 'Compartir app',
        'ar': 'مشاركة التطبيق',
      });
  String get version =>
      _t({'en': 'Version', 'fr': 'Version', 'es': 'Versión', 'ar': 'الإصدار'});
  String get systemDefault => _t({
        'en': 'System',
        'fr': 'Système',
        'es': 'Sistema',
        'ar': 'النظام',
      });
  String get lightMode =>
      _t({'en': 'Light', 'fr': 'Clair', 'es': 'Claro', 'ar': 'فاتح'});
  String get darkMode =>
      _t({'en': 'Dark', 'fr': 'Sombre', 'es': 'Oscuro', 'ar': 'داكن'});

  String get continueLabel =>
      _t({'en': 'Continue', 'fr': 'Continuer', 'es': 'Continuar', 'ar': 'متابعة'});
  String get getStarted => _t({
        'en': 'Get started',
        'fr': 'Commencer',
        'es': 'Empezar',
        'ar': 'ابدأ',
      });
  String get next =>
      _t({'en': 'Next', 'fr': 'Suivant', 'es': 'Siguiente', 'ar': 'التالي'});
  String get skip =>
      _t({'en': 'Skip', 'fr': 'Passer', 'es': 'Omitir', 'ar': 'تخطي'});

  String get guideTitle1 => _t({
        'en': 'Cast photos & videos',
        'fr': 'Diffusez photos et vidéos',
        'es': 'Transmite fotos y videos',
        'ar': 'ابث الصور والفيديو',
      });
  String get guideBody1 => _t({
        'en':
            'Pick media from your library, then use the system AirPlay route picker to send playback to a compatible TV.',
        'fr':
            'Choisissez un média, puis utilisez le sélecteur AirPlay système pour l’envoyer vers une TV compatible.',
        'es':
            'Elige medios de tu biblioteca y usa el selector AirPlay del sistema para enviarlos a una TV compatible.',
        'ar':
            'اختر وسائط من مكتبتك ثم استخدم منتقي AirPlay لإرسالها إلى تلفاز متوافق.',
      });
  String get guideTitle2 => _t({
        'en': 'Screen mirroring limits',
        'fr': 'Limites du miroir d’écran',
        'es': 'Límites de duplicación',
        'ar': 'حدود انعكاس الشاشة',
      });
  String get guideBody2 => _t({
        'en':
            'Full iOS screen mirroring is started from Control Center → Screen Mirroring. This app cannot force that system sheet open.',
        'fr':
            'Le miroir d’écran iOS complet se lance depuis le Centre de contrôle → Miroir. Cette app ne peut pas forcer cette feuille système.',
        'es':
            'La duplicación completa de iOS se inicia desde Centro de control → Duplicar pantalla. Esta app no puede abrir esa hoja del sistema.',
        'ar':
            'انعكاس شاشة iOS الكامل يبدأ من مركز التحكم ← انعكاس الشاشة. لا يمكن لهذا التطبيق فتح تلك الورقة النظامية.',
      });
  String get guideTitle3 => _t({
        'en': 'Links & browser',
        'fr': 'Liens et navigateur',
        'es': 'Enlaces y navegador',
        'ar': 'الروابط والمتصفح',
      });
  String get guideBody3 => _t({
        'en':
            'Open YouTube or Vimeo links in the built-in browser when allowed by those sites. Playback availability depends on each service.',
        'fr':
            'Ouvrez des liens YouTube ou Vimeo dans le navigateur intégré lorsque les sites le permettent. La lecture dépend de chaque service.',
        'es':
            'Abre enlaces de YouTube o Vimeo en el navegador integrado cuando esos sitios lo permitan. La reproducción depende de cada servicio.',
        'ar':
            'افتح روابط YouTube أو Vimeo في المتصفح المدمج عندما تسمح المواقع بذلك. يعتمد التشغيل على كل خدمة.',
      });

  String get connectTitle => _t({
        'en': 'Connect to TV',
        'fr': 'Connexion TV',
        'es': 'Conectar a la TV',
        'ar': 'الاتصال بالتلفاز',
      });
  String get connectSubtitle => _t({
        'en':
            'Use Apple’s AirPlay route picker for compatible devices. This app is not affiliated with Apple or TV brands.',
        'fr':
            'Utilisez le sélecteur AirPlay d’Apple pour les appareils compatibles. Cette app n’est pas affiliée à Apple ni aux marques de TV.',
        'es':
            'Usa el selector AirPlay de Apple para dispositivos compatibles. Esta app no está afiliada a Apple ni a marcas de TV.',
        'ar':
            'استخدم منتقي AirPlay من Apple للأجهزة المتوافقة. هذا التطبيق غير تابع لـ Apple أو لعلامات التلفاز.',
      });
  String get airplayPicker => _t({
        'en': 'AirPlay route picker',
        'fr': 'Sélecteur de route AirPlay',
        'es': 'Selector de ruta AirPlay',
        'ar': 'منتقي مسار AirPlay',
      });
  String get tapAirplay => _t({
        'en': 'Tap the AirPlay button to choose a nearby compatible display.',
        'fr': 'Touchez le bouton AirPlay pour choisir un écran compatible proche.',
        'es': 'Toca el botón AirPlay para elegir una pantalla compatible cercana.',
        'ar': 'اضغط زر AirPlay لاختيار شاشة متوافقة قريبة.',
      });
  String get sameWifi => _t({
        'en': 'Same Wi‑Fi network',
        'fr': 'Même réseau Wi‑Fi',
        'es': 'Misma red Wi‑Fi',
        'ar': 'نفس شبكة Wi‑Fi',
      });
  String get sameWifiBody => _t({
        'en':
            'Phone and TV must share the same local network. Guest networks or AP isolation often block discovery.',
        'fr':
            'Le téléphone et la TV doivent partager le même réseau local. Les réseaux invités ou l’isolation AP bloquent souvent la découverte.',
        'es':
            'El teléfono y la TV deben compartir la misma red local. Las redes de invitados o el aislamiento AP suelen bloquear el descubrimiento.',
        'ar':
            'يجب أن يشارك الهاتف والتلفاز نفس الشبكة المحلية. شبكات الضيوف أو عزل نقاط الوصول غالباً تمنع الاكتشاف.',
      });
  String get airplayOnTv => _t({
        'en': 'AirPlay enabled on the TV',
        'fr': 'AirPlay activé sur la TV',
        'es': 'AirPlay activado en la TV',
        'ar': 'تفعيل AirPlay على التلفاز',
      });
  String get airplayOnTvBody => _t({
        'en':
            'Enable AirPlay / screen sharing in your TV or streaming-box settings. Exact menus vary by manufacturer.',
        'fr':
            'Activez AirPlay / le partage d’écran dans les réglages de la TV ou du boîtier. Les menus varient selon la marque.',
        'es':
            'Activa AirPlay / compartir pantalla en los ajustes de la TV o del decodificador. Los menús varían según el fabricante.',
        'ar':
            'فعّل AirPlay / مشاركة الشاشة في إعدادات التلفاز أو جهاز البث. تختلف القوائم حسب الشركة.',
      });
  String get disableVpn => _t({
        'en': 'Disable VPN temporarily',
        'fr': 'Désactiver le VPN temporairement',
        'es': 'Desactiva la VPN temporalmente',
        'ar': 'عطّل VPN مؤقتاً',
      });
  String get disableVpnBody => _t({
        'en':
            'VPNs can hide devices on your LAN. Turn VPN off while connecting, then turn it back on if needed.',
        'fr':
            'Un VPN peut masquer les appareils du LAN. Désactivez-le pendant la connexion, puis réactivez-le si besoin.',
        'es':
            'Una VPN puede ocultar dispositivos en la LAN. Desactívala al conectar y vuelve a activarla si hace falta.',
        'ar':
            'قد يخفي VPN الأجهزة على الشبكة المحلية. أوقفه أثناء الاتصال ثم أعد تشغيله عند الحاجة.',
      });
  String get restartGear => _t({
        'en': 'Restart TV & router',
        'fr': 'Redémarrer TV et routeur',
        'es': 'Reinicia TV y router',
        'ar': 'أعد تشغيل التلفاز والموجّه',
      });
  String get restartGearBody => _t({
        'en':
            'If nothing appears, power-cycle the TV and router, wait a minute, then reopen the route picker.',
        'fr':
            'Si rien n’apparaît, redémarrez la TV et le routeur, attendez une minute, puis rouvrez le sélecteur.',
        'es':
            'Si no aparece nada, reinicia la TV y el router, espera un minuto y vuelve a abrir el selector.',
        'ar':
            'إذا لم يظهر شيء، أعد تشغيل التلفاز والموجّه، انتظر دقيقة، ثم افتح المنتقي مجدداً.',
      });
  String get airplayNote => _t({
        'en':
            'Device lists and connection success depend on Apple frameworks and your hardware. This app cannot invent unsupported receivers.',
        'fr':
            'La liste des appareils et le succès de connexion dépendent des frameworks Apple et de votre matériel. Cette app ne peut pas inventer de récepteurs non pris en charge.',
        'es':
            'Las listas de dispositivos y el éxito de conexión dependen de los frameworks de Apple y tu hardware. Esta app no puede inventar receptores no compatibles.',
        'ar':
            'قوائم الأجهزة ونجاح الاتصال يعتمدان على أطر عمل Apple وجهازك. لا يمكن لهذا التطبيق اختراع أجهزة غير مدعومة.',
      });

  String get mirroringUsesCc => _t({
        'en': 'Full mirroring uses Control Center',
        'fr': 'Le miroir complet passe par le Centre de contrôle',
        'es': 'La duplicación completa usa el Centro de control',
        'ar': 'الانعكاس الكامل عبر مركز التحكم',
      });
  String get mirroringBannerBody => _t({
        'en':
            'Apple requires Screen Mirroring to be started from Control Center. Below you also get an optional Wi‑Fi viewer URL for smart TVs with a browser.',
        'fr':
            'Apple exige de démarrer le Miroir d’écran depuis le Centre de contrôle. Ci‑dessous, une URL Wi‑Fi optionnelle pour les TV avec navigateur.',
        'es':
            'Apple exige iniciar Duplicar pantalla desde el Centro de control. Abajo hay una URL Wi‑Fi opcional para TVs con navegador.',
        'ar':
            'تتطلب Apple بدء انعكاس الشاشة من مركز التحكم. أدناه رابط عارض Wi‑Fi اختياري للتلفازات ذات المتصفح.',
      });
  String get wifiViewer => _t({
        'en': 'Wi‑Fi viewer (optional)',
        'fr': 'Visionneuse Wi‑Fi (optionnel)',
        'es': 'Visor Wi‑Fi (opcional)',
        'ar': 'عارض Wi‑Fi (اختياري)',
      });
  String get wifiViewerBody => _t({
        'en':
            'Starts a local JPEG stream of your screen. Open the URL on a TV browser on the same Wi‑Fi. Quality and latency are limited; this is not AirPlay Screen Mirroring.',
        'fr':
            'Démarre un flux JPEG local de l’écran. Ouvrez l’URL dans le navigateur TV sur le même Wi‑Fi. Qualité et latence limitées ; ce n’est pas le Miroir AirPlay.',
        'es':
            'Inicia un flujo JPEG local de la pantalla. Abre la URL en el navegador de la TV en la misma Wi‑Fi. Calidad y latencia limitadas; no es AirPlay Screen Mirroring.',
        'ar':
            'يبدأ بث JPEG محلي لشاشتك. افتح الرابط في متصفح التلفاز على نفس Wi‑Fi. الجودة والتأخير محدودان؛ هذا ليس انعكاس AirPlay.',
      });
  String get startMirror => _t({
        'en': 'Start Wi‑Fi viewer',
        'fr': 'Démarrer la visionneuse',
        'es': 'Iniciar visor Wi‑Fi',
        'ar': 'بدء عارض Wi‑Fi',
      });
  String get stopMirror => _t({
        'en': 'Stop Wi‑Fi viewer',
        'fr': 'Arrêter la visionneuse',
        'es': 'Detener visor Wi‑Fi',
        'ar': 'إيقاف عارض Wi‑Fi',
      });
  String get mirrorUrlLabel => _t({
        'en': 'Open this URL on your TV browser',
        'fr': 'Ouvrez cette URL dans le navigateur TV',
        'es': 'Abre esta URL en el navegador de la TV',
        'ar': 'افتح هذا الرابط في متصفح التلفاز',
      });
  String get copyUrl =>
      _t({'en': 'Copy URL', 'fr': 'Copier l’URL', 'es': 'Copiar URL', 'ar': 'نسخ الرابط'});
  String get urlCopied => _t({
        'en': 'URL copied',
        'fr': 'URL copiée',
        'es': 'URL copiada',
        'ar': 'تم نسخ الرابط',
      });
  String get mirrorFailed => _t({
        'en':
            'Could not start the Wi‑Fi viewer. Check Screen Recording permission and try again.',
        'fr':
            'Impossible de démarrer la visionneuse. Vérifiez l’autorisation d’enregistrement d’écran.',
        'es':
            'No se pudo iniciar el visor. Comprueba el permiso de grabación de pantalla.',
        'ar':
            'تعذر بدء عارض Wi‑Fi. تحقق من إذن تسجيل الشاشة وحاول مجدداً.',
      });
  String get airplayStatus => _t({
        'en': 'External AirPlay display',
        'fr': 'Affichage AirPlay externe',
        'es': 'Pantalla AirPlay externa',
        'ar': 'شاشة AirPlay خارجية',
      });
  String get active =>
      _t({'en': 'Active', 'fr': 'Actif', 'es': 'Activo', 'ar': 'نشط'});
  String get inactive =>
      _t({'en': 'Not detected', 'fr': 'Non détecté', 'es': 'No detectado', 'ar': 'غير مكتشف'});
  String get refresh =>
      _t({'en': 'Refresh status', 'fr': 'Actualiser', 'es': 'Actualizar', 'ar': 'تحديث الحالة'});
  String get step1 => _t({
        'en': 'Swipe to open Control Center on your iPhone.',
        'fr': 'Balayez pour ouvrir le Centre de contrôle.',
        'es': 'Desliza para abrir el Centro de control.',
        'ar': 'اسحب لفتح مركز التحكم على iPhone.',
      });
  String get step2 => _t({
        'en': 'Tap Screen Mirroring and choose a compatible display.',
        'fr': 'Touchez Miroir d’écran et choisissez un affichage compatible.',
        'es': 'Toca Duplicar pantalla y elige una pantalla compatible.',
        'ar': 'اضغط انعكاس الشاشة واختر شاشة متوافقة.',
      });
  String get step3 => _t({
        'en': 'Keep this app open or switch apps — mirroring is system-managed.',
        'fr': 'Gardez l’app ouverte ou changez d’app — le miroir est géré par le système.',
        'es': 'Mantén la app abierta o cambia de app: la duplicación la gestiona el sistema.',
        'ar': 'أبقِ التطبيق مفتوحاً أو بدّل التطبيقات — النظام يدير الانعكاس.',
      });
  String get step4 => _t({
        'en': 'To stop, open Control Center → Screen Mirroring → Stop Mirroring.',
        'fr': 'Pour arrêter : Centre de contrôle → Miroir → Arrêter.',
        'es': 'Para detener: Centro de control → Duplicar → Detener.',
        'ar': 'للإيقاف: مركز التحكم ← انعكاس الشاشة ← إيقاف.',
      });
  String get mirroringWarning => _t({
        'en':
            'This app never claims to open the system Screen Mirroring sheet directly. Follow Control Center steps for official AirPlay mirroring.',
        'fr':
            'Cette app ne prétend pas ouvrir directement la feuille Miroir système. Suivez le Centre de contrôle pour le miroir AirPlay officiel.',
        'es':
            'Esta app no afirma abrir directamente la hoja de Duplicar pantalla. Sigue el Centro de control para AirPlay oficial.',
        'ar':
            'لا يدّعي هذا التطبيق فتح ورقة انعكاس الشاشة مباشرة. اتبع خطوات مركز التحكم لانعكاس AirPlay الرسمي.',
      });
  String get detailedHelp => _t({
        'en': 'Detailed mirroring help',
        'fr': 'Aide détaillée au miroir',
        'es': 'Ayuda detallada de duplicación',
        'ar': 'مساعدة انعكاس مفصّلة',
      });

  String get aboutRemote => _t({
        'en': 'About remote tips',
        'fr': 'À propos des astuces télécommande',
        'es': 'Sobre los consejos de control',
        'ar': 'حول نصائح التحكم',
      });
  String get aboutRemoteBody => _t({
        'en':
            'This section explains how playback controls work once AirPlay is active. It is not an infrared TV remote and does not replace your manufacturer remote.',
        'fr':
            'Cette section explique les commandes de lecture une fois AirPlay actif. Ce n’est pas une télécommande infrarouge et ne remplace pas celle du fabricant.',
        'es':
            'Esta sección explica los controles de reproducción con AirPlay activo. No es un mando infrarrojo ni sustituye el mando del fabricante.',
        'ar':
            'يشرح هذا القسم أدوات التحكم بعد تفعيل AirPlay. ليس جهاز تحكم بالأشعة تحت الحمراء ولا يستبدل جهاز الشركة.',
      });
  String get whenAirplay => _t({
        'en': 'When AirPlay is active',
        'fr': 'Quand AirPlay est actif',
        'es': 'Cuando AirPlay está activo',
        'ar': 'عند تفعيل AirPlay',
      });
  String get remoteStep1 => _t({
        'en': 'Use the player controls in this app for pause, seek, and volume where supported.',
        'fr': 'Utilisez les commandes du lecteur dans l’app pour pause, seek et volume si pris en charge.',
        'es': 'Usa los controles del reproductor en la app para pausa, seek y volumen si es compatible.',
        'ar': 'استخدم عناصر التحكم بالمشغّل في التطبيق للإيقاف والتقديم والصوت عند الدعم.',
      });
  String get remoteStep2 => _t({
        'en': 'Some TVs also expose Now Playing controls in Control Center while AirPlay is connected.',
        'fr': 'Certaines TV exposent aussi Now Playing dans le Centre de contrôle pendant AirPlay.',
        'es': 'Algunas TVs también muestran Now Playing en el Centro de control con AirPlay.',
        'ar': 'بعض التلفازات تعرض أيضاً Now Playing في مركز التحكم أثناء AirPlay.',
      });
  String get remoteStep3 => _t({
        'en': 'Channel changing, smart-TV apps, and IR codes are outside what public AirPlay APIs allow here.',
        'fr': 'Changer de chaîne, apps TV et codes IR dépassent ce que permettent les API AirPlay publiques ici.',
        'es': 'Cambiar de canal, apps de TV y códigos IR están fuera de lo que permiten las API públicas de AirPlay.',
        'ar': 'تغيير القنوات وتطبيقات التلفاز ورموز IR خارج ما تسمح به واجهات AirPlay العامة هنا.',
      });
  String get connectFirst => _t({
        'en': 'Connect a route first',
        'fr': 'Connectez d’abord une route',
        'es': 'Conecta primero una ruta',
        'ar': 'اتصل بمسار أولاً',
      });
  String get connectFirstBody => _t({
        'en': 'Pick an AirPlay output, then return to Photos or Videos to cast content.',
        'fr': 'Choisissez une sortie AirPlay, puis revenez à Photos ou Vidéos pour caster.',
        'es': 'Elige una salida AirPlay y vuelve a Fotos o Videos para transmitir.',
        'ar': 'اختر مخرج AirPlay ثم عد إلى الصور أو الفيديو للبث.',
      });
  String get goConnect => _t({
        'en': 'Open connect guide',
        'fr': 'Ouvrir le guide de connexion',
        'es': 'Abrir guía de conexión',
        'ar': 'فتح دليل الاتصال',
      });

  String get noPhoto => _t({
        'en': 'No photo selected',
        'fr': 'Aucune photo sélectionnée',
        'es': 'Ninguna foto seleccionada',
        'ar': 'لم تُحدد صورة',
      });
  String get choosePhotoMsg => _t({
        'en': 'Choose a photo, then use AirPlay to show it on a compatible TV.',
        'fr': 'Choisissez une photo, puis utilisez AirPlay pour l’afficher sur une TV compatible.',
        'es': 'Elige una foto y usa AirPlay para mostrarla en una TV compatible.',
        'ar': 'اختر صورة ثم استخدم AirPlay لعرضها على تلفاز متوافق.',
      });
  String get choosePhoto => _t({
        'en': 'Choose photo',
        'fr': 'Choisir une photo',
        'es': 'Elegir foto',
        'ar': 'اختر صورة',
      });
  String get photoCancelled => _t({
        'en': 'No photo selected',
        'fr': 'Aucune photo sélectionnée',
        'es': 'Ninguna foto seleccionada',
        'ar': 'لم تُحدد صورة',
      });
  String get photoPermissionDenied => _t({
        'en': 'Photo library access is required to pick images.',
        'fr': 'L’accès à la photothèque est requis pour choisir des images.',
        'es': 'Se requiere acceso a la biblioteca para elegir imágenes.',
        'ar': 'يلزم الوصول لمكتبة الصور لاختيار الصور.',
      });
  String get photoAirplayHint => _t({
        'en':
            'After selecting a photo, open the route picker and keep the preview on screen while casting.',
        'fr':
            'Après sélection, ouvrez le sélecteur de route et gardez l’aperçu à l’écran pendant le cast.',
        'es':
            'Tras elegir la foto, abre el selector de ruta y mantén la vista previa en pantalla al transmitir.',
        'ar':
            'بعد اختيار الصورة، افتح منتقي المسار وأبقِ المعاينة على الشاشة أثناء البث.',
      });
  String get photoPreview => _t({
        'en': 'Photo preview',
        'fr': 'Aperçu photo',
        'es': 'Vista previa',
        'ar': 'معاينة الصورة',
      });

  String get noVideo => _t({
        'en': 'No video selected',
        'fr': 'Aucune vidéo sélectionnée',
        'es': 'Ningún video seleccionado',
        'ar': 'لم يُحدد فيديو',
      });
  String get chooseVideoMsg => _t({
        'en':
            'Choose a video from your library. Playback uses AVPlayer with external playback enabled when available.',
        'fr':
            'Choisissez une vidéo. La lecture utilise AVPlayer avec lecture externe si disponible.',
        'es':
            'Elige un video. La reproducción usa AVPlayer con reproducción externa cuando esté disponible.',
        'ar':
            'اختر فيديو من مكتبتك. يستخدم التشغيل AVPlayer مع التشغيل الخارجي عند التوفر.',
      });
  String get chooseVideo => _t({
        'en': 'Choose video',
        'fr': 'Choisir une vidéo',
        'es': 'Elegir video',
        'ar': 'اختر فيديو',
      });
  String get videoPermissionDenied => _t({
        'en': 'Photo library access is required to pick videos.',
        'fr': 'L’accès à la photothèque est requis pour choisir des vidéos.',
        'es': 'Se requiere acceso a la biblioteca para elegir videos.',
        'ar': 'يلزم الوصول لمكتبة الصور لاختيار الفيديو.',
      });
  String get videoPlayer => _t({
        'en': 'Video player',
        'fr': 'Lecteur vidéo',
        'es': 'Reproductor',
        'ar': 'مشغّل الفيديو',
      });
  String get loadingVideo => _t({
        'en': 'Preparing video…',
        'fr': 'Préparation de la vidéo…',
        'es': 'Preparando video…',
        'ar': 'جارٍ تجهيز الفيديو…',
      });
  String get videoCannotPlay => _t({
        'en': 'This video cannot be opened',
        'fr': 'Cette vidéo ne peut pas être ouverte',
        'es': 'Este video no se puede abrir',
        'ar': 'لا يمكن فتح هذا الفيديو',
      });
  String get videoCannotOpen => _t({
        'en': 'Unsupported format, missing file, or permission issue.',
        'fr': 'Format non pris en charge, fichier manquant ou permission.',
        'es': 'Formato no compatible, archivo faltante o permiso.',
        'ar': 'تنسيق غير مدعوم أو ملف مفقود أو مشكلة إذن.',
      });
  String get chooseAnotherVideo => _t({
        'en': 'Choose another video',
        'fr': 'Choisir une autre vidéo',
        'es': 'Elegir otro video',
        'ar': 'اختر فيديو آخر',
      });
  String get castVideoBody => _t({
        'en':
            'Use the AirPlay button to route playback. Unsupported formats will fail with a clear error.',
        'fr':
            'Utilisez le bouton AirPlay pour router la lecture. Les formats non pris en charge échoueront clairement.',
        'es':
            'Usa el botón AirPlay para enrutar la reproducción. Los formatos no compatibles fallarán con un error claro.',
        'ar':
            'استخدم زر AirPlay لتوجيه التشغيل. ستفشل التنسيقات غير المدعومة برسالة واضحة.',
      });
  String get iosOnlyAirPlay => _t({
        'en': 'AirPlay video casting is available on iOS.',
        'fr': 'Le cast vidéo AirPlay est disponible sur iOS.',
        'es': 'El cast de video AirPlay está disponible en iOS.',
        'ar': 'بث فيديو AirPlay متاح على iOS.',
      });

  String pasteLink(String label) => _t({
        'en':
            'Paste a public $label link. We open it in the in-app browser; playback depends on $label and your network.',
        'fr':
            'Collez un lien $label public. Nous l’ouvrons dans le navigateur intégré ; la lecture dépend de $label et du réseau.',
        'es':
            'Pega un enlace público de $label. Lo abrimos en el navegador; la reproducción depende de $label y tu red.',
        'ar':
            'الصق رابط $label عاماً. نفتحه في المتصفح المدمج؛ يعتمد التشغيل على $label وشبكتك.',
      });
  String linkLabel(String label) => _t({
        'en': '$label link',
        'fr': 'Lien $label',
        'es': 'Enlace $label',
        'ar': 'رابط $label',
      });
  String get openInBrowser => _t({
        'en': 'Open in browser',
        'fr': 'Ouvrir dans le navigateur',
        'es': 'Abrir en el navegador',
        'ar': 'افتح في المتصفح',
      });
  String get pasteFirst => _t({
        'en': 'Paste a link first',
        'fr': 'Collez d’abord un lien',
        'es': 'Pega un enlace primero',
        'ar': 'الصق رابطاً أولاً',
      });
  String get invalidYoutube => _t({
        'en': 'Enter a valid YouTube watch, Shorts, or youtu.be URL.',
        'fr': 'Entrez une URL YouTube watch, Shorts ou youtu.be valide.',
        'es': 'Introduce una URL válida de YouTube, Shorts o youtu.be.',
        'ar': 'أدخل رابط YouTube أو Shorts أو youtu.be صالحاً.',
      });
  String get invalidVimeo => _t({
        'en': 'Enter a valid Vimeo video URL.',
        'fr': 'Entrez une URL Vimeo valide.',
        'es': 'Introduce una URL válida de Vimeo.',
        'ar': 'أدخل رابط فيديو Vimeo صالحاً.',
      });
  String get notAffiliated => _t({
        'en':
            'Not affiliated with YouTube, Vimeo, Apple, or TV manufacturers. Brand names are for identification only.',
        'fr':
            'Non affilié à YouTube, Vimeo, Apple ou aux fabricants de TV. Les marques sont citées à titre d’identification.',
        'es':
            'No afiliado a YouTube, Vimeo, Apple ni fabricantes de TV. Las marcas se usan solo para identificación.',
        'ar':
            'غير تابع لـ YouTube أو Vimeo أو Apple أو شركات التلفاز. الأسماء للتعريف فقط.',
      });

  String get enterUrl =>
      _t({'en': 'Enter URL', 'fr': 'Saisir l’URL', 'es': 'Introduce URL', 'ar': 'أدخل الرابط'});
  String get invalidUrl => _t({
        'en': 'Enter a valid http(s) URL.',
        'fr': 'Entrez une URL http(s) valide.',
        'es': 'Introduce una URL http(s) válida.',
        'ar': 'أدخل رابط http(s) صالحاً.',
      });
  String get pageFailed => _t({
        'en': 'Page failed to load',
        'fr': 'Échec du chargement',
        'es': 'Error al cargar',
        'ar': 'فشل تحميل الصفحة',
      });
  String get tryAgain =>
      _t({'en': 'Try again', 'fr': 'Réessayer', 'es': 'Reintentar', 'ar': 'أعد المحاولة'});

  String get shareMessage => _t({
        'en':
            'Check out ${AppConfig.appDisplayName} — cast media and follow clear AirPlay / mirroring guidance.',
        'fr':
            'Découvrez ${AppConfig.appDisplayName} — cast média et conseils AirPlay / miroir clairs.',
        'es':
            'Prueba ${AppConfig.appDisplayName}: transmite medios y sigue guías claras de AirPlay / duplicación.',
        'ar':
            'جرّب ${AppConfig.appDisplayName} — بث الوسائط وإرشادات AirPlay / الانعكاس بوضوح.',
      });
  String get cannotOpenMail => _t({
        'en': 'Could not open Mail.',
        'fr': 'Impossible d’ouvrir Mail.',
        'es': 'No se pudo abrir Mail.',
        'ar': 'تعذر فتح البريد.',
      });
  String get cannotOpenLink => _t({
        'en': 'Could not open link.',
        'fr': 'Impossible d’ouvrir le lien.',
        'es': 'No se pudo abrir el enlace.',
        'ar': 'تعذر فتح الرابط.',
      });

  String get disclaimerTitle => _t({
        'en': 'Independent app',
        'fr': 'Application indépendante',
        'es': 'App independiente',
        'ar': 'تطبيق مستقل',
      });
  String get disclaimerBody => _t({
        'en':
            '${AppConfig.appDisplayName} is an independent utility. It is not an official Apple, YouTube, Vimeo, or TV-manufacturer product.',
        'fr':
            '${AppConfig.appDisplayName} est un utilitaire indépendant. Ce n’est pas un produit officiel Apple, YouTube, Vimeo ou d’un fabricant de TV.',
        'es':
            '${AppConfig.appDisplayName} es una utilidad independiente. No es un producto oficial de Apple, YouTube, Vimeo ni de fabricantes de TV.',
        'ar':
            '${AppConfig.appDisplayName} أداة مستقلة. ليست منتجاً رسمياً من Apple أو YouTube أو Vimeo أو شركات التلفاز.',
      });

  String get slideshow => _t({
        'en': 'Slideshow',
        'fr': 'Diaporama',
        'es': 'Presentación',
        'ar': 'عرض الشرائح',
      });
  String get startSlideshow => _t({
        'en': 'Cast photo slideshow',
        'fr': 'Caster un diaporama',
        'es': 'Transmitir presentación',
        'ar': 'بث عرض الشرائح',
      });
  String get slideInterval => _t({
        'en': 'Interval',
        'fr': 'Intervalle',
        'es': 'Intervalo',
        'ar': 'المدة',
      });
  String get slideshowAirplayHint => _t({
        'en':
            'Keep this slideshow on screen and use the AirPlay button to route the display to a compatible TV.',
        'fr':
            'Gardez le diaporama à l’écran et utilisez AirPlay pour l’envoyer vers une TV compatible.',
        'es':
            'Mantén la presentación en pantalla y usa AirPlay para enviarla a una TV compatible.',
        'ar':
            'أبقِ عرض الشرائح على الشاشة واستخدم AirPlay لإرساله إلى تلفاز متوافق.',
      });

  String get mediaUrl => _t({
        'en': 'Media URL',
        'fr': 'URL média',
        'es': 'URL de medios',
        'ar': 'رابط وسائط',
      });
  String get mediaUrlBody => _t({
        'en':
            'Cast a direct media file URL (mp4, m3u8, mov, jpg…). This uses AVPlayer with AirPlay — not a website wrapper.',
        'fr':
            'Diffusez une URL de fichier média directe (mp4, m3u8…). Lecture via AVPlayer + AirPlay, pas un simple site web.',
        'es':
            'Transmite una URL directa de archivo (mp4, m3u8…). Usa AVPlayer con AirPlay, no un sitio web.',
        'ar':
            'ابث رابط ملف وسائط مباشر (mp4، m3u8…). يستخدم AVPlayer مع AirPlay وليس مجرد موقع.',
      });
  String get mediaUrlLabel => _t({
        'en': 'Direct media link',
        'fr': 'Lien média direct',
        'es': 'Enlace de medios',
        'ar': 'رابط وسائط مباشر',
      });
  String get castMediaUrl => _t({
        'en': 'Cast media URL',
        'fr': 'Caster l’URL',
        'es': 'Transmitir URL',
        'ar': 'بث الرابط',
      });
  String get unsupportedMediaUrl => _t({
        'en':
            'Use a direct media URL ending in a supported type (mp4, m3u8, mov, jpg…).',
        'fr':
            'Utilisez une URL média directe avec une extension prise en charge (mp4, m3u8…).',
        'es':
            'Usa una URL directa con un tipo compatible (mp4, m3u8, mov, jpg…).',
        'ar':
            'استخدم رابط وسائط مباشر بتنسيق مدعوم (mp4، m3u8، mov، jpg…).',
      });
  String get mediaUrlCaution => _t({
        'en':
            'Only public, DRM-free streams work. YouTube/Vimeo page links belong in the YouTube/Vimeo tools, not here.',
        'fr':
            'Seuls les flux publics sans DRM fonctionnent. Les pages YouTube/Vimeo vont dans leurs outils dédiés.',
        'es':
            'Solo funcionan streams públicos sin DRM. Los enlaces de YouTube/Vimeo van en sus herramientas.',
        'ar':
            'تعمل فقط البثوث العامة بدون DRM. روابط صفحات YouTube/Vimeo لها أدواتها الخاصة.',
      });

  String get playbackControls => _t({
        'en': 'Playback controls',
        'fr': 'Commandes de lecture',
        'es': 'Controles de reproducción',
        'ar': 'عناصر التشغيل',
      });
  String get nowCasting => _t({
        'en': 'Now casting',
        'fr': 'En cours de cast',
        'es': 'Transmitiendo',
        'ar': 'قيد البث',
      });
  String get nothingCasting => _t({
        'en': 'Nothing in the cast queue yet',
        'fr': 'Rien dans la file de cast',
        'es': 'Nada en la cola de cast',
        'ar': 'لا يوجد شيء في قائمة البث بعد',
      });
  String get mediaRemoteBody => _t({
        'en':
            'Control the current in-app cast session (queue, play/pause, seek). This is not an infrared TV remote.',
        'fr':
            'Contrôlez la session de cast (file, lecture, seek). Ce n’est pas une télécommande infrarouge.',
        'es':
            'Controla la sesión de cast (cola, play/pause, seek). No es un mando infrarrojo.',
        'ar':
            'تحكّم بجلسة البث الحالية (القائمة، تشغيل/إيقاف، تقديم). ليس جهاز تحكم بالأشعة تحت الحمراء.',
      });
  String get pickAirplayDevice => _t({
        'en': 'Choose AirPlay output',
        'fr': 'Choisir la sortie AirPlay',
        'es': 'Elegir salida AirPlay',
        'ar': 'اختر مخرج AirPlay',
      });

  String get sessionStatus => _t({
        'en': 'Live session',
        'fr': 'Session en direct',
        'es': 'Sesión en vivo',
        'ar': 'الجلسة الحالية',
      });
  String get localNetwork => _t({
        'en': 'Local network',
        'fr': 'Réseau local',
        'es': 'Red local',
        'ar': 'الشبكة المحلية',
      });
  String get scanMirrorQr => _t({
        'en': 'Scan to open Wi‑Fi viewer on TV',
        'fr': 'Scannez pour ouvrir la visionneuse TV',
        'es': 'Escanea para abrir el visor en la TV',
        'ar': 'امسح لفتح عارض Wi‑Fi على التلفاز',
      });
  String get quickActions => _t({
        'en': 'Quick cast',
        'fr': 'Cast rapide',
        'es': 'Cast rápido',
        'ar': 'بث سريع',
      });
  String get recentCasts => _t({
        'en': 'Recent casts',
        'fr': 'Casts récents',
        'es': 'Casts recientes',
        'ar': 'بثوث حديثة',
      });

  String languageName(String code) => switch (code) {
        'fr' => 'Français',
        'es' => 'Español',
        'ar' => 'العربية',
        _ => 'English',
      };
}
