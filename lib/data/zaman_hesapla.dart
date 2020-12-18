import 'package:intl/intl.dart';

class ZamanHesapla{
  timeCalculate(DateTime tm) {
    DateTime today = new DateTime.now().toUtc().toLocal();
    Duration difference = tm.difference(today);

    if(difference.inHours<24&&difference.inHours>0)
      return "Yarın Bitiyor";
    else if(difference.inDays==-1)
      return "Dün Bitti";
    else if(difference.inHours<-25&&difference.inDays>=-7)
      return "Geçen ${DateFormat.EEEE("tr-tr").format(tm)} Bitti";
    else if(difference.inDays<=-7)
      return " ${tm.day} ${DateFormat.MMMM("tr-tr").format(tm)} Bitti";
    else if(difference.inDays==0)
      return "Bügün Son";
    else if(difference.inHours>25&&difference.inDays<7)
      return "${DateFormat.EEEE("tr-tr").format(tm)} Günü Son";
    else if(difference.inDays>=7)
      return "${tm.day} ${DateFormat.MMMM("tr-tr").format(tm)} Son";

  }
}