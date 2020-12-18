class Magazalar {
  Magazalar({
    this.logo,
    this.firma,
  });

  String logo;
  String firma;


  Magazalar.fromMap(Map<String, dynamic> data)
      : this(
    logo: data["logo"],
    firma: data["firma"],
  );

  Map<String, dynamic> toMap() => {
    "logo": logo,
    "firma": firma,
  };
}