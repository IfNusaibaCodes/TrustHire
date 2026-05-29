class TaskModel {
  final String id;
  final String title;
  final String priority;
  bool isDone;
  final String date;

  TaskModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.isDone,
    required this.date,
  });


  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    id:       map['id'],
    title:    map['title'],
    priority: map['priority'] ?? 'Normal',
    isDone:   map['is_done'] ?? false,
    date:     map['date'] ?? '',
  );


  Map<String, dynamic> toMap() => {
    'id':       id,
    'title':    title,
    'priority': priority,
    'is_done':  isDone,
    'date':     date,
  };
}