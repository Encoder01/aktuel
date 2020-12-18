import 'package:flutter/material.dart';

class KategoriClient{
  List<Color> colors =[Colors.yellow,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black];

   setKategori(int index){
    List<Color> colors =[Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black,Colors.black];
    colors[index]=Colors.yellow;
    return colors;
  }

}