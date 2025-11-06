import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyakosh/page/homeGradient.dart';
import '../page/appBarGradient.dart';
import '../models/training_model.dart';
import '../services/training_service.dart';
import '../utils/venue_mapper.dart';

class TrainingCalendarPage extends StatefulWidget {
  const TrainingCalendarPage({super.key});

  @override
  State<TrainingCalendarPage> createState() => _TrainingCalendarPageState();
}

class _TrainingCalendarPageState extends State<TrainingCalendarPage> {
  List<Training> trainings = [];
  bool isLoading = true;

  String selectedYear = "2025-2026";
  String selectedMonth = "All";
  String selectedVenue = "All";
  String selectedTab = "All";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final monthValue = _getMonthNumber(selectedMonth);
      final venueValue = venueCodes[selectedVenue] ?? 0;
      final tabValue = _getTabValue(selectedTab);

      // 🔹 Add debug prints here:
      debugPrint("🔍 Selected Year: $selectedYear");
      debugPrint("🔍 Selected Month: $selectedMonth ($monthValue)");
      debugPrint("🔍 Selected Venue: $selectedVenue");
      debugPrint("🔍 Venue Code: $venueValue");
      debugPrint("🔍 Tab Value: $tabValue");

      final data = await TrainingService.fetchTrainings(
        year: selectedYear,
        month: monthValue == 0 ? "" : monthValue.toString(),
        venue: venueValue,
        tabValue: tabValue,
      );

      setState(() {
        trainings = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  int _getMonthNumber(String month) {
    const months = [
      "All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months.indexOf(month);
  }

  int _getTabValue(String tab) {
    if (tab == "Upcoming") return 1;
    if (tab == "Completed") return 2;
    return 0;
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open link")),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid link")),
      );
    }
  }

  void _showQrDialog(String qrMessage) {
    if (qrMessage.isEmpty || qrMessage == "No QR Data") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid or missing QR data")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("QR Code"),
        content: SizedBox(
          width: 220,
          height: 220,
          child: QrImageView(
            data: qrMessage,
            version: QrVersions.auto,
            size: 200.0,
            errorStateBuilder: (context, err) {
              return const Center(
                child: Text(
                  "QR cannot be generated",
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar("Training Calendar"),
      body: homeGradient(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // 🔹 Filters Section (2 Rows)
              Column(
                children: [
                  // Row 1: Year + Month
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedYear,
                          items: [
                            for (int y = 2025; y >= 2016; y--)
                              DropdownMenuItem(
                                value: "$y-${y + 1}",
                                child: Text("$y-${y + 1}"),
                              )
                          ],
                          onChanged: (val) {
                            setState(() => selectedYear = val!);
                            _fetchData();
                          },
                          decoration: const InputDecoration(
                            labelText: "Select Year",
                            filled: true,
                            fillColor: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedMonth,
                          items: [
                            "All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                          ].map((e) {
                            return DropdownMenuItem(
                                value: e, child: Text(e));
                          }).toList(),
                          onChanged: (val) {
                            setState(() => selectedMonth = val!);
                            _fetchData();
                          },
                          decoration: const InputDecoration(
                            labelText: "Select Month",
                            filled: true,
                            fillColor: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Row 2: Venue
                  DropdownButtonFormField(
                    value: selectedVenue,
                    isExpanded: true,
                    items: venueCodes.keys.map((e) {
                      String shortName = e
                          .replaceAll(
                          "Indian Institute of Management", "IIM")
                          .replaceAll(
                          "Indian Institute Of Management", "IIM")
                          .replaceAll(
                          "Indian Institute of Technology", "IIT")
                          .replaceAll(
                          "Indian Institute Of Technology", "IIT")
                          .replaceAll(
                          "Greater Noida Extension Centre of IIT Roorkee", "Gr. Noida Ext. of IIT Roorkee")
                          .replaceAll(
                          "Administrative Staff College of India",
                          "ASCI");

                      return DropdownMenuItem(
                          value: e, child: Text(shortName));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => selectedVenue = val!);
                      _fetchData();
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Venue",
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 🔹 Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChoiceChip("All"),
                  _buildChoiceChip("Upcoming"),
                  _buildChoiceChip("Completed"),
                ],
              ),
              const SizedBox(height: 10),

              // 🔹 List
              Expanded(
                child: trainings.isEmpty
                    ? const Center(
                    child: Text("No trainings found",
                        style: TextStyle(color: Colors.black54)))
                    : ListView.builder(
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    final t = trainings[index];
                    return _buildTrainingCard(t);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper for each training card
  Widget _buildTrainingCard(Training t) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on,
                (t.venues.isNotEmpty ? t.venues : "—")),
            _buildInfoRow(Icons.schedule,
                "Duration: ${t.duration.isNotEmpty ? t.duration : "—"}"),
            _buildInfoRow(Icons.location_city,
                "City: ${t.cityName.isNotEmpty ? t.cityName : "—"}"),
            _buildInfoRow(
                Icons.event_available,
                "Last Nomination Date: ${t.lastNominee.isNotEmpty ? t.lastNominee : "—"}"),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Flyer:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                _buildFlyer(t.flyer),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("QR Code:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                _buildQr(t.action),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Chip(
                label: Text(t.rowIndex.toString(),
                    style: const TextStyle(color: Colors.red)),
                backgroundColor: Colors.red.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedTab == label,
      onSelected: (_) {
        setState(() => selectedTab = label);
        _fetchData();
      },
      selectedColor: Colors.red.shade200,
      backgroundColor: Colors.white70,
      labelStyle: TextStyle(
        color: selectedTab == label ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildFlyer(dynamic flyer) {
    final flyerStr = flyer?.toString().trim() ?? "";
    if (flyerStr.isEmpty || flyerStr == "<br>" || flyerStr == "<br>\n") {
      return const Text("Not Available",
          style: TextStyle(color: Colors.grey, fontSize: 12));
    }

    final match = RegExp(r'href="([^"]+)"').firstMatch(flyerStr);
    final pdfUrl = match?.group(1);

    if (pdfUrl != null && pdfUrl.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
        onPressed: () => _launchUrl(pdfUrl),
      );
    }

    return const Text("Invalid Link",
        style: TextStyle(color: Colors.grey, fontSize: 12));
  }

  Widget _buildQr(dynamic action) {
    final actionStr = action?.toString() ?? "";
    if (actionStr.contains("data-qr")) {
      final qrMessage =
          RegExp(r'data-qr="([^"]+)"').firstMatch(actionStr)?.group(1) ??
              "No QR Data";

      return IconButton(
        icon: const Icon(Icons.qr_code, size: 32, color: Colors.black54),
        onPressed: () => _showQrDialog(qrMessage),
      );
    } else if (actionStr.isNotEmpty) {
      return Html(
        data: actionStr,
        style: {
          "span": Style(fontSize: FontSize.small, fontWeight: FontWeight.bold),
          "div": Style(fontSize: FontSize.small, fontWeight: FontWeight.bold),
        },
      );
    }

    return const Text("Not Available",
        style: TextStyle(color: Colors.grey, fontSize: 12));
  }
}
