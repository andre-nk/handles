part of "../pages.dart";

class PreviewCameraPage extends StatefulWidget {

  final String handlesID;
  final String replyTo;
  final XFile? image;

  const PreviewCameraPage({ Key? key, required this.image, required this.handlesID,  required this.replyTo}) : super(key: key);

  @override
  _PreviewCameraPageState createState() => _PreviewCameraPageState();
}

class _PreviewCameraPageState extends State<PreviewCameraPage> {

  int globalID = 0;
  TextEditingController chatController = TextEditingController();

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {

        final _handlesProvider = watch(handlesProvider);
        final _chatProvider = watch(chatProvider);

        Future<void> showIndeterminateProgressNotification(int id) async {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id,
              channelKey: 'progress_bar',
              title: 'Sending ${widget.image!.name}',
              body: '',
              notificationLayout: NotificationLayout.ProgressBar,
              progress: null,
              locked: true
            )
          );
        }

        return StreamBuilder<HandlesModel>(
          stream: _handlesProvider.handlesModelGetter(widget.handlesID),
          builder: (context, snapshot) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.black,
              appBar: AppBar(
                centerTitle: false,
                backgroundColor: Colors.black.withOpacity(0.5),
                toolbarHeight: MQuery.height(0.07, context),
                leading: IconButton(
                  icon: AdaptiveIcon(
                    android: Icons.arrow_back,
                    iOS: CupertinoIcons.back,
                  ),
                  onPressed: (){
                    Get.back();
                  },
                ),
                title: Font.out(
                  "Send an image",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  color: Colors.white
                ),
                actions: [
                  IconButton(
                    icon: AdaptiveIcon(
                      android: Icons.send,
                      iOS: CupertinoIcons.paperplane_fill,
                      color: Colors.white
                    ),
                    onPressed: (){
                    
                      showIndeterminateProgressNotification(
                        Random().nextInt(1000)
                      );

                      _chatProvider.uploadImageURL(widget.image!.path, snapshot.data!.name).then((mediaURL){
                        _chatProvider.sendImageChat(
                          widget.handlesID,
                          ChatModel(
                            replyTo: widget.replyTo,
                            id: Uuid().v4(),
                            type: ChatType.image,
                            content: chatController.text,
                            mediaURL: mediaURL,
                            readBy: [],
                            deletedBy: [],
                            timestamp: DateTime.now(),
                            sender: "",
                            isPinned: false
                          )
                        );
                      });

                      Get.off(() => HandlesPage(handlesID: widget.handlesID, isFromSendingFiles: true), transition: Transition.cupertino);
                    },
                  )
                ]
              ),
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: MQuery.height(1, context),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: MQuery.height(0.9, context),
                          child: PinchZoom(
                            image: Image.file(File(widget.image!.path)),
                            zoomedBackgroundColor: Colors.black,
                            resetDuration: const Duration(milliseconds: 100),
                            maxScale: 1,
                            onZoomStart: (){print('Start zooming');},
                            onZoomEnd: (){print('Stop zooming');},
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MQuery.height(0.1, context),
                    width: MQuery.width(1, context),
                    padding: EdgeInsets.all(MQuery.height(0.02, context)),
                    color: Colors.black.withOpacity(0.5),
                    child: TextField(
                      controller: chatController,
                      maxLines: 6,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5)
                        ),
                        hintText: "Type a message",
                        contentPadding: EdgeInsets.fromLTRB(
                          MQuery.width(0.02, context),
                          MQuery.height(0.0175, context),
                          MQuery.width(0.02, context),
                          MQuery.height(0, context)
                        ),
                        border: InputBorder.none
                      ),
                    )
                  )
                ],
              )
            );
          }
        );
      },
    );
  }
}