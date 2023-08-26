class Note {
  String? id;
  String? userid;
  String? title;
  String? content;
  DateTime? dateadded;

  Note({this.id, this.userid, this.title, this.content, this.dateadded});

  // Note from map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      userid: map["userid"],
      title: map["title"],
      content: map["content"],
      dateadded: DateTime.tryParse(map[
          "dateadded"]), //tryParse is used instead of parse because it doesn't throw an exception
    );
  }

  // Map from Note
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userid": userid,
      "title": title,
      "content": content,
      "dateadded": dateadded!.toIso8601String(),
    };
  }
}
