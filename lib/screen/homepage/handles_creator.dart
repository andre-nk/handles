part of "../pages.dart";

class HandlesCreatorPage extends StatefulWidget {
  const HandlesCreatorPage({ Key? key }) : super(key: key);

  @override
  _HandlesCreatorPageState createState() => _HandlesCreatorPageState();
}

class _HandlesCreatorPageState extends State<HandlesCreatorPage> {

  FormError errorLocation = FormError.none;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Set<UserModel> membersList = Set();
  Set<String> rolesList = Set();
  PickedFile? _image;

  @override
  Widget build(BuildContext context) {

    void addMember(UserModel invitee, String role){
      setState(() {
        membersList.add(invitee);
        rolesList.add(role);
      });
    }

    _imgFromCamera() async {
      PickedFile? image = await ImagePicker().getImage(
        source: ImageSource.camera, imageQuality: 50
      );
      setState(() {
        _image = image;
      });
    }

    _imgFromGallery() async {
      PickedFile? image = await ImagePicker().getImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      setState(() {
        _image = image;
      });
    }

    void _showPicker(context) {
      Platform.isAndroid
      ? showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        )
      : showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Pick from Camera'),
                onPressed: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Pick from Gallery'),
                onPressed: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
    }

    return Consumer(
      builder: (ctx, watch,child) {

        final _handlesProvider = watch(handlesProvider);
        final _currentUserProvider = watch(currentUserProvider);

        _currentUserProvider.whenData((value){
          setState(() {
            membersList.add(value);
            rolesList.add("Admin");
          });
        });

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
              "Create a Handle",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white
              )
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    _showPicker(context);
                  },
                  child: Container(
                    height: MQuery.height(0.2, context),
                    width: MQuery.width(1, context),
                    color: Colors.grey,
                    child: _image == null
                    ? Center(
                        child: AdaptiveIcon(
                          android: Icons.camera_alt,
                          iOS: CupertinoIcons.camera_fill,
                          color: Colors.white, size: 36
                        ),
                      )
                    : Image(
                      image: FileImage(File(_image!.path)),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: MQuery.height(0.03, context),
                    horizontal: MQuery.width(0.025, context)
                  ),
                  height: MQuery.height(0.9, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0
                        ),
                        child: Font.out(
                          "Handle's title",
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
                              hintText: "Enter the project's title...",
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
                          "Handle's description (optional)",
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
                            hintText: "Enter project's description (optional)",
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            border: InputBorder.none
                          ),
                        )
                      ),
                      SizedBox(height: MQuery.height(0.02, context)),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Font.out(
                            "Invite members:",
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: (){
                                  Get.to(() => ContactPicker(), transition: Transition.cupertino);
                                },
                                icon: AdaptiveIcon(
                                  android: Icons.contact_page,
                                  iOS: CupertinoIcons.person_2_square_stack_fill,
                                  color: Palette.primaryText,
                                  size: 24
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  Get.dialog(AddMemberViaNumberDialog(addMember: addMember));
                                },
                                icon: AdaptiveIcon(
                                  android: Icons.add,
                                  iOS: CupertinoIcons.add,
                                  color: Palette.primaryText,
                                  size: 24
                                ),
                              )
                            ]
                          )
                        ],
                      ),
                      SizedBox(height: MQuery.height(0.02, context)),
                      Container(
                        height: MQuery.height(0.3, context),
                        child: ListView.builder(
                          itemCount: membersList.length,
                          itemBuilder: (context, index){
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Palette.primary,
                                radius: MQuery.height(0.025, context),
                                backgroundImage: membersList.toList()[index].profilePicture != ""
                                ? NetworkImage(membersList.toList()[index].profilePicture!)
                                : AssetImage("assets/sample_profile.png") as ImageProvider
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    membersList.toList()[index].name.length >= 16
                                    ? membersList.toList()[index].name.substring(0, 16) + "..."
                                    : membersList.toList()[index].name,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    )
                                  ),
                                  Text(
                                    rolesList.toList()[index],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    )
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon:  AdaptiveIcon(
                                  android: Icons.close,
                                  iOS: CupertinoIcons.xmark,
                                  color: Colors.black
                                ),
                                onPressed: (){
                                  setState(() {
                                    membersList.remove(membersList.toList()[index]);
                                  });
                                }
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: MQuery.height(0.05, context)),
                      Button(
                        width: double.infinity,
                        title: "Create Handle",
                        textColor: Colors.white,
                        color: Palette.primary,
                        method: () async {
                          if(titleController.text == ""){
                            setState(() {
                              errorLocation = FormError.title;
                            });
                          } else if (_image == null && membersList.length >= 2){

                            Map<String, String> membersMap = {};
                            for (var i = 0; i < membersList.length; i++) {
                              membersMap[membersList.toList()[i].id] = rolesList.toList()[i];
                            }

                            print(membersMap);

                            _handlesProvider.createHandles(
                              HandlesModel(
                                id: "1",
                                cover: "",
                                members: membersMap,
                                description: descriptionController.text,
                                name: titleController.text,
                                pinnedBy: [""]
                              )
                            );
                          } else if (_image != null && membersList.length >= 2){

                            Map<String, String> membersMap = {};
                            for (var i = 0; i < membersList.length; i++) {
                              membersMap[membersList.toList()[i].id] = rolesList.toList()[i];
                            }

                            print(membersMap);

                            _handlesProvider.uploadHandlesCover(_image!.path, titleController.text).then((value){
                              if(value != null){
                                _handlesProvider.createHandles(
                                  HandlesModel(
                                    id: Uuid().v4(),
                                    cover: value,
                                    members: membersMap,
                                    description: descriptionController.text,
                                    name: titleController.text,
                                    pinnedBy: [""],
                                    archivedBy: [""]
                                  )
                                );
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please add at least one more member')));
                          }
                        }
                      )
                    ]
                  )
                ),
              ],
            )
          )
        );
      },
    );
  }
}

