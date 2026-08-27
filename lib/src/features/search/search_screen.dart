import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/kural_card.dart';
import '../../models/kural_model.dart';
import '../../providers/app_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  List<KuralModel> _results = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      final repository = AppState.read(context).repository;
      setState(() {
        _query = value.trim();
        _results = _query.isEmpty ? const [] : repository.search(_query);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final maxWidth = Responsive.contentMaxWidth(context);
    final isDesktop = !Responsive.isMobile(context);

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('தேடல்')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(padding, 16, padding, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'தேடல்',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    TextField(
                      controller: _controller,
                      onChanged: _onQueryChanged,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'குறள் எண் அல்லது சொல்...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildBody(padding),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(double padding) {
    if (_query.isEmpty) {
      return Center(
        child: Text(
          'எண் அல்லது சொல்லால் தேடுங்கள்',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'முடிவுகள் இல்லை',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(padding, 8, padding, 32),
      itemCount: _results.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${_results.length} முடிவுகள்',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }
        final kural = _results[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: KuralCard(kural: kural, compact: true),
        );
      },
    );
  }
}
