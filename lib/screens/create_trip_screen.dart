import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_management/helper/app_snackbar.dart';
import 'package:trip_management/providers/trip_provider.dart';
import 'package:trip_management/screens/history.dart';
import 'package:trip_management/screens/multi_city_screen.dart';
import 'package:trip_management/screens/one_way_screen.dart';
import 'package:trip_management/screens/round_trip_screen.dart';
import 'package:trip_management/widgets/custom_button.dart';
import 'package:trip_management/widgets/custom_textfield.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _tripNameController = TextEditingController();

  @override
  void dispose() {
    _tripNameController.dispose();
    super.dispose();
  }

  void resetForm() => _tripNameController.clear();

  void _onContinue(TripProvider provider) {
    // Validation
    if (_tripNameController.text.isEmpty) {
      AppSnackbar.error(context, 'Please enter a trip name');
      return;
    }
    provider.setTripName(_tripNameController.text);
    resetForm();

    Widget? screen;
    if (provider.tripType == 'oneWay') {
      screen = OneWayScreen();
    } else if (provider.tripType == 'roundTrip') {
      screen = RoundTripScreen();
    } else if (provider.tripType == 'multiCity') {
      screen = MultiCityScreen();
    }

    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TripProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // subtle grey bg
      appBar: AppBar(
        title: Text(
          'Create Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width < 600 ? 16.0 : 20.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      // Trip Banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width < 600 ? 20 : 24,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width < 600
                                  ? 52
                                  : 60,
                              height: MediaQuery.of(context).size.width < 600
                                  ? 52
                                  : 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.luggage_outlined,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width < 600
                                    ? 26
                                    : 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Plan Your Trip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Fill in the details to get started',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      CustomTextfield(
                        controller: _tripNameController,
                        labelText: 'Trip Name',
                        hintText: 'Enter your trip name',
                        prefixIcon: const Icon(Icons.edit_outlined),
                      ),

                      const SizedBox(height: 16),

                      // Trip Type Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width < 600 ? 18 : 22,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip Type',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width < 600
                                    ? 15
                                    : 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Select your preferred travel option',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width < 600
                                    ? 12
                                    : 13,
                                color: Colors.grey,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Divider(
                                height: 1,
                                color: Color(0xFFF3F4F6),
                              ),
                            ),
                            _buildTripOption(
                              title: 'One Way',
                              value: 'oneWay',
                              provider: provider,
                              icon: Icons.arrow_forward_rounded,
                            ),
                            const SizedBox(height: 9),
                            _buildTripOption(
                              title: 'Round Trip',
                              value: 'roundTrip',
                              provider: provider,
                              icon: Icons.sync_alt_rounded,
                            ),
                            const SizedBox(height: 9),
                            _buildTripOption(
                              title: 'Multi-City',
                              value: 'multiCity',
                              provider: provider,
                              icon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // History + Continue Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TripHistoryScreen(),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'History',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Continue →',
                      onPressed: () => _onContinue(provider),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripOption({
    required String title,
    required String value,
    required dynamic provider,
    required IconData icon,
  }) {
    final bool isSelected = provider.tripType == value;

    return GestureDetector(
      onTap: () => provider.setTripType(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withOpacity(0.10)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.blue : Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : const Color(0xFF374151),
                ),
              ),
            ),
            // Custom radio dot
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
