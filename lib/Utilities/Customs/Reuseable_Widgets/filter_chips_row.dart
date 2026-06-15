import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_filter_chip.dart';

/// A horizontal, scrollable row of [AppFilterChip]s on a white strip — the
/// standard filter bar used on the job feed, notifications, etc.
///
/// Generic over the filter value [T] so it works with plain labels or keyed
/// values (provide [labelOf] to map a value to its display text).
///
/// Examples:
/// ```dart
/// // Simple string filters:
/// FilterChipsRow<String>(
///   values: ['All', 'Remote', 'Recent'],
///   selected: _selectedType,
///   onSelected: (f) => setState(() => _selectedType = f),
/// );
///
/// // Keyed filters with separate labels:
/// FilterChipsRow<String?>(
///   values: _filterLabels.keys.toList(),
///   selected: c.activeFilter.value,
///   labelOf: (k) => _filterLabels[k]!,
///   onSelected: c.setFilter,
/// );
/// ```
class FilterChipsRow<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Maps a value to its chip label. Defaults to the value's `toString()`.
  final String Function(T value)? labelOf;

  const FilterChipsRow({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelected,
    this.labelOf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: values.map((v) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppFilterChip(
              label: labelOf?.call(v) ?? '$v',
              selected: v == selected,
              onTap: () => onSelected(v),
            ),
          )).toList(),
        ),
      ),
    );
  }
}
