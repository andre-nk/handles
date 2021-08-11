part of "../pages.dart";

enum Status {basic, pro, pro_unlimited}
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {

  Status userStatus = Status.basic;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {

        final _purchasesProvider = watch(purchasesProvider);

        Future<PurchaserInfo> purchasePackage(Package package) async{
          PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
          return purchaserInfo;
        }

        Future<List<Package>> displayProducts() async {
          await _purchasesProvider.init();
          PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();

          if ((purchaserInfo.entitlements.all['pro'] != null && purchaserInfo.entitlements.all['pro']!.isActive == true)) {
            setState(() {
              userStatus = Status.pro;
            });
            return [];
          } else if ((purchaserInfo.entitlements.all['pro_unlimited'] != null && purchaserInfo.entitlements.all['pro_unlimited']!.isActive == true)) {
            setState(() {
              userStatus = Status.pro_unlimited;
            });
            return [];
          } else {
            late Offerings offerings;
            try {
              offerings = await Purchases.getOfferings();
            } on PlatformException catch (e) {
              print(e);
              await showDialog(
                context: context,
                builder: (BuildContext context) => ShowDialogToDismiss(
                  title: "Error", content: "Cannot retrieve subscription items", buttonText: 'OK')
              );
            }

            // ignore: unnecessary_null_comparison
            if (offerings == null || offerings.current == null) {
              await showDialog(
                context: context,
                builder: (BuildContext context) => ShowDialogToDismiss(
                  title: "Error", content: "Cannot retrieve subscription items", buttonText: 'OK')
              );
            } else {
                return offerings.current!.availablePackages;
            }
          }

          return [];
        }

        return Scaffold(
          appBar: AppBar(
              centerTitle: false,
            toolbarHeight: MQuery.height(0.07, context),
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: AdaptiveIcon(
                  android: Icons.arrow_back,
                  iOS: CupertinoIcons.back,
                  color: Colors.black),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: FutureBuilder<List<Package>>(
            future: displayProducts(),
            builder: (context, snapshot){

              print("Snapshots: ${snapshot.data}");
  
              return snapshot.hasData
              ? SingleChildScrollView(
                  child: Container(
                    height: MQuery.height(0.975, context),
                    width: MQuery.width(1, context),
                    padding: EdgeInsets.symmetric(
                      vertical: MQuery.height(0.015, context)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              SizedBox(height: MQuery.height(0.01, context)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/handles_logo.png", height: MQuery.height(0.1, context)),
                                  SizedBox(width: MQuery.width(0.02, context)),
                                  FadeInLeft(
                                    from: 20,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Handles",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: Palette.secondaryText)),
                                          SizedBox(
                                              height: MQuery.height(0.005, context)),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MQuery.height(0.01, context),
                                                  vertical:
                                                      MQuery.height(0.005, context)),
                                              decoration: BoxDecoration(
                                                  color: Palette.tertiary,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5))),
                                              child: Center(
                                                child: Text("PRO",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w700)),
                                              )),
                                        ]),
                                  )
                                ],
                              ),
                              SizedBox(height: MQuery.height(0.035, context)),
                              Divider(height: 0),
                              Container(
                                padding: EdgeInsets.all(MQuery.height(0.02, context)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Basic",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Palette.secondaryText)
                                              ),
                                              SizedBox(width: MQuery.width(0.01, context)),
                                              userStatus == Status.basic 
                                              ? AdaptiveIcon(
                                                  android: Icons.check_circle_outline_rounded,
                                                  iOS: CupertinoIcons.checkmark_alt_circle,
                                                  color: Palette.primary
                                                )
                                              : SizedBox()
                                            ],
                                          ),
                                          Text(
                                            "FREE",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Palette.secondaryText)
                                            ),
                                        ]
                                      ),
                                      SizedBox(height: MQuery.height(0.02, context)),
                                      Text(
                                        "Join a Handles and its feature via invitation-only and display your personal informations only on your profile",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          height: 1.5,
                                          color: Palette.secondaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400
                                        )
                                      ),
                                    ],
                                  )),
                              Divider(height: 0),
                              Expanded(
                                flex: (snapshot.data!.length),
                                child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index){
                                    return Container(
                                      height: MQuery.height(0.19, context),
                                      child: Column(
                                        children: [
                                          SizedBox(height: MQuery.height(0.02, context)),
                                          Divider(height: 0),
                                          GestureDetector(
                                            onTap: (){
                                              if(index == 0){
                                                if(userStatus == Status.basic){
                                                  purchasePackage(snapshot.data![index]).then((value){
                                                    print(value);
                                                  });
                                                } else if (userStatus == Status.pro){

                                                } else if (userStatus == Status.pro_unlimited){
                                                  purchasePackage(snapshot.data![index]).then((value){
                                                    print(value);
                                                  });
                                                } 
                                              } else if (index == 1){
                                                if(userStatus == Status.basic){
                                                  purchasePackage(snapshot.data![index]).then((value){
                                                    print(value);
                                                  });
                                                } else if (userStatus == Status.pro_unlimited){
                                                  
                                                } else if (userStatus == Status.pro){
                                                  purchasePackage(snapshot.data![index]).then((value){
                                                    print(value);
                                                  });
                                                } 
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(MQuery.height(0.02, context)),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            snapshot.data![index].product.title.substring(0, snapshot.data![index].product.title.indexOf('(')),
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Palette.secondaryText
                                                            )
                                                          ),
                                                          SizedBox(width: MQuery.width(0.005, context)),
                                                          index == 0
                                                          ? userStatus == Status.pro 
                                                            ? AdaptiveIcon(
                                                                android: Icons.check_circle_outline_rounded,
                                                                iOS: CupertinoIcons.checkmark_alt_circle,
                                                                color: Palette.primary
                                                              )
                                                            : SizedBox()
                                                          : userStatus == Status.pro_unlimited
                                                            ? AdaptiveIcon(
                                                                android: Icons.check_circle_outline_rounded,
                                                                iOS: CupertinoIcons.checkmark_alt_circle,
                                                                color: Palette.primary
                                                              )
                                                            : SizedBox()
                                                        ], 
                                                      ),
                                                      Text(
                                                        snapshot.data![index].product.priceString + "/mo",
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                          color: Palette.secondaryText
                                                        )
                                                      ),
                                                    ]
                                                  ),
                                                  SizedBox(height: MQuery.height(0.02, context)),
                                                  Text(
                                                    snapshot.data![index].product.description,
                                                    style: TextStyle(
                                                      height: 1.5,
                                                      color: HexColor("00BFA5"),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400
                                                    )
                                                  ),
                                                ],
                                              )
                                            ),
                                          ),
                                          Divider(height: 0),
                                        ]
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(MQuery.height(0.02, context)),
                                child: Text(
                                    "The default payment method provided will be charged correspondingly every month until cancelled",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: 1.25,
                                        color:
                                            Palette.secondaryText.withOpacity(0.75),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text("Got any question? Contact us!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.25,
                                    color: Palette.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: MQuery.height(0.025, context)),
                            Button(
                              title: "GO PREMIUM",
                              color: Palette.primary,
                              textColor: Colors.white,
                              method: () {},
                            ),
                            SizedBox(height: MQuery.height(0.035, context)),
                          ],
                        ),
                      ],
                    )
                  )
                )
              : Center(
                  child: CircularProgressIndicator(color: Palette.primary)
              );
            }
          )
        );
      },
    );
  }
}
