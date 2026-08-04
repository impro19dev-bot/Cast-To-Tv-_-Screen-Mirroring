# Cast To Tv _ Screen Mirroring

Fresh Flutter rebuild for casting media to compatible TVs with honest AirPlay and iOS Screen Mirroring guidance.

**Bundle ID:** `com.casttotv.castscreenmirroring`

## Features

- AirPlay route picker (public `AVRoutePickerView`)
- Photo & video casting via system external playback
- YouTube / Vimeo link opening in an in-app browser (when sites allow)
- Built-in web browser
- Screen mirroring instructions (Control Center) + optional LAN Wi‑Fi JPEG viewer
- Remote-control information (not an IR remote)
- Connection troubleshooting, Privacy Policy, Terms, Support
- Light/dark theme, EN/FR/ES/AR, haptic toggle

## Build

```bash
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
flutter build ios --release
```

No advertising or analytics SDKs are included.
