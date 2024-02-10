class NotificationModel {
  final String token;
  final NotificationBody notification;
 final NotificationData data;


 NotificationModel({required this.token,required this.data,required this.notification});

Map<String,dynamic> toMap(){
  return {
    "to":token,
    "notification": notification.toMap(),
    "data":  data.toMap(),
  };

}


factory NotificationModel.fromMap(Map<String,dynamic> data){
  return NotificationModel(token: data["to"], data: NotificationData.fromMap(data["data"]), notification: NotificationBody.fromMap(data["notification"]));
}

}

class NotificationBody {
  final String title = "Chat-Buddy";
  final String body;

  NotificationBody({required this.body});

  Map<String,dynamic> toMap(){
    return {
    "title":title,
    "body":body
    };
  }


  factory NotificationBody.fromMap(Map<String,dynamic> data){
    return NotificationBody(body: data["body"]);
  }
}

class NotificationData {
  final String recieverId;
  final String recieverUserName;
  final String token;

  NotificationData({required this.token,required this.recieverId,required this.recieverUserName});

  Map<String,dynamic> toMap(){
    return {
      "token":token,
    "recieverId":recieverId,
    "recieverUserName":recieverUserName
    };
  }

factory NotificationData.fromMap(Map<String,dynamic> data){
  return NotificationData(token: data["token"],recieverId: data["recieverId"], recieverUserName: data["recieverUserName"]);
}



}