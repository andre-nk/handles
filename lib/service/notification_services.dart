part of "services.dart";

class NotificationServices{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  NotificationServices(this.auth, this.firestore);

  Future<void> registerNotification() async {
    FirebaseMessaging.instance.requestPermission();

    registerNotificationToken();

    FirebaseMessaging.onMessage.listen((event) async {

      int id = Random().nextInt(1000);

      print('onMessage: ${event.data}');
      if(Platform.isAndroid){
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'grouped',
            title: 'Sending ${event.data}',
            body: event.data['body'],
            notificationLayout: NotificationLayout.Messaging,
            progress: null,
            locked: false
          )
        );
      }
      return;
    });
  }

  Future<void> registerNotificationToken() async {
    FirebaseMessaging.instance.getToken().then((token) {
      firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .update({
        'pushToken': token
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> markNotification(String meetingName, bool mark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(meetingName, mark);
  }

  Future<bool> getScheduleMark(String meetingName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(meetingName) ?? false;
    return value;
  }
}