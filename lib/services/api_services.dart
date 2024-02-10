import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:chat_app/models/notification_model.dart';


class ApiService {

static Future<int> sendMessage({required NotificationModel notification}) async{ 
     var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
     
   
     
     var body =  jsonEncode(notification.toMap());

     var headers = {
      "Content-Type":"application/json",
      "Authorization":"Bearer AAAA0LHcyW8:APA91bEUwgNeicc0n5cqviRjQKhmRU_NYX9R3ZuCaHhHgZs8gsTpFV9fycRFFFxE3qQfXHEGbU-6iK2oISxYDQFo9o5R8YOFWfU0qtSDx-hdcnK3ET4JSAv6TC0rtztP1dDTyBX6K7ZZ",

     };


     var response = await https.post(url,
     body: body,headers: headers);


     if(response.statusCode==200){
      var data = jsonDecode(response.body);

      return data["success"];
     }

     return 0;
}

}