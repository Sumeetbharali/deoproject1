import 'dart:convert';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimetableScreen extends ConsumerStatefulWidget {
  const TimetableScreen({super.key});

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends ConsumerState<TimetableScreen> {
  List<ScheduleEvent> events = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchTimetable();
  }

  // 📌 Fetch Timetable from API
  Future<void> fetchTimetable() async {
    // final authToken = ref.watch(sampleProvider);
    // logger.f("get $authToken");
    // print(authToken);
    final response = await http.get(
      Uri.parse("https://api.classwix.com/api/micro/routines"),
      headers: {
        "Authorization":
            "Bearer 609|1jlY8sIX0WDq51JJLLEV8mSUGETnMMgJx2CXK6AC75d77f5a",
            // "Bearer $authToken"
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> routines = data["routines"];
      List<ScheduleEvent> loadedEvents = [];

      for (var routine in routines) {
        var group = routine["group"];
        Map<String, dynamic> days = {
          "sun": routine["sun"],
          "mon": routine["mon"],
          "tue": routine["tue"],
          "wed": routine["wed"],
          "thu": routine["thu"],
          "fri": routine["fri"],
          "sat": routine["sat"],
        };

        days.forEach((day, time) {
          if (time != null) {
            DateTime eventTime = DateTime.parse("2025-02-15 $time");
            loadedEvents.add(
              ScheduleEvent(
                group["name"],
                eventTime,
                const Duration(hours: 1),
                Colors
                    .primaries[
                        loadedEvents.length * 2 % Colors.primaries.length]
                    .shade100,
                day,
              ),
            );
          }
        });
      }

      setState(() {
        events = loadedEvents;
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEvent());
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 📌 Scroll to First Event of the Day
  void _scrollToEvent() {
    if (events.isEmpty) return;

    DateTime now = DateTime.now();
    String today = getDayKey(now.weekday);
    List<ScheduleEvent> todaysEvents =
        events.where((event) => event.dayKey == today).toList();

    if (todaysEvents.isNotEmpty) {
      int eventHour = todaysEvents.first.startTime.hour;
      int scrollIndex = eventHour - 8; // Since time slots start from 08:00 AM

      if (scrollIndex >= 0) {
        _scrollController.animateTo(
          scrollIndex * 60.0, // Each time slot is 60px in height
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildWeekDays(),
                Expanded(child: _buildTimeTable()),
              ],
            ),
    );
  }

  String _getWeekdayName(int weekday) {
    const List<String> weekdays = [
      "Sun",
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat"
    ];
    return weekdays[weekday % 7];
  }

  Widget _buildWeekDays() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<DateTime> weekDays =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: weekDays.map((day) {
          bool isSelected = day.day == now.day;
          return Column(
            children: [
              Text(
                _getWeekdayName(day.weekday),
                style: TextStyle(color: isSelected ? Colors.blue : Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue : AppColors.black,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeTable() {
    DateTime now = DateTime.now();
    String today = getDayKey(now.weekday);

    List<ScheduleEvent> todaysEvents =
        events.where((event) => event.dayKey == today).toList();

    if (todaysEvents.isEmpty) {
      return const Center(
        child: Text("No classes scheduled for today.",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.builder(
      controller: _scrollController, // Attach ScrollController
      itemCount: 13, // 08:00 to 20:00
      itemBuilder: (context, index) {
        final hour = index + 8;
        return _buildTimeSlot(hour, todaysEvents);
      },
    );
  }

  String getDayKey(int weekday) {
    Map<int, String> dayMap = {
      1: "mon",
      2: "tue",
      3: "wed",
      4: "thu",
      5: "fri",
      6: "sat",
      7: "sun",
    };
    return dayMap[weekday]!;
  }

  Widget _buildTimeSlot(int hour, List<ScheduleEvent> todaysEvents) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
          Expanded(
            child: Stack(
              children: todaysEvents
                  .where((event) => event.startTime.hour == hour)
                  .map((event) => _buildEventCard(event))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(ScheduleEvent event) {
    return Positioned(
      left: 10,
      width: 100,
      height: 100,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: event.color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.group,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleEvent {
  final String group;
  final DateTime startTime;
  final Duration duration;
  final Color color;
  final String dayKey;

  ScheduleEvent(
      this.group, this.startTime, this.duration, this.color, this.dayKey);
}
