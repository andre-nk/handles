part of '../pages.dart';

class AccountCreationPage extends StatefulWidget {
  const AccountCreationPage({Key? key}) : super(key: key);

  @override
  _AccountCreationPageState createState() => _AccountCreationPageState();
}

class _AccountCreationPageState extends State<AccountCreationPage> {
  TextEditingController nameController = TextEditingController();
  XFile? _image;
  bool isError = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    _imgFromCamera() async {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
      setState(() {
        _image = image;
      });
    }

    _imgFromGallery() async {
      final imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
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
              })
          : showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text('Pick from Camera'),
                    onPressed: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Pick from Gallery'),
                    onPressed: () async {
                      await _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: MQuery.width(0.015, context),
          right: MQuery.width(0.015, context)
        ),
        child: isLoading
        ? Center(
            child: CircularProgressIndicator(color: Palette.primary)
          )
        : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Font.out(
                "Create Your Account",
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Palette.secondaryText
              ),
              Spacer(flex: 2),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))
                ),
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  backgroundColor: Palette.formColor,
                  radius: MQuery.height(0.075, context),
                  backgroundImage: _image != null
                  ? FileImage(File(_image!.path)) as ImageProvider
                  : AssetImage("assets/sample_profile.png")
                ),
              ),
              SizedBox(height: MQuery.height(0.04, context)),
              Container(
                  height: MQuery.height(0.075, context),
                  width: MQuery.width(0.9, context),
                  margin: EdgeInsets.only(
                    left: MQuery.width(0.025, context),
                    right: MQuery.width(0.025, context)
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isError ? Palette.warning : Colors.transparent
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Palette.formColor,
                  ),
                  child: Center(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      cursorColor: Palette.primary,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: isError
                          ? Palette.warning
                          : Colors.black.withOpacity(0.4)
                        ),
                        hintText: "Enter your name...",
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: InputBorder.none
                      ),
                    ),
                  )),
              isError
              ? Column(
                  children: [
                    SizedBox(height: MQuery.height(0.02, context)),
                    Font.out("Please provide your name to proceed",
                        fontSize: 14, color: Palette.warning),
                  ],
                )
              : SizedBox(),
              Spacer(flex: 2),
              Consumer(builder: (context, watch, _) {
                final _authenticationProvider = watch(authenticationProvider);
                return Button(
                  title: "CONTINUE",
                  color: Palette.primary,
                  method: () {
                    setState(() {
                      isLoading = true;
                    });
                    if (nameController.text != "") {
                      if (_image != null) {
                        _authenticationProvider
                          .uploadUserProfilePicture(_image!.path)
                          .then((_downloadURL){
                            if (_downloadURL != "") {
                              if (_authenticationProvider.auth.currentUser != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                _authenticationProvider.createUserRecord(
                                  UserModel(
                                    id: _authenticationProvider.auth.currentUser!.uid,
                                    name: nameController.text,
                                    profilePicture: _downloadURL,
                                    phoneNumber: _authenticationProvider.auth.currentUser!.phoneNumber ?? "",
                                    countryCode: _authenticationProvider.auth.currentUser!.phoneNumber!.substring(0, 3),
                                    role: "",
                                    company: "",
                                    companyAddress: "",
                                    companyLogo: "",
                                    creditCard: "",
                                    handlesList: [""],
                                  )
                                );
                              }
                            }
                          }
                        );
                      } else if (_image == null) {
                        if (_authenticationProvider.auth.currentUser != null) {
                          _authenticationProvider.createUserRecord(
                            UserModel(
                              id: _authenticationProvider.auth.currentUser!.uid,
                              name: nameController.text,
                              profilePicture: "https://firebasestorage.googleapis.com/v0/b/handles-ad2a9.appspot.com/o/sample_profile.png?alt=media&token=e9ad3cf8-41e3-462c-ac7b-dad289f3b7d1",
                              phoneNumber: _authenticationProvider.auth.currentUser!.phoneNumber ??"",
                              countryCode: _authenticationProvider
                                .auth.currentUser!.phoneNumber!
                                .substring(0, 3),
                              role: "",
                              company: "",
                              companyAddress: "",
                              companyLogo: "",
                              creditCard: "",
                              handlesList: [""],
                            )
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        isError = true;
                      });
                    }
                  },
                  textColor: Colors.white,
                );
              }),
              Spacer()
            ],
          ),
        ),
      )
    );
  }
}
