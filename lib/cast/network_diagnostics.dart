import 'dart:io';

class NetworkDiagnostics {
  const NetworkDiagnostics({
    required this.wifiLikely,
    required this.ipv4Addresses,
    this.primaryIpv4,
  });

  final bool wifiLikely;
  final List<String> ipv4Addresses;
  final String? primaryIpv4;

  static Future<NetworkDiagnostics> probe() async {
    final addresses = <String>[];
    String? primary;
    var wifiLikely = false;

    try {
      final interfaces = await NetworkInterface.list(
        includeLinkLocal: false,
        type: InternetAddressType.IPv4,
      );
      for (final iface in interfaces) {
        final name = iface.name.toLowerCase();
        final isWifi = name.contains('en0') ||
            name.contains('en1') ||
            name.contains('wlan') ||
            name.contains('wi-fi') ||
            name.contains('wifi');
        for (final addr in iface.addresses) {
          if (addr.isLoopback) continue;
          addresses.add(addr.address);
          if (isWifi) {
            wifiLikely = true;
            primary ??= addr.address;
          }
        }
      }
      primary ??= addresses.isNotEmpty ? addresses.first : null;
      if (!wifiLikely && addresses.isNotEmpty) {
        // Non-cellular private LAN addresses often indicate local network.
        wifiLikely = addresses.any((a) =>
            a.startsWith('192.168.') ||
            a.startsWith('10.') ||
            a.startsWith('172.'));
      }
    } catch (_) {}

    return NetworkDiagnostics(
      wifiLikely: wifiLikely,
      ipv4Addresses: addresses,
      primaryIpv4: primary,
    );
  }
}
