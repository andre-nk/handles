part of "../pages.dart";

enum FormError{title, description, url, startTime, endTime, attendees, none}
enum DateTarget{start, end}

class MeetingCreator extends StatefulWidget {
  const MeetingCreator({ Key? key }) : super(key: key);

  @override
  _MeetingCreatorState createState() => _MeetingCreatorState();
}

class _MeetingCreatorState extends State<MeetingCreator> {

  FormError errorLocation = FormError.none;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  DateTime baseDate = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(hours: 1));
  Set<int> attendeesList = Set(); //INFO: ATTENDEES UID HERE... (INT FOR SAMPLE)
  bool isSelecting = false;

  @override
  Widget build(BuildContext context) {

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: baseDate,
          firstDate: DateTime(1900, 8),
          lastDate: DateTime(2100));
      if (picked != null && picked != baseDate)
        setState(() {
          baseDate = picked;
        });
    }

    Future<void> _selectTime(BuildContext context, DateTarget target) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: target == DateTarget.start
        ? TimeOfDay(hour: baseDate.hour, minute: baseDate.minute)
        : TimeOfDay(hour: endTime.hour, minute: endTime.minute),
      );
      if (picked != null && picked != baseDate){
        if(target == DateTarget.start){
          setState(() {
            baseDate = DateTime(
              baseDate.year,
              baseDate.month,
              baseDate.day,
              picked.hour,
              picked.minute
            );
          });
        } else if (target == DateTarget.end){
          setState(() {
            endTime = DateTime(
              baseDate.year,
              baseDate.month,
              baseDate.day,
              picked.hour,
              picked.minute
            );
          });
        }
      }
    }

    print(baseDate);
    print(endTime);
    print(attendeesList.toList());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.primary,
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
        title: Text(
          "Send a Meeting Chat",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: MQuery.height(0.03, context),
            horizontal: MQuery.width(0.025, context)
          ),
          height: MQuery.height(1.175, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Meeting's title",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              Container(
                height: MQuery.height(0.06, context),
                width: MQuery.width(0.9, context),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: errorLocation == FormError.title ? Palette.warning : Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.formColor,
                ),
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: titleController,
                    cursorColor: Palette.primary,
                    style: TextStyle(
                      fontSize: 16
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: errorLocation == FormError.title ? Palette.warning : Colors.black.withOpacity(0.4)
                      ),
                      hintText: "Enter the meeting's title...",
                      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      border: InputBorder.none
                    ),
                  ),
                )
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Meeting's description (optional)",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              Container(
                height: MQuery.height(0.15, context),
                width: MQuery.width(0.9, context),
                padding: EdgeInsets.only(
                  top: MQuery.height(0.005, context)
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: errorLocation == FormError.description ? Palette.warning : Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.formColor,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: descriptionController,
                  cursorColor: Palette.primary,
                  minLines: 3,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 16
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: errorLocation == FormError.description ? Palette.warning : Colors.black.withOpacity(0.4)
                    ),
                    hintText: "Enter meeting's description (optional)",
                    contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    border: InputBorder.none
                  ),
                )
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Meeting's invitation / join link",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              Container(
                height: MQuery.height(0.06, context),
                width: MQuery.width(0.9, context),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: errorLocation == FormError.url ? Palette.warning : Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.formColor,
                ),
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.url,
                    controller: urlController,
                    cursorColor: Palette.primary,
                    style: TextStyle(
                      fontSize: 16
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: errorLocation == FormError.url ? Palette.warning : Colors.black.withOpacity(0.4)
                      ),
                      hintText: "Enter the meeting's join / invitation link",
                      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      border: InputBorder.none
                    ),
                  ),
                )
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Meeting's Date",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              GestureDetector(
                onTap: (){
                  _selectDate(context);
                },
                child: Container(
                  height: MQuery.height(0.06, context),
                  width: MQuery.width(0.9, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Palette.formColor,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat.yMMMMd().format(baseDate),
                      style: TextStyle(
                        fontSize: 16
                      )
                    ),
                  )
                ),
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Row(
                children: [
                  Expanded(
                    flex: 16,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0
                          ),
                          child: Font.out(
                            "Start Time",
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: MQuery.height(0.01, context)),
                        GestureDetector(
                          onTap: (){
                            _selectTime(context, DateTarget.start);
                          },
                          child: Container(
                            height: MQuery.height(0.06, context),
                            width: MQuery.width(0.2, context),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: errorLocation == FormError.startTime ? Palette.warning : Colors.transparent
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Palette.formColor,
                            ),
                            child: Center(
                              child: Text(
                                DateFormat.jm().format(baseDate),
                                style: TextStyle(
                                  fontSize: 16
                                )
                              )
                            )
                          ),
                        ),
                      ]
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 16,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0
                          ),
                          child: Font.out(
                            "End Time",
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: MQuery.height(0.01, context)),
                        GestureDetector(
                          onTap: (){
                            _selectTime(context, DateTarget.end);
                          },
                          child: Container(
                            height: MQuery.height(0.06, context),
                            width: MQuery.width(0.2, context),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: errorLocation == FormError.endTime ? Palette.warning : Colors.transparent
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Palette.formColor,
                            ),
                            child: Center(
                              child: Text(
                                DateFormat.jm().format(endTime),
                                style: TextStyle(
                                  fontSize: 16
                                )
                              )
                            )
                          ),
                        ),
                      ]
                    ),
                  )
                ],
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Divider(),
              Row(
                children: [
                  Font.out(
                    "Invite attendees:",
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                  SizedBox(width: MQuery.width(0.01, context)),
                  errorLocation == FormError.attendees
                  ? Font.out(
                      "(invite min. 1 attendee)",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Palette.warning
                    )
                  : SizedBox()
                ],
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              Container(
                height: MQuery.height(0.3, context),
                child: //TODO: LOAD HANDLES'S MEMBER MODEL
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0
                      ),
                      child: ListTile(
                        onTap: (){
                          if(attendeesList.toList().indexOf(index) >= 0){
                            print("a");
                            setState(() {
                              attendeesList.remove(index);
                            });
                          } else {
                            print("b");
                            setState(() {
                              attendeesList.add(index);
                            });
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Palette.primary,
                          radius: MQuery.height(0.025, context),
                        ),
                        title: Font.out(
                          "Person " + index.toString(),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start
                        ),
                        trailing: attendeesList.toList().indexOf(index) >= 0
                        ? ZoomIn(
                            duration: Duration(milliseconds: 50),
                            child: Positioned(
                              child: CircleAvatar(
                                backgroundColor: Palette.secondary,
                                radius: 10,
                                child: Icon(Icons.check, size: 12, color: Colors.white),
                              ),
                            ),
                          )
                        : ZoomIn(
                            duration: Duration(milliseconds: 50),
                            child: SizedBox()
                          )
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MQuery.height(0.025, context)),
              Button(
                width: double.infinity,
                title: "Send Meeting Message",
                textColor: Colors.white,
                color: Palette.primary,
                method: (){
                  if(titleController.text == ""){
                    setState(() {
                      errorLocation = FormError.title;
                    });
                  } else if (urlController.text == ""){
                    setState(() {
                      errorLocation = FormError.url;
                    });
                  } else if (attendeesList.length == 0){
                    setState(() {
                      errorLocation = FormError.attendees;
                    });
                  } else {
                    //TODO: CREATE MESSAGE LOGIC
                  }
                }
              )
            ],
          )
        ),
      )
    );
  }
}