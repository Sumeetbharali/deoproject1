import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  final List<ScheduleEvent> events = [
    ScheduleEvent(
      "Group A",
      "Mathematics",
      DateTime(2025, 2, 12, 9), // Monday
      Duration(hours: 2),
      Colors.red.shade100,
    ),
    ScheduleEvent(
      "Group B",
      "English",
      DateTime(2025, 2, 15, 10), // Thursday
      Duration(hours: 2),
      Colors.blue.shade100,
    ),
    ScheduleEvent(
      "Group C",
      "Chemistry",
      DateTime(2025, 2, 14, 11), // Wednesday
      Duration(hours: 2),
      Colors.green.shade100,
    ),
    ScheduleEvent(
      "Group A",
      "Biology",
      DateTime(2025, 2, 14, 13), // Wednesday
      Duration(hours: 2),
      Colors.purple.shade100,
    ),
    ScheduleEvent(
      "Group B",
      "Physics",
      DateTime(2025, 2, 12, 14), // Monday
      Duration(hours: 2),
      Colors.blue.shade100,
    ),
  ];

  TimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWeekDays(),
            Expanded(child: _buildTimeTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Timetable',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    final List<Map<String, String>> days = [
      {'day': 'Mon', 'date': '12'},
      {'day': 'Tue', 'date': '13'},
      {'day': 'Wed', 'date': '14'},
      {'day': 'Thu', 'date': '15'},
      {'day': 'Fri', 'date': '16'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: days.map((day) {
          bool isSelected = day['date'] == '14';
          return Column(
            children: [
              Text(
                day['day']!,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  day['date']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue : Colors.black,
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
    return ListView.builder(
      itemCount: 13, // 08:00 to 20:00
      itemBuilder: (context, index) {
        final hour = index + 8;
        return _buildTimeSlot(hour);
      },
    );
  }

  Widget _buildTimeSlot(int hour) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: events
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
      left: (event.startTime.weekday - 1) * 60.0,
      right: (5 - event.startTime.weekday) * 60.0,
      child: Container(
        height: event.duration.inHours * 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: event.color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              event.subtitle,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              '${event.startTime.hour.toString().padLeft(2, '0')}:00',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleEvent {
  final String title;
  final String subtitle;
  final DateTime startTime;
  final Duration duration;
  final Color color;

  ScheduleEvent(
      this.title,
      this.subtitle,
      this.startTime,
      this.duration,
      this.color,
      );
}