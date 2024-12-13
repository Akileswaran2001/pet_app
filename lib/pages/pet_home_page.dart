import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pet_app/pages/updated_list.dart';

class PetHomePage extends StatefulWidget {
  const PetHomePage({super.key});

  @override
  _PetHomePageState createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {
  String? _filePath;
  String? _fileName;
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _petType;
  String? _gender;

  bool _petNameError = false;
  bool _ownerNameError = false;
  bool _locationError = false;
  bool _petTypeError = false;
  bool _genderError = false;
  bool _fileError = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textScale = screenWidth / 375;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add your pet Detail',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Name
              _buildLabel('Your pet name', textScale),
              const SizedBox(height: 5),
              TextField(
                controller: _petNameController,
                decoration: _buildInputDecoration(
                  'Enter your pet name',
                  _petNameError,
                ),
              ),
              const SizedBox(height: 10),

              // Pet Owner
              _buildLabel('Your pet owner', textScale),
              const SizedBox(height: 5),
              TextField(
                controller: _ownerNameController,
                decoration: _buildInputDecoration(
                  'Enter your name',
                  _ownerNameError,
                ),
              ),
              const SizedBox(height: 10),

              // Pet Type Dropdown
              _buildLabel('Type of Pet', textScale),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                  DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                  DropdownMenuItem(value: 'Bird', child: Text('Bird')),
                ],
                onChanged: (value) => setState(() => _petType = value),
                decoration: _buildInputDecoration('Pet', _petTypeError),
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              _buildLabel('Gender', textScale),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) => setState(() => _gender = value),
                decoration: _buildInputDecoration('Gender', _genderError),
              ),
              const SizedBox(height: 16),

              // Pet Location
              _buildLabel('Enter pet Location', textScale),
              const SizedBox(height: 5),
              TextField(
                controller: _locationController,
                decoration: _buildInputDecoration(
                  'Enter pet location',
                  _locationError,
                ),
              ),
              const SizedBox(height: 16),

              // Upload Photos
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(
                  Icons.upload_file,
                  color: Color.fromARGB(255, 96, 182, 252),
                ),
                label: const Text('Upload Photos'),
              ),
              if (_filePath != null) ...[
                const SizedBox(height: 16),
                Image.file(File(_filePath!), height: 200, fit: BoxFit.cover),
                Text('File Name: $_fileName'),
              ],
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth, 50),
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText, bool hasError) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color.fromARGB(255, 230, 228, 228),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              hasError ? Colors.red : const Color.fromARGB(255, 230, 228, 228),
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  Widget _buildLabel(String text, double textScale) {
    return Text(
      text,
      style: TextStyle(fontSize: 14 * textScale, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
        _fileError = false;
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _petNameError = _petNameController.text.isEmpty;
      _ownerNameError = _ownerNameController.text.isEmpty;
      _locationError = _locationController.text.isEmpty;
      _petTypeError = _petType == null;
      _genderError = _gender == null;
      _fileError = _filePath == null;
    });

    if (_petNameError ||
        _ownerNameError ||
        _locationError ||
        _petTypeError ||
        _genderError ||
        _fileError) {
      _showAlertDialog(
          'Validation Error', 'Please fill all fields and upload a file.');
      return;
    }

    var url = Uri.parse('https://valamcars.rankuhigher.in/api/register/form');
    var request = http.MultipartRequest('POST', url)
      ..fields['pet_name'] = _petNameController.text
      ..fields['user_name'] = _ownerNameController.text
      ..fields['pet_type'] = _petType!
      ..fields['gender'] = _gender!
      ..fields['location'] = _locationController.text
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        _filePath!,
        filename: _fileName,
      ));

    var response = await request.send();
    if (response.statusCode == 200) {
      _showSuccessDialog();
    } else {
      _showAlertDialog('Submission Error', 'Form submission failed.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Form submitted successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdatedPetListPage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
