import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pet_app/pages/updated_list.dart';

class PetHomePage extends StatefulWidget {
  const PetHomePage({super.key});

  @override
  _PetHomePageState createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {
  File? _imageFile;
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();
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
              _buildLabel('Your pet name', textScale),
              _buildTextField(_petNameController, 'ex. Bella', _petNameError),
              _buildLabel('Your pet owner name', textScale),
              _buildTextField(
                  _ownerNameController, 'Enter your name', _ownerNameError),
              _buildLabel('Type of Pet', textScale),
              _buildDropdown(
                items: const ['Dog', 'Cat', 'Bird'],
                hint: 'ex. Dog',
                onChanged: (value) => setState(() => _petType = value),
                hasError: _petTypeError,
              ),
              _buildLabel('Gender', textScale),
              _buildDropdown(
                items: const ['Male', 'Female'],
                hint: 'ex. Male',
                onChanged: (value) => setState(() => _gender = value),
                hasError: _genderError,
              ),
              _buildLabel('Enter pet location', textScale),
              _buildTextField(
                  _locationController, 'Enter pet location', _locationError),
              _buildLabel('Additional Notes', textScale),
              _buildTextField(_additionalNotesController,
                  'Add additional details here...', false,
                  maxLines: 3),
              _buildLabel('Add your pet profile picture and upload pet photos',
                  textScale),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: DottedBorder(
                    color: Colors.grey[300]!,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(15),
                    dashPattern: const [5, 5],
                    child: Container(
                      height: 100, // Reduced height
                      width: screenWidth * 0.7, // Increased width
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, size: 30, color: Colors.blue),
                          SizedBox(height: 5),
                          Text('Upload Photos',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 16),
                Image.file(_imageFile!, height: 200, fit: BoxFit.cover),
              ],
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth, 45),
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
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
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjusted
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Colors.grey[300]!), // Light grey border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, bool hasError,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: _buildInputDecoration(hintText, hasError),
      ),
    );
  }

  Widget _buildLabel(String text, double textScale) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 12 * textScale, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
    required bool hasError,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownButtonFormField<String>(
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: _buildInputDecoration(hint, hasError),
        dropdownColor: Colors.white, // Background set to white
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
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
      _fileError = _imageFile == null;
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
      ..fields['notes'] = _additionalNotesController.text
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
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
              onPressed: () => Navigator.of(context).pop(),
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
