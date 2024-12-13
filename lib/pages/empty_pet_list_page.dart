import 'package:flutter/material.dart';
import 'package:pet_app/pages/pet_home_page.dart';

class EmptyPetListPage extends StatelessWidget {
  const EmptyPetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: AssetImage("assets/empty_page.jpg")),
                SizedBox(height: 5),
                Text(
                  "Oops! your pet list is empty",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PetHomePage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Pet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
