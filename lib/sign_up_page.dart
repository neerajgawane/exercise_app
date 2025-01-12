import 'package:flutter/material.dart';
import 'package:exercise_app/exercise_selection_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? _selectedSex; // Variable to store the selected sex from dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Card widget to give a modern look to the form
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                            _nameController, 'Name', 'Please enter your name'),
                        const SizedBox(height: 15),
                        _buildTextField(_emailController, 'Email',
                            'Please enter your email',
                            keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 15),
                        _buildTextField(_numberController, 'Phone Number',
                            'Please enter your phone number',
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 15),
                        _buildTextField(
                            _ageController, 'Age', 'Please enter your age',
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 15),
                        _buildTextField(_heightController, 'Height (cm)',
                            'Please enter your height',
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 15),
                        _buildTextField(_weightController, 'Weight (kg)',
                            'Please enter your weight',
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: _selectedSex,
                          decoration: const InputDecoration(
                            labelText: 'Sex',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Male', 'Female', 'Other']
                              .map((sex) => DropdownMenuItem(
                                    value: sex,
                                    child: Text(sex),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your sex';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ExerciseSelectionPage()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create reusable text fields with validation
  Widget _buildTextField(
      TextEditingController controller, String label, String validationMessage,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
