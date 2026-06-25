
class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String priority;
  bool   isDone;
  final String date;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.priority,
    required this.isDone,
    required this.date,
  });


  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    id:       map['id']       as String,
    userId:   map['user_id']  as String,
    title:    map['title']    as String,
    priority: map['priority'] as String? ?? 'Normal',
    isDone:   map['is_done']  as bool?   ?? false,
    date:     map['date']     as String? ?? '',
  );

 
  Map<String, dynamic> toInsertMap() => {
    'user_id':  userId,
    'title':    title,
    'priority': priority,
    'is_done':  isDone,
    'date':     date,
  };
}
