import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_filter_chip.dart';

class FilterChipsRow<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final ValueChanged<T> onSelected;

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
