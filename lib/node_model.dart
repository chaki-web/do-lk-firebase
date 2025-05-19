class Note {
  String title;
  String desc;

  Note({required this.title, required this.desc});

  static Map<String, dynamic> toMap(Note note) {
    return {"title": note.title, "desc": note.desc};
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(title: map["title"] ?? "", desc: map["desc"] ?? "");
  }
}
