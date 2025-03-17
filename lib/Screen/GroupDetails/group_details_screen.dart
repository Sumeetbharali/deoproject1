import 'package:classwix_orbit/Screen/GroupDetails/group_details_provider.dart';
import 'package:classwix_orbit/Screen/GroupDetails/widgets/error_widget.dart';
import 'package:classwix_orbit/Screen/GroupDetails/widgets/startclass_widget.dart';
import 'package:classwix_orbit/Screen/GroupDetails/widgets/material_widget.dart';
import 'package:classwix_orbit/Screen/GroupDetails/widgets/videolist_widget.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/widgets/group_information.dart';
import 'package:classwix_orbit/widgets/live_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupDetailsScreen extends ConsumerWidget {
  final int groupId;
  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupDetailsProvider(groupId));
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.purple),
        ),
        title: const Text(
          "Group Details",
          style: TextStyle(
            color: AppColors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(groupDetailsProvider(groupId).notifier).fetchData();
          ref.read(groupDetailsProvider(groupId).notifier).fetchLiveClassLink();
        },
        child: groupState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : groupState.hasError
                ? GroupError(
                    fetchData: () => ref
                        .read(groupDetailsProvider(groupId).notifier)
                        .fetchData(),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      GroupClasscode(groupId: groupId),
                      const SizedBox(height: 15),
                      if (groupState.groupDetails != null)
                        GroupInformation(
                            groupDetails: groupState.groupDetails!),
                      const SizedBox(height: 20),
                      LiveInformation(groupId: groupId),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        height: 460,
                        child: _buildTabView(groupState.groupDetails,
                            groupState.videoList, groupState.materialsList),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildTabView(dynamic groupDetails, List<dynamic> videoList,
      List<dynamic> materialsList) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.grad_blue,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.grad_blue,
            tabs: const [
              Tab(text: "Recorded"),
              Tab(text: "Materials"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                VideolistWidget(videoList: videoList),
                MaterialWidget(
                    groupDetails: groupDetails, materialList: materialsList),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
