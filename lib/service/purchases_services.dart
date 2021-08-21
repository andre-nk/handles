part of "services.dart";

class PurchasesServices with ChangeNotifier{
  static const _apiKey = 'GJwnSERogYKUiCaRvukwcnWaQTCsIHSN';

  Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }

  Future<PurchaserInfo> getPurchaserInfo() async{
    await init();
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    return purchaserInfo;
  }

  Future<List<Package>> displayProducts(BuildContext context) async {
    try{
      Offerings? offerings;

      //fetching
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

      //handling
      if (offerings == null || offerings.current == null) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
            title: "Error", content: "Cannot retrieve subscription items", buttonText: 'OK')
        );
      } else {
        return offerings.current!.availablePackages;
      }
    } catch (e){
      print(e);
    }
    return [];
  }


  Future<PurchaserInfo> purchasePackage(Package package) async{
    PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
    return purchaserInfo;
  }
}