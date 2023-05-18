import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LaunchesPage extends ConsumerStatefulWidget {
  const LaunchesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LaunchesPageState();
}

class _LaunchesPageState extends ConsumerState<LaunchesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Center(child: const Text('Launch Times')),
      ),
      body: Center(child: Text('Will be soon')),
    );
  }
}