class AddMemberViaNumberDialog extends StatefulWidget {
  
  final void Function(UserModel, String) addMember;
  const AddMemberViaNumberDialog({ Key? key, required this.addMember }) : super(key: key);

  @override
  _AddMemberViaNumberDialogState createState() => _AddMemberViaNumberDialogState();
}

class _AddMemberViaNumberDialogState extends State<AddMemberViaNumberDialog> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  bool isError = false;
  String dropdownValue = "Member";

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {

        final _handlesProvider = watch(handlesProvider);

        return Dialog(
          insetPadding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MQuery.height(0.75, context),
              minWidth: MQuery.width(0.8, context)
            ),
            child: Container(
              padding: EdgeInsets.all(MQuery.height(0.01, context)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MQuery.height(0.02, context)),
                    Text(
                      "Add Member",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Palette.primaryText,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: MQuery.width(0.01, context)),
                          Text(
                            "+",
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                          SizedBox(width: MQuery.width(0.005, context)),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: MQuery.height(0.065, context),
                              padding: const EdgeInsets.only(left: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: countryCodeController,
                                  cursorColor: Palette.primary,
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: isError ? Palette.warning : Colors.black.withOpacity(0.4)
                                    ),
                                    hintText: "61",
                                    contentPadding: EdgeInsets.fromLTRB(2.5, 10, 5, 10),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            )
                          ),
                          SizedBox(width: MQuery.width(0.01, context)),
                          Expanded(
                            flex: 14,
                            child: Container(
                              height: MQuery.height(0.065, context),
                              width: MQuery.width(0.9, context),
                              margin: const EdgeInsets.only(left: 0.0, right: 7.5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isError ? Palette.warning : Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: Center(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp("^0+"), replacementString: "")
                                  ],
                                  keyboardType: TextInputType.phone,
                                  controller: phoneNumberController,
                                  cursorColor: Palette.primary,
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: isError ? Palette.warning : Colors.black.withOpacity(0.4)
                                    ),
                                    hintText: "Ex: 2 3456 7890",
                                    contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    border: InputBorder.none
                                  ),
                                  onEditingComplete: (){
                                    phoneNumberController.text.replaceAll("0", "");
                                  },
                                  onFieldSubmitted: (value){
                                    value.replaceAll("0", "");
                                  },
                                ),
                              )
                            ),
                          )
                        ],
                      )
                    ),
                    SizedBox(height: MQuery.height(0.01, context)),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: MQuery.width(0.01, context)),
                          Text(
                            "Role: ",
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          SizedBox(width: MQuery.width(0.01, context)),
                          Expanded(
                            flex: 14,
                            child: Container(
                              height: MQuery.height(0.065, context),
                              width: MQuery.width(0.9, context),
                              margin: const EdgeInsets.only(left: 0.0, right: 7.5),
                              padding: EdgeInsets.symmetric(
                                horizontal: MQuery.width(0.015, context)
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isError ? Palette.warning : Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownValue,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Admin"),
                                      value: "Admin",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Client"),
                                      value: "Client",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Member"),
                                      value: "Member",
                                    )
                                  ],
                                  onChanged: (String? value){
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  }
                                )
                              )
                            ),
                          )
                        ],
                      )
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                    Button(
                      title: "Add Member",
                      textColor: Colors.white,
                      method: (){
                        _handlesProvider.addMember("+" + countryCodeController.text + phoneNumberController.text).then((value){
                          if(value != null){
                            widget.addMember(value, dropdownValue);
                            Get.back();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The user with that phone number cannot be found.')));
                            Get.back();
                          }
                        });
                      },
                      color: Palette.primary
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                  ]
                )
              )
            )
          )
        );
      },
    );
  }
}