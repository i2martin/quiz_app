import 'package:flutter/material.dart';
import 'package:quiz_app/models/data_models.dart';

class SubcategoryMenu extends StatelessWidget {
  @override
  const SubcategoryMenu(
      {super.key,
      required this.subcategories,
      required this.updateSubcategory});
  final Function(String subcategory) updateSubcategory;

  final List<Subcategory> subcategories;

  @override
  Widget build(BuildContext context) {
    if (subcategories.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: DropdownMenu<String>(
          menuHeight: 200,
          dropdownMenuEntries: subcategories
              .map((item) => DropdownMenuEntry<String>(
                  value: item.subcategory, label: item.subcategory))
              .toList(),
          enableSearch: true,
          enableFilter: true,
          label: const Text("Podkategorija"),
          initialSelection: "",
          width: 250,
          onSelected: (String? subcategory) {
            updateSubcategory(subcategory!);
          },
        ),
      );
    } else {
      return const Text("");
    }
  }
}
