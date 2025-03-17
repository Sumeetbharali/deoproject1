import 'package:classwix_orbit/Screen/MyGroup/group_controller.dart';
import 'package:classwix_orbit/Screen/GroupDetails/widgets/error_widget.dart';
import 'package:classwix_orbit/Screen/MyGroup/widget/group_item.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  final int? groupid;
  const GroupsScreen({this.groupid,super.key});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Alignment>(
      begin: const Alignment(-1.0, 0.0), // Start from left
      end: const Alignment(1.0, 0.0), // Move to right
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupControllerProvider);
    final controller = ref.read(groupControllerProvider.notifier);

    final filteredGroups = widget.groupid != null
        ? groups.where((group) => group.id == widget.groupid).toList()
        : groups; 

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Class Groups",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchGroups,
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.hasError
                ? ErrorWidgetCustom(onRetry: controller.fetchGroups)
                : filteredGroups.isEmpty
                    ? const Center(
                        child: Text(
                          "No Groups Found!",
                          style: TextStyle(fontSize: 16, color: AppColors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, index) {
                          return GroupItem(
                            group: filteredGroups[index],
                            controller: _controller,
                            animation: _animation,
                          );
                        },
                      ),
      ),
    );
  }
}
