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
}