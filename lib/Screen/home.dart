import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Schedule Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Schedule",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text("View All"))
              ],
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://img.freepik.com/free-vector/learning-concept-illustration_114360-6186.jpg?t=st=1738654308~exp=1738657908~hmac=c6e3953f41fb19f1901723da48415e5ec52c9aeb3ad6308d89f29ddcdc1c48e5&w=740",
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
                title: const Text(
                  "Mathematics",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Dr. Sarah Johnson"),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue,
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Join Class"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Quick Access Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAccessIcon(Icons.assignment, "Assignments"),
                _buildQuickAccessIcon(Icons.book, "Materials"),
                _buildQuickAccessIcon(Icons.chat, "Discussion"),
                _buildQuickAccessIcon(Icons.calendar_today, "Calendar"),
              ],
            ),
            const SizedBox(height: 20),
            // My Class Groups Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Class Groups",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text("See All"))
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemCount: classGroups.length,
              itemBuilder: (context, index) {
                return _buildClassGroupCard(classGroups[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildClassGroupCard(Map<String, dynamic> group) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              group['image'],
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group['title'],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text("${group['students']} students",
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text("Active ${group['active']} ago",
                    style: const TextStyle(fontSize: 12, color: Colors.blue)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> classGroups = [
  {
    'title': "Advanced Mathematics",
    'students': 28,
    'active': "2h",
    'image': "https://img.freepik.com/free-vector/learning-concept-landing-page_23-2147777959.jpg?t=st=1738654556~exp=1738658156~hmac=db454cee44e4c302276558be6a7bada15168566fd34d0e0a5cd8daaddcd0aa3c&w=740",
  },
  {
    'title': "Physics Lab Group",
    'students': 24,
    'active': "1h",
    'image': "https://img.freepik.com/free-vector/student-graduation-cap-using-computer-desk_1262-21421.jpg?t=st=1738654581~exp=1738658181~hmac=4337df038d5ea343707e2030fea2d62252f7952d374c4bbaabb6683e5b2fb9cf&w=740",
  },
  {
    'title': "Programming Team",
    'students': 32,
    'active': "30m",
    'image': "https://img.freepik.com/free-vector/student-graduation-cap-using-computer-desk_1262-21421.jpg?t=st=1738654581~exp=1738658181~hmac=4337df038d5ea343707e2030fea2d62252f7952d374c4bbaabb6683e5b2fb9cf&w=740",
  },
  {
    'title': "Study Group A",
    'students': 18,
    'active': "5h",
    'image': "https://img.freepik.com/free-vector/student-graduation-cap-using-computer-desk_1262-21421.jpg?t=st=1738654581~exp=1738658181~hmac=4337df038d5ea343707e2030fea2d62252f7952d374c4bbaabb6683e5b2fb9cf&w=740",
  },
  {
    'title': "Research Project",
    'students': 15,
    'active': "1d",
    'image': "https://img.freepik.com/free-vector/student-graduation-cap-using-computer-desk_1262-21421.jpg?t=st=1738654581~exp=1738658181~hmac=4337df038d5ea343707e2030fea2d62252f7952d374c4bbaabb6683e5b2fb9cf&w=740",
  },
  {
    'title': "Discussion Club",
    'students': 45,
    'active': "3h",
    'image': "https://img.freepik.com/free-vector/student-graduation-cap-using-computer-desk_1262-21421.jpg?t=st=1738654581~exp=1738658181~hmac=4337df038d5ea343707e2030fea2d62252f7952d374c4bbaabb6683e5b2fb9cf&w=740",
  },
];
