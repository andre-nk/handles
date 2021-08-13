part of "services.dart";

class NotificationServices{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  NotificationServices(this.auth, this.firestore, this.storage);

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
      print('token: $token');
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
}