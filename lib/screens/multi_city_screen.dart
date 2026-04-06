import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trip_management/helper/app_snackbar.dart';
import 'package:trip_management/models/segment_model.dart';
import 'package:trip_management/providers/trip_provider.dart';
import 'package:trip_management/screens/summary_screen.dart';
import 'package:trip_management/widgets/custom_button.dart';
import 'package:trip_management/widgets/custom_textfield.dart';

class MultiCityScreen extends StatefulWidget {
  const MultiCityScreen({super.key});

  @override
  State<MultiCityScreen> createState() => _MultiCityScreenState();
}

class _MultiCityScreenState extends State<MultiCityScreen> {
  // We will maintain separate lists of controllers and dates for each segment
  List<TextEditingController> fromControllers = [];
  List<TextEditingController> toControllers = [];
  List<DateTime?> dates = [];

  @override
  void initState() {
    super.initState();
    addNewSegment();
  }

  @override
  void dispose() {
    for (var c in fromControllers) {
      c.dispose();
    }
    for (var c in toControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // Add new segment by adding new controllers and date entry
  void addNewSegment() {
    setState(() {
      fromControllers.add(TextEditingController());
      toControllers.add(TextEditingController());
      dates.add(null);
    });
  }

  // Remove segment by index
  void removeSegment(int index) {
    setState(() {
      fromControllers.removeAt(index);
      toControllers.removeAt(index);
      dates.removeAt(index);
    });
  }

  // Date picker for specific segment
  Future<void> _pickDate(int index) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dates[index] ?? now,
      firstDate: now,
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => dates[index] = picked);
  }

  // On continue, validate all segments and add to provider
  void _onContinue(TripProvider provider) {
    if (fromControllers.length < 2) {
      AppSnackbar.error(context, 'Please add at least 2 segments');
      return;
    }

    for (int i = 0; i < fromControllers.length; i++) {
      if (fromControllers[i].text.isEmpty ||
          toControllers[i].text.isEmpty ||
          dates[i] == null) {
        AppSnackbar.error(
          context,
          'Please fill all fields in Segment ${i + 1}',
        );
        return;
      }
      if (fromControllers[i].text.toLowerCase() ==
          toControllers[i].text.toLowerCase()) {
        AppSnackbar.error(
          context,
          'Origin and destination cannot be the same in Segment ${i + 1}',
        );
        return;
      }
    }

    provider.clearSegments();
    for (int i = 0; i < fromControllers.length; i++) {
      provider.addSegment(
        Segment(
          from: fromControllers[i].text,
          to: toControllers[i].text,
          date: dates[i]!,
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripSummaryScreen()),
    );
    // Show success message
    AppSnackbar.success(context, 'Segments added successfully');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TripProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Multi-City Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: fromControllers.length,
                itemBuilder: (context, index) => _SegmentCard(
                  index: index,
                  fromController: fromControllers[index],
                  toController: toControllers[index],
                  date: dates[index],
                  showDelete: fromControllers.length > 1,
                  onDelete: () => removeSegment(index),
                  onPickDate: () => _pickDate(index),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Add Segment — dashed outline
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: addNewSegment,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        'Add Segment',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF93C5FD),
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Continue
                  CustomButton(
                    text: 'Continue →',
                    onPressed: () => _onContinue(provider),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for each segment card
class _SegmentCard extends StatelessWidget {
  final int index;
  final TextEditingController fromController;
  final TextEditingController toController;
  final DateTime? date;
  final bool showDelete;
  final VoidCallback onDelete;
  final VoidCallback onPickDate;

  const _SegmentCard({
    required this.index,
    required this.fromController,
    required this.toController,
    required this.date,
    required this.showDelete,
    required this.onDelete,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Segment ${index + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
              if (showDelete)
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // From
          CustomTextfield(
            controller: fromController,
            labelText: 'From',
            hintText: 'Enter departure',
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),

          // Route connector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.grey.shade300, height: 1),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
                Expanded(
                  child: Divider(color: Colors.grey.shade300, height: 1),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // To
          CustomTextfield(
            controller: toController,
            labelText: 'To',
            hintText: 'Enter destination',
            prefixIcon: const Icon(Icons.location_city_outlined),
          ),

          const SizedBox(height: 10),

          // Date picker row
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          date != null
                              ? DateFormat('EEE, dd MMM yyyy').format(date!)
                              : 'Select date',
                          style: TextStyle(
                            fontSize: 13,
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
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
