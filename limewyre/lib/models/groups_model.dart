class GroupListModel {
  final String status;
  final GroupListData data;

  GroupListModel({required this.status, required this.data});

  factory GroupListModel.fromJson(Map<String, dynamic> json) {
    return GroupListModel(
      status: json['status'] ?? '',
      data: GroupListData.fromJson(json['data'] ?? {}),
    );
  }
}

class GroupListData {
  final List<GroupModel> items;

  GroupListData({required this.items});

  factory GroupListData.fromJson(Map<String, dynamic> json) {
    return GroupListData(
      items: (json['Items'] as List<dynamic>? ?? [])
          .map((e) => GroupModel.fromJson(e))
          .toList(),
    );
  }
}

class GroupModel {
  final String groupId;
  final String groupName;
  final String internalGroupName;
  final String groupStatus;
  final String groupSource;
  final String groupOwnerEmailId;
  final String? groupOwnerName;
  final String groupCreatedByUserId;
  final int groupCreatedOn;
  final int totalMembers;
  final int totalNotesCount;
  final String sortOrder;

  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.internalGroupName,
    required this.groupStatus,
    required this.groupSource,
    required this.groupOwnerEmailId,
    this.groupOwnerName,
    required this.groupCreatedByUserId,
    required this.groupCreatedOn,
    required this.totalMembers,
    required this.totalNotesCount,
    required this.sortOrder,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['group_id'] ?? '',
      groupName: json['group_name'] ?? '',
      internalGroupName: json['internal_group_name'] ?? '',
      groupStatus: json['group_status'] ?? '',
      groupSource: json['group_source'] ?? '',
      groupOwnerEmailId: json['group_owner_email_id'] ?? '',
      groupOwnerName: json['group_owner_name'],
      groupCreatedByUserId: json['group_created_by_user_id'] ?? '',
      groupCreatedOn: json['group_created_on'] ?? 0,
      totalMembers: json['total_members'] ?? 0,
      totalNotesCount: json['total_notes_count'] ?? 0,
      sortOrder: json['sort_order'] ?? '',
    );
  }
}
