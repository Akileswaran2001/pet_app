import 'package:flutter/material.dart';
import 'package:pet_app/pages/empty_pet_list_page.dart';

void main() {
  runApp(const PetManagementUI());
}

class PetManagementUI extends StatelessWidget {
  const PetManagementUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmptyPetListPage(),
    );
  }
}
