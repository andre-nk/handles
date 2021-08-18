part of '../pages.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FlutterAppBadger.isAppBadgeSupported().then((value){
      if(value){
        FlutterAppBadger.updateBadgeCount(1);
      }
    });

    return Scaffold(
      backgroundColor: Palette.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: MQuery.width(0.015, context),
            right: MQuery.width(0.015, context)
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Column(
                  children: [
                    Font.out(
                      "Handles",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    Font.out(
                      "A simple group messenger for your trade projects - chat & collaborate on one feed",
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ],
                ),
                Spacer(flex: 2),
                Image(
                  height: MQuery.height(0.15, context),
                  image: AssetImage("assets/handles_logo.png"),
                ),
                Spacer(flex: 2),
                Button(
                  title: "GET STARTED",
                  color: Palette.secondary,
                  method: (){
                    Get.offAll(() => PhoneAuthPage(), transition: Transition.cupertino);
                  },
                  textColor: Colors.white,
                ),
                Spacer()
              ],
            ),
          ),
        ),
      )
    );
  }
}