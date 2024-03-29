import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/categories.dart';
import 'package:iihs/utils/widgets/AppDrawer.dart';
import 'package:iihs/models/constants/app_theme.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({Key key}) : super(key: key);
  static const routeName = '/mainpage-screen';

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen>
    with TickerProviderStateMixin {
  int _selectedPageIndex = 0;
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Categories> templateList = Categories.maincategories;
  AnimationController animationController;

  @override
  void initState() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.chasingDots
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 80.0
      ..progressColor = AppTheme.iihsbackground
      ..backgroundColor = Colors.transparent
      ..indicatorColor = AppTheme.iihsbackground_dark
      ..textColor = AppTheme.iihsbackground_dark
      ..textStyle = TextStyle(
        fontSize: 16,
        color: AppTheme.darkerText,
        // fontWeight: FontWeight.w700,
      );
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    //BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.iihsbackground,
      endDrawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 26,
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Theme.of(context).bottomAppBarColor,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.poll),
            label: 'Ratings',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.language_outlined),
            label: 'News',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.person),
            label: 'my Profile',
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitChasingDots(
                color: AppTheme.nearlyBlack,
                size: 100.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SpinKitChasingDots(
                color: AppTheme.nearlyBlack,
                size: 100.0,
              ),
            );
          } else {
            return FadeTransition(
              opacity: animationController,
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.115,
                      child: apptopBar(context),
                    ),
                    Expanded(
                      // flex: 10,
                      child: Container(
                        color: AppTheme.iihsbackground,
                        child: GridView(
                          padding: const EdgeInsets.only(
                              top: 10, left: 30, right: 30),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: List<Widget>.generate(
                            templateList.length,
                            (int index) {
                              final int count = templateList.length;
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              );
                              animationController.forward();
                              return TemplateListView(
                                animation: animation,
                                animationController: animationController,
                                animationvaluechanger:
                                    index % 2 == 0 ? 100 : -100,
                                listData: templateList[index],
                                callBack: () {
                                  if (templateList[index].id == 'c1') {
                                    Navigator.pushNamed(
                                      context,
                                      "/selectmakemodel",
                                    );
                                  } else if (templateList[index].id == 'c3') {
                                    Navigator.pushNamed(
                                      context,
                                      "/selectmake",
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 15.0,
                            childAspectRatio: 1.8,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.09,
                    //   child: bottomNavigationBar(context),
                    // ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget apptopBar(context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                0.2,
                0.5,
              ],
                  colors: [
                AppTheme.iihsbackground,
                AppTheme.iihsyellow,
              ])),

          // color: Colors.black,
          padding:
              EdgeInsets.only(top: 21.0, left: 0.0, right: 0.0, bottom: 0.0),
          alignment: Alignment.bottomLeft,
          child: IconButton(
            icon: Container(
              color: AppTheme.iihsyellow,
              child: Icon(
                Icons.search,
                size: 30.0,
                color: Colors.black,
              ),
            ),
            onPressed: () => null,
          ),
        ),
        Positioned(
          left: 35,
          right: 0,
          top: 0,
          child: Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(160.0),
            ),
            elevation: 10.0,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 40.0, right: 0.0, bottom: 10.0),
                  child: Image.asset(
                    'assets/images/logo-iihs-in-app.png',
                    width: 80,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 25.0,
                        color: Colors.black,
                      ),
                      onPressed: () => Scaffold.of(context).openEndDrawer()
                      //=> _scaffoldKey.currentState.openDrawer(),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomNavigationBar(context) {
    return Stack(
      children: <Widget>[
        // Container(
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           begin: Alignment.topLeft,
        //           end: Alignment.bottomRight,
        //           stops: [
        //         0.2,
        //         0.5,
        //       ],
        //           colors: [
        //         AppTheme.iihsbackground,
        //         AppTheme.iihsyellow,
        //       ])),
        //   alignment: Alignment.bottomRight,
        //   child: SizedBox(),
        // ),
        Positioned(
          right: 25,
          left: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(160),
              // topLeft: Radius.circular(40),
            ),
            child: BottomNavigationBar(
              iconSize: 26,
              onTap: _selectPage,
              backgroundColor: Colors.white,
              unselectedItemColor: Theme.of(context).bottomAppBarColor,
              selectedItemColor: Colors.black,
              currentIndex: _selectedPageIndex,
              type: BottomNavigationBarType.shifting,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.poll),
                  label: 'Ratings',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.language_outlined),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Icon(Icons.person),
                  label: 'my Profile',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TemplateListView extends StatelessWidget {
  const TemplateListView(
      {Key key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation,
      this.animationvaluechanger})
      : super(key: key);

  final Categories listData;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final int animationvaluechanger;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                animationvaluechanger * (1.0 - animation.value), 0.0, 0.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              elevation: 8,
              child: Stack(
                // alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                        listData.id == 'c1'
                            ? 'assets/images/topSafetyPickDummy.png'
                            : listData.id == 'c2'
                                ? 'assets/images/topSafetyPickDummy.png'
                                : listData.id == 'c3'
                                    ? 'assets/images/dummySideView.png'
                                    : 'assets/images/logo-iihs-in-app.png',
                        //height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.fitWidth),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        color: Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            listData.title,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey.withOpacity(0.2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      onTap: () {
                        callBack();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// _pages[_selectedPageIndex]['page'],
