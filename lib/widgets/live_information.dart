import 'package:classwix_orbit/Screen/GroupDetails/group_details_provider.dart';
import 'package:classwix_orbit/Screen/GroupDetails/widgets/liveclass_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveInformation extends ConsumerStatefulWidget {
  final int groupId;

  const LiveInformation({super.key, required this.groupId});

  @override
  _LiveInformationState createState() => _LiveInformationState();
}

class _LiveInformationState extends ConsumerState<LiveInformation> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final groupState = ref.read(groupDetailsProvider(widget.groupId));
      if (groupState.liveClassLink != null) {
        linkController.text = groupState.liveClassLink!;
      }
    });
  }

  void _showLiveClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LiveClassDialog(
          linkController: linkController,
          timeController: timeController,
          groupId: widget.groupId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => _showLiveClassDialog(context),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.ondemand_video_rounded, color: Colors.white),
              SizedBox(width: 5),
              Text('Live Class'),
            ],
          ),
        ),
      ],
    );
  }
}
