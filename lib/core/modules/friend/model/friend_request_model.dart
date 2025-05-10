class FriendRequest {
  final String docId;
  final String senderId;
  final String receiverId;
  final DateTime timeStamp;
  final String status; // 'pending', 'confirmed', 'rejected'
  final String senderName;
  final String senderPhotoUrl;

   FriendRequest({
    required this.docId,
    required this.senderId,
    required this.receiverId,
    required this.timeStamp,
    required this.status,
    required this.senderName,
    required this.senderPhotoUrl,
  });

  factory FriendRequest.fromMap(Map<String, dynamic> map, String docId) {
    return FriendRequest(
      docId: docId,
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      timeStamp: DateTime.parse(map['time_stamp']),
      status: map['status'],
      senderName: map['sender']['name'],
      senderPhotoUrl: map['sender']['image'],
    );
  }

}
