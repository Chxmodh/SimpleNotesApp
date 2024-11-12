class Note{
  final int? id; // allows null values for id (?)
  final String title;
  final String content;
  final String color;
  final String dateTime;

  Note({
    this.id, // not required since an id is only needed when it is saved to the DB.
    required this.title, // these are required for the note.
    required this.content,
    required this.color,
    required this.dateTime
});

  //prepare the note to store in the database
  Map<String,dynamic> toMap() {
    return{
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
    };
  }

  //retrieve from the DB and create a Note object from a Map.
  //factory constructors are used to return an instance of a class
  factory Note.fromMap(Map<String,dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      dateTime: map['dateTime']
    );
  }
}

/*
This Note class defines a model for storing note-related data.
The toMap method helps convert Note instances to a Map for easy database storage,
while the fromMap constructor lets you recreate Note instances from stored data.
 */
