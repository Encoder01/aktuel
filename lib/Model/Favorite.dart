class favoriler {
  String marka;
  List<String> Firma;
  favoriler({this.marka,this.Firma});
  favoriler.fromMapDB(Map<String, dynamic>map)
      :this(
      marka:map['marka'],
  );
  Map<String, dynamic> toMap() {
    return {

      'marka': marka,
    };
  }
}