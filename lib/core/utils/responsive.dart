import 'package:flutter/material.dart';

abstract final class Breakpoints {
  static bool compact(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide < 380;

  static double pad(BuildContext context) => compact(context) ? 16 : 20;

  static double title(BuildContext context) => compact(context) ? 20 : 22;
}
