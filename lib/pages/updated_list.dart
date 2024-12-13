import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pet_home_page.dart'; // Import PetHomePage

class UpdatedPetListPage extends StatefulWidget {
  const UpdatedPetListPage({super.key});

  @override
  _UpdatedPetListPageState createState() => _UpdatedPetListPageState();
}

class _UpdatedPetListPageState extends State<UpdatedPetListPage> {
  List<dynamic> petList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPetDetails();
  }

  Future<void> fetchPetDetails() async {
    const String url = 'https://valamcars.rankuhigher.in/api/get/form';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          petList = json.decode(response.body)['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch pet details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching pet details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet List'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // Ensure text color is black
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : petList.isEmpty
                    ? const Center(
                        child: Text(
                          "No pets found!",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: petList.length,
                          itemBuilder: (context, index) {
                            final pet = petList[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        pet['image'] ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            const Icon(Icons.error, size: 50),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pet['pet_name'] ?? 'Unknown Pet',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Owner: ${pet['user_name'] ?? 'Unknown'}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Type: ${pet['pet_type'] ?? 'Unknown'}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Gender: ${pet['gender'] ?? 'Unknown'}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                pet['location'] ??
                                                    'Unknown Location',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SizedBox(
                width: 275,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PetHomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Pet'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
