import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vidyakosh/page/homeGradient.dart';
import '../page/appBarGradient.dart';

class TrainingCalendarPage extends StatefulWidget {
  const TrainingCalendarPage({super.key});

  @override
  State<TrainingCalendarPage> createState() => _TrainingCalendarPageState();
}

class _TrainingCalendarPageState extends State<TrainingCalendarPage> {
  List<dynamic> trainings = [];
  bool isLoading = true;

  String selectedYear = "2025-2026";
  String selectedMonth = "All";
  String selectedTab = "All";

  @override
  void initState() {
    super.initState();
    loadMockData();
    debugPrint('Calender Page initState called');
  }

  Future<void> loadMockData() async {
    try {
      final jsonString =
      await rootBundle.loadString('mock_data/training_calender.json');
      final json = jsonDecode(jsonString);
      debugPrint('json loaded');

      setState(() {
        trainings = json['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
      setState(() {
        trainings = [];
        isLoading = false;
      });
    }
  }

  /// 🔹 open flyer PDF
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("QR Code"),
        content: QrImageView(
          data: qrMessage,
          version: QrVersions.auto,
          size: 200.0,
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

  /// 🔹 Filter logic (derives year/month/status from duration)
  List<dynamic> get filteredTrainings {
    final now = DateTime.now();

    return trainings.where((training) {
      // derive start/end from "duration"
      final duration = training['duration']?.toString() ?? "";
      final parts = duration.split("to");
      DateTime? start, end;
      if (parts.isNotEmpty) start = _parseDate(parts.first.trim());
      if (parts.length > 1) end = _parseDate(parts.last.trim());

      final courseStartYear = start?.year ?? 0;
      final courseEndYear = end?.year ?? courseStartYear;
      final trainingYear = "$courseStartYear-$courseEndYear";
      // Year string
      // final trainingYear = (end != null && start != null && end.year > start.year)
      //     ? "${start.year}-${end.year}"
      //     : "${start?.year ?? ""}";

      // Month abbreviation
      final trainingMonth = start != null ? _monthAbbr(start.month) : "All";

      // Status
      final status = (end != null && end.isBefore(now))
          ? "Completed"
          : "Upcoming";


      // if (selectedYear.isNotEmpty && !trainingYear.contains(selectedYear)) {
      //   return false;
      // }
      // Filters:
      if (selectedYear != "All") {
        final filterParts = selectedYear.split("-");
        final filterStart = int.parse(filterParts[0]);
        final filterEnd = int.parse(filterParts[1]);

        // check if course range overlaps filter range
        final overlaps = courseStartYear <= filterEnd && courseEndYear >= filterStart;
        if (!overlaps) return false;
      }

      if (selectedMonth != "All" && selectedMonth != trainingMonth) {
        return false;
      }
      if (selectedTab != "All" && selectedTab != status) {
        return false;
      }
      return true;
    }).toList();
  }

  DateTime? _parseDate(String d) {
    try {
      final parts = d.split("-");
      // expected dd-MM-yyyy
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  String _monthAbbr(int m) {
    const months = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[m];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar("Training Calender"),
      body: homeGradient(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Filters
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedYear,
                      items: ["2025-2026", "2024-2025"].map((e) {
                        return DropdownMenuItem(
                            value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => selectedYear = val!),
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
                      items: ["All","Jan","Feb","Mar","Apr","May","Jun",
                        "Jul","Aug","Sep","Oct","Nov","Dec"]
                          .map((e) {
                        return DropdownMenuItem(
                            value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => selectedMonth = val!),
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

              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChoiceChip("All"),
                  _buildChoiceChip("Upcoming"),
                  _buildChoiceChip("Completed"),
                ],
              ),
              const SizedBox(height: 10),

              // List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTrainings.length,
                  itemBuilder: (context, index) {
                    final training = filteredTrainings[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
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
                              (training['title'] ?? '—').toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),

                            _buildInfoRow(
                                Icons.location_on,
                                (training['venues'] ?? '—').toString()),
                            _buildInfoRow(Icons.schedule,
                                "Duration: ${(training['duration'] ?? '—')}"),
                            _buildInfoRow(Icons.location_city,
                                "City: ${(training['cityname'] ?? '—')}"),
                            _buildInfoRow(Icons.event_available,
                                "Last Nomination Date: ${(training['lastnominne'] ?? '—')}"),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Text("Flyer:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                _buildFlyer(training['flyer']),
                              ],
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Text("QR Code:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                _buildQr(training['action']),
                              ],
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Chip(
                                label: Text(
                                    (training['DT_RowIndex'] ?? '—')
                                        .toString()),
                                backgroundColor: Colors.red.shade100,
                                labelStyle:
                                const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedTab == label,
      onSelected: (_) => setState(() => selectedTab = label),
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
