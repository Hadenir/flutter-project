import 'package:flutter/material.dart';

class EntryDetailsScreenPage<W extends Widget> extends Page {
  final W screen;

  const EntryDetailsScreenPage({required this.screen});

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => screen,
    );
  }
}
