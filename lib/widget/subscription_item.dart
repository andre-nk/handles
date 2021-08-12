part of "widgets.dart";

class SubscriptionItem extends ConsumerWidget {

  final int index;
  final Package package;
  final Status userStatus;
  const SubscriptionItem({ Key? key, required this.index, required this.package, required this.userStatus}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    
    final _purchasesProvider = watch(purchasesProvider);

    return Container(
      height: MQuery.height(0.16, context),
      child: Column(
        children: [
          SizedBox(height: MQuery.height(0.02, context)),
          Divider(height: 0),
          GestureDetector(
            onTap: (){
              if(index == 0){ //PRO ENTITLEMENT
                if(userStatus == Status.basic){
                  _purchasesProvider.purchasePackage(package);
                } else if (userStatus == Status.pro_unlimited){
                  _purchasesProvider.purchasePackage(package);
                } 
              } else if (index == 1){ //PRO UNLIMITED ENTITLEMENT
                if(userStatus == Status.basic){
                  _purchasesProvider.purchasePackage(package);
                } else if (userStatus == Status.pro){
                  _purchasesProvider.purchasePackage(package);
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
                            this.package.product.title,
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
                        this.package.product.priceString + "/mo",
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
                    this.package.product.description.replaceAll("\n", ""),
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
  }
}