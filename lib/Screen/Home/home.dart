import 'package:classwix_orbit/Screen/Home/carousel_widget.dart';
import 'package:classwix_orbit/Screen/Home/classgroup_card.dart';
import 'package:classwix_orbit/Screen/Home/controller.dart';
import 'package:classwix_orbit/Screen/MyGroup/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> imageList = [
      "https://img.freepik.com/free-vector/student-graduation-cap-using-computer-desk_1262-21421.jpg",
      "https://img.freepik.com/free-vector/gradient-international-day-education-illustration_23-2150011975.jpg?t=st=1741625465~exp=1741629065~hmac=323912386a72346dae1360fdac29dbf75bdb62d598d2b07c3fb6f1bd2f0d7c3e&w=1380",
      "https://img.freepik.com/free-vector/online-education-illustration-concept_52683-37480.jpg",
      "https://img.freepik.com/free-vector/school-online-education-distance-learning-courses-distant-webinar-conference-tutorial-lessons-idea-student-gaining-knowledge-digital-platform_335657-1681.jpg",
      "https://img.freepik.com/free-vector/online-certification-illustration_23-2148573635.jpg",
    ];

    final groupState = ref.watch(groupControllerProvider);
    final groupController = ref.read(groupControllerProvider.notifier);
    final carouselImages = ref.watch(carouselProvider);
 
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(carouselProvider.notifier).fetchCarousels();
          await groupController.fetchGroups();
        },
        child: groupController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (groupController.hasError)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Failed to load data",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(carouselProvider.notifier)
                                  .fetchCarousels();
                              groupController.fetchGroups();
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  else if (groupState.isEmpty)
                    const Center(
                      child: Text(
                        "No groups assigned yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (carouselImages.isNotEmpty)
                          CarouselWidget(imageUrls: carouselImages),
                        Padding(
                          padding: const EdgeInsets.only(top: 55.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "My Class Groups",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text("See All"))
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: groupState.length,
                          itemBuilder: (context, index) {
                            final group = groupState[index];
                            
                            return ClassgroupCard(
                              group: {
                                "id": group.id,
                                "title": group.name,
                                "courseTitle": group.courseTitle,
                                "image": imageList[index],
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
