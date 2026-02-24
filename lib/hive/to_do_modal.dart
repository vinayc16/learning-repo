class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted=false});

  Map<String,dynamic> toMap(){
    return{
      'title':title,
      'isCompleted':isCompleted,
    };
  }

  factory Todo.fromMap(Map<String,dynamic> map){
    return Todo(
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }
}