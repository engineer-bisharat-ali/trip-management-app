import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trip_management/helper/app_snackbar.dart';
import 'package:trip_management/models/segment_model.dart';
import 'package:trip_management/providers/trip_provider.dart';
import 'package:trip_management/screens/summary_screen.dart';
import 'package:trip_management/widgets/custom_textfield.dart';

class OneWayScreen extends StatefulWidget {
  const OneWayScreen({super.key});

  @override
  State<OneWayScreen> createState() => _OneWayScreenState();
}

class _OneWayScreenState extends State<OneWayScreen> {
  // Controllers for text fields
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  // Date picker function
  Future<void> _pickDate(TripProvider provider) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      provider.setDepartureDate(picked);
    }
  }

  // Continue button handler
  void _onContinue(TripProvider provider) {
    if (fromController.text.isEmpty ||
        toController.text.isEmpty ||
        selectedDate == null) {
      AppSnackbar.error(context, 'Please fill all fields');
      return;
    }

    if (fromController.text.toLowerCase() == toController.text.toLowerCase()) {
      AppSnackbar.error(context, 'Origin and destination cannot be the same');
      return;
    }

    // Add segment to provider
    provider.addSegment(
      Segment(
        from: fromController.text,
        to: toController.text,
        date: selectedDate!,
      ),
    );

    // Navigate to summary screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripSummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access provider
    final provider = Provider.of<TripProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'One Way Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width < 600 ? 16 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              // From field
              const Text('From', style: _labelStyle),
              const SizedBox(height: 6),
              CustomTextfield(
                controller: fromController,
                labelText: 'Departure',
                hintText: 'Enter departure location',
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),

              // Route connector
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const _RouteDot(),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, height: 1),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, height: 1),
                    ),
                    const _RouteDot(),
                  ],
                ),
              ),

              // To field
              const Text('To', style: _labelStyle),
              const SizedBox(height: 6),
              CustomTextfield(
                controller: toController,
                labelText: 'Destination',
                hintText: 'Enter destination location',
                prefixIcon: const Icon(Icons.location_city_outlined),
              ),

              const SizedBox(height: 16),

              // Date picker
              const Text('Date', style: _labelStyle),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _pickDate(provider),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Departure Date',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              selectedDate != null
                                  ? DateFormat(
                                      'EEE, dd MMM yyyy',
                                    ).format(selectedDate!)
                                  : 'Select date',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: selectedDate != null
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: selectedDate != null
                                    ? Colors.black87
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onContinue(provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continue →',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _labelStyle = TextStyle(
  fontSize: 12,
  color: Color(0xFF6B7280),
  fontWeight: FontWeight.w500,
);

class _RouteDot extends StatelessWidget {
  const _RouteDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    );
  }
}
