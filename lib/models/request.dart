class Request {
  Request({
    this.id,
    this.name,
    this.phone,
    this.title,
    this.content,
  });
  String id;
  String name;
  String phone;
  String title;
  String content;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    title: json["title"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "title": title,
    "content": content,
  };
}
