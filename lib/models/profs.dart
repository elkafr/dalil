class Profs {
  Profs({
    this.profsId,
    this.profsmetaProfsId,
    this.profsName,
    this.profsPhone,
    this.profsAbout,
    this.catName,
    this.cityName,
    this.moreId,
    this.moreTitle,
    this.moreContent,
    this.photo,
    this.profsThumbId,
  });
  String profsId;
  String profsmetaProfsId;
  String profsName;
  String profsPhone;
  String profsAbout;
  String catName;
  String cityName;
  String moreId;
  String moreTitle;
  String moreContent;
  String photo;
  String profsThumbId;

  factory Profs.fromJson(Map<String, dynamic> json) => Profs(
    profsId: json["profs_id"],
    profsmetaProfsId: json["profsmeta_profs_id"],
    profsName: json["profs_name"],
    profsPhone: json["profs_phone"],
    profsAbout: json["profs_about"],
    catName: json["cat_name"],
    cityName: json["city_name"],
    moreId: json["more_id"],
    moreTitle: json["more_title"],
    moreContent: json["more_content"],
    photo: json["photo"],
    profsThumbId: json["profs_thumb_id"],
  );

  Map<String, dynamic> toJson() => {
    "profs_id": profsId,
    "profsmeta_profs_id": profsmetaProfsId,
    "profs_name": profsName,
    "profs_phone": profsPhone,
    "profs_about": profsAbout,
    "cat_name": catName,
    "city_name": cityName,
    "more_id": moreId,
    "more_title": moreTitle,
    "more_content": moreContent,
    "photo": photo,
    "profs_thumb_id": profsThumbId,
  };
}
