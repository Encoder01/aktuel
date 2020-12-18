
class alisveris {
  String id;
  String item;
  String color1 ;
  int check;
  alisveris({this.item,this.color1="#BFBFBF",this.check=0, this.id});
  alisveris.fromMap(Map<String, dynamic>map)
      : this(
    id:map['itemID'],
    item: map['item'],
    color1: map['color'],
    check: map['check'],
  );
  alisveris.fromMapFV(Map<String, dynamic>map)
  :this(item:map['item'],
        color1:map['color']
  );
  Map<String, dynamic> toMap() {
    return {
      'itemID':id,
      'item': item,
      'color': color1,
      'check':check
    };
  }
}