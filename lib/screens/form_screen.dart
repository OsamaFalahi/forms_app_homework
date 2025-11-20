import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../styles/app_theme.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  FormScreenState createState() => FormScreenState();
}

class FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _multilineController = TextEditingController();
  
  // Form values
  String? _selectedGender;
  String? _selectedCountry;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double _satisfactionRating = 3.0;
  double _progressLevel = 50.0;
  RangeValues _budgetRange = const RangeValues(20, 80);
  bool _subscribeToNewsletter = true;
  bool _agreeToTerms = false;
  final List<String> _selectedChips = [];
  
  // Available options
  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _countryOptions = ['Saudi Arabia', 'Yemen', 'UAE', 'Kuwait', 'Qatar', 'Other'];
  final List<String> _interestChips = ['Sports', 'Music', 'Technology', 'Reading', 'Travel', 'Cooking'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _multilineController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _toggleChip(String chip) {
    setState(() {
      if (_selectedChips.contains(chip)) {
        _selectedChips.remove(chip);
      } else {
        _selectedChips.add(chip);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Print all form values using debugPrint
      debugPrint('=== Form Submission ===');
      debugPrint('Name: ${_nameController.text}');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Password: ${_passwordController.text}');
      debugPrint('Phone: ${_phoneController.text}');
      debugPrint('Age: ${_ageController.text}');
      debugPrint('Gender: $_selectedGender');
      debugPrint('Country: $_selectedCountry');
      debugPrint('Birth Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Not selected'}');
      debugPrint('Preferred Time: ${_selectedTime != null ? _selectedTime!.format(context) : 'Not selected'}');
      debugPrint('Satisfaction Rating: $_satisfactionRating');
      debugPrint('Progress Level: $_progressLevel%');
      debugPrint('Budget Range: \$${_budgetRange.start.toInt()} - \$${_budgetRange.end.toInt()}');
      debugPrint('Subscribe to Newsletter: $_subscribeToNewsletter');
      debugPrint('Agree to Terms: $_agreeToTerms');
      debugPrint('Selected Interests: $_selectedChips');
      debugPrint('Additional Notes: ${_multilineController.text}');
      debugPrint('======================');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _ageController.clear();
    _multilineController.clear();
    setState(() {
      _selectedGender = null;
      _selectedCountry = null;
      _selectedDate = null;
      _selectedTime = null;
      _satisfactionRating = 3.0;
      _progressLevel = 50.0;
      _budgetRange = const RangeValues(20, 80);
      _subscribeToNewsletter = true;
      _agreeToTerms = false;
      _selectedChips.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Form Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
                hint: 'Please enter your name',
                isRequired: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                hint: 'Please enter your email',
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock,
                hint: 'Please enter a password',
                isPassword: true,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                isRequired: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _ageController,
                label: 'Age',
                icon: Icons.calendar_today,
                hint: 'Enter your age',
                keyboardType: TextInputType.number,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) {
                    return 'Please enter a valid age (1-120)';
                  }
                  return null;
                },
              ),
              
              // Demographics Section
              _buildSectionHeader('Demographics'),
              _buildDropdownField(
                value: _selectedGender,
                label: 'Gender',
                icon: Icons.person_outline,
                hint: 'Select your gender',
                items: _genderOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                value: _selectedCountry,
                label: 'Country',
                icon: Icons.location_on_outlined,
                hint: 'Select your country',
                items: _countryOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              
              // Date & Time Section
              _buildSectionHeader('Date & Time'),
              _buildDateField(
                label: 'Birth Date',
                selectedDate: _selectedDate,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 12),
              _buildTimeField(
                label: 'Preferred Time',
                selectedTime: _selectedTime,
                onTap: () => _selectTime(context),
              ),
              
              // Ratings & Preferences Section
              _buildSectionHeader('Ratings & Preferences'),
              _buildSliderField(
                label: 'Satisfaction Rating: ${_satisfactionRating.toStringAsFixed(1)}',
                value: _satisfactionRating,
                min: 1,
                max: 5,
                divisions: 8,
                onChanged: (value) {
                  setState(() {
                    _satisfactionRating = value;
                  });
                },
              ),
              _buildSliderField(
                label: 'Progress Level: ${_progressLevel.toInt()}%',
                value: _progressLevel,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    _progressLevel = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget Range: \$${_budgetRange.start.toInt()} - \$${_budgetRange.end.toInt()}',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _budgetRange,
                      min: 0,
                      max: 200,
                      divisions: 20,
                      labels: RangeLabels(
                        '\$${_budgetRange.start.toInt()}',
                        '\$${_budgetRange.end.toInt()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _budgetRange = values;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              // Preferences Section
              _buildSectionHeader('Preferences'),
              _buildSwitchField(
                label: 'Subscribe to Newsletter',
                subtitle: 'Receive updates and promotions',
                value: _subscribeToNewsletter,
                onChanged: (value) {
                  setState(() {
                    _subscribeToNewsletter = value;
                  });
                },
              ),
              _buildCheckboxField(
                label: 'I agree to the Terms and Conditions',
                subtitle: 'You must agree to proceed',
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
              ),
              
              // Chips Section
              _buildSectionHeader('Interests (Select multiple)'),
              Wrap(
                spacing: 8.0,
                children: _interestChips.map((chip) {
                  final isSelected = _selectedChips.contains(chip);
                  return FilterChip(
                    label: Text(chip),
                    selected: isSelected,
                    onSelected: (_) => _toggleChip(chip),
                    selectedColor: Colors.blue[100],
                    checkmarkColor: Colors.blue,
                  );
                }).toList(),
              ),
              
              // Multi-line Text Field
              _buildSectionHeader('Additional Notes'),
              TextFormField(
                controller: _multilineController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter any additional notes here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.all(16.0),
                ),
              ),
              
              // Buttons
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Reset Form'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Form'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: AppTextStyles.sectionHeader,
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool isRequired = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.label,
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator ?? (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: 'Select date',
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat('MMM dd, yyyy').format(selectedDate)
                  : 'Select date',
              style: TextStyle(
                color: selectedDate != null ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTimeField({
    required String label,
    required TimeOfDay? selectedTime,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: 'Select time',
              prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              selectedTime != null
                  ? selectedTime.format(context)
                  : 'Select time',
              style: TextStyle(
                color: selectedTime != null ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSwitchField({
    required String label,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(label, style: AppTextStyles.label),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildCheckboxField({
    required String label,
    required String subtitle,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return CheckboxListTile(
      title: Text(label, style: AppTextStyles.label),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
