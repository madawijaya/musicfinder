import 'package:flutter/material.dart';

class MusicSearchField extends StatelessWidget {
  const MusicSearchField({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: 'Cari judul lagu atau artis...',
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: IconButton(
        tooltip: 'Cari lagu',
        icon: const Icon(Icons.arrow_forward_rounded),
        onPressed: onSearch,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    ),
    onSubmitted: (_) => onSearch(),
  );
}
