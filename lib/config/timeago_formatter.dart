import 'package:timeago/timeago.dart' as timeago;

class TimeagoFormatter{
 static String getTimeagoFormat(DateTime time){
   timeago.setLocaleMessages('ru', timeago.RuMessages());
   return timeago.format(time,locale: 'ru');
 }
}