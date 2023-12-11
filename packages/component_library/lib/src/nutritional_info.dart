import 'package:flutter/material.dart';

class NutritionalInfo extends StatelessWidget {
  const NutritionalInfo({
    super.key,
    required this.nutritionalInfo,
  });

  final Map<String, String> nutritionalInfo;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Nutritional Information',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      children: nutritionalInfo.entries.map((entry) {
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          title: Text(entry.key),
          trailing: Text(entry.value),
        );
      }).toList(),
    );
  }
}
