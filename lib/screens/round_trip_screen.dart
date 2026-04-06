import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trip_management/helper/app_snackbar.dart';
import 'package:trip_management/models/segment_model.dart';
import 'package:trip_management/providers/trip_provider.dart';
import 'package:trip_management/screens/summary_screen.dart';
import 'package:trip_management/widgets/custom_button.dart';
import 'package:trip_management/widgets/custom_textfield.dart';

class RoundTripScreen extends StatefulWidget {
  const RoundTripScreen({super.key});

  @override
  State<RoundTripScreen> createState() => _RoundTripScreenState();
}

class _RoundTripScreenState extends State<RoundTripScreen> {
  // Controllers for text fields
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  DateTime? departureDate;
  DateTime? returnDate;

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  // Date picker function with reusable parameters
  Future<void> _pickDate({
    required DateTime? current,
    required void Function(DateTime) onPicked,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: now,
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  // Continue button handler
  void _onContinue(TripProvider provider) {
    if (fromController.text.isEmpty ||
        toController.text.isEmpty ||
        departureDate == null ||
        returnDate == null) {
      AppSnackbar.error(context, 'Please fill all fields');
      return;
    }

    if (fromController.text.toLowerCase() == toController.text.toLowerCase()) {
      AppSnackbar.error(context, 'Origin and destination cannot be the same');
      return;
    }

    if (returnDate!.isBefore(departureDate!)) {
      AppSnackbar.error(context, 'Return date cannot be before departure date');
      return;
    }

    // Save segments to provider
    provider.clearSegments();
    provider.addSegment(
      Segment(
        from: fromController.text,
        to: toController.text,
        date: departureDate!,
      ),
    );
    provider.addSegment(
      Segment(
        from: toController.text,
        to: fromController.text,
        date: returnDate!,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripSummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TripProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Round Trip',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width < 600 ? 16 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // From
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
                            child: Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                            ),
                          ),
                          Icon(
                            Icons.sync_alt_rounded,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                            ),
                          ),
                          const _RouteDot(),
                        ],
                      ),
                    ),

                    // To
                    const Text('To', style: _labelStyle),
                    const SizedBox(height: 6),
                    CustomTextfield(
                      controller: toController,
                      labelText: 'Destination',
                      hintText: 'Enter destination location',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                    ),

                    const SizedBox(height: 16),

                    // Dates
                    const Text('Dates', style: _labelStyle),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _DateRow(
                            label: 'Departure Date',
                            date: departureDate,
                            iconColor: Colors.blue,
                            onTap: () => _pickDate(
                              current: departureDate,
                              onPicked: (d) {
                                setState(() => departureDate = d);
                                provider.setDepartureDate(d);
                              },
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey.shade100,
                            indent: 14,
                            endIndent: 14,
                          ),
                          _DateRow(
                            label: 'Return Date',
                            date: returnDate,
                            iconColor: const Color(
                              0xFF10B981,
                            ), // green for return
                            onTap: () => _pickDate(
                              current: returnDate,
                              onPicked: (d) {
                                setState(() => returnDate = d);
                                provider.setReturnDate(d);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: CustomButton(
                text: 'Continue →',
                onPressed: () => _onContinue(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable date row widget
class _DateRow extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Color iconColor;
  final VoidCallback onTap;

  const _DateRow({
    required this.label,
    required this.date,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                color: iconColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date != null
                        ? DateFormat('EEE, dd MMM yyyy').format(date!)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: date != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: date != null
                          ? Colors.black87
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}

// Common label style
const _labelStyle = TextStyle(
  fontSize: 12,
  color: Color(0xFF6B7280),
  fontWeight: FontWeight.w500,
);

class _RouteDot extends StatelessWidget {
  const _RouteDot();
  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
  );
}
