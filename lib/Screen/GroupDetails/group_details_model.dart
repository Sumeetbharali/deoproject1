class GroupDetailsState {
  final bool isLoading;
  final bool hasError;
  final Map<String, dynamic>? groupDetails;
  final List<dynamic> videoList;
  final List<dynamic> materialsList;
  final String? liveClassLink; 

  GroupDetailsState({
    required this.isLoading,
    required this.hasError,
    this.groupDetails,
    this.videoList = const [],
    this.materialsList = const [],
    this.liveClassLink,
  });

  factory GroupDetailsState.loading() =>GroupDetailsState(isLoading: true, hasError: false);
  factory GroupDetailsState.error() =>
      GroupDetailsState(isLoading: false, hasError: true);
  factory GroupDetailsState.loaded(
    Map<String, dynamic> groupDetails,
    List<dynamic> videoList,
    List<dynamic> materialsList,
    String? liveClassLink,
  ) =>
      GroupDetailsState(
        isLoading: false,
        hasError: false,
        groupDetails: groupDetails,
        videoList: videoList,
        materialsList: materialsList,
        liveClassLink: liveClassLink,
      );

  GroupDetailsState copyWith({
    bool? isLoading,
    bool? hasError,
    Map<String, dynamic>? groupDetails,
    List<dynamic>? videoList,
    List<dynamic>? materialsList,
    String? liveClassLink,
  }) {
    return GroupDetailsState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      groupDetails: groupDetails ?? this.groupDetails,
      videoList: videoList ?? this.videoList,
      materialsList: materialsList ?? this.materialsList,
      liveClassLink: liveClassLink ?? this.liveClassLink,
    );
  }
}
