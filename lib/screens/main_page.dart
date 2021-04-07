import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iihs/models/categories.dart';
import 'package:iihs/utils/widgets/app_drawer.dart';
import 'package:iihs/screens/vehicleSelectMakeModel.dart';
import 'package:iihs/screens/vehicleSelectMake.dart';
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
  List<Map<String, Object>> _pages;
  List<Categories> templateList = Categories.maincategories;

  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _pages = [
      {
        'page': MainPageScreen(),
        'title': 'Home',
      },
      {
        'page': VehicleSelectMakeModel(),
        'title': 'Vehicle Make & Model',
      },
      {
        'page': VehicleSelectMake(),
        'title': 'Find your Vehicle with Make',
      },
    ];
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: AppDrawer(),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitDoubleBounce(
                color: AppTheme.nearlyBlack,
                size: 100.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SpinKitDoubleBounce(
                color: AppTheme.nearlyBlack,
                size: 100.0,
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: apptopBar(context),
                  ),

                  Expanded(
                    // flex: 10,
                    child: Container(
                      color: AppTheme.iihsbackground,
                      child: GridView(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
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
                                  Navigator.of(context).pushNamed(
                                    VehicleSelectMakeModel.routeName,
                                  );
                                } else if (templateList[index].id == 'c2') {
                                  Navigator.of(context).pushNamed(
                                    VehicleSelectMake.routeName,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          childAspectRatio: 1.8,
                        ),
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   // left: 0,
                  //   // right: 20,
                  //   // bottom: 0,
                  //   child: bottomNavigationBar,

                  // ),

                  SizedBox(
                    height: 70,
                    child: bottomNavigationBar(context),
                  ),
                ],
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
                Colors.black,
              ])),

          // color: Colors.black,
          padding:
              EdgeInsets.only(top: 21.0, left: 0.0, right: 0.0, bottom: 0.0),
          alignment: Alignment.bottomLeft,
          child: IconButton(
            icon: Container(
              color: Colors.black,
              child: Icon(
                Icons.search,
                size: 30.0,
                color: AppTheme.iihsyellow,
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
                    'assets/images/logo-iihs.png',
                    width: 80,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 30.0,
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
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                0.2,
                0.5,
              ],
                  colors: [
                AppTheme.iihsbackground,
                Colors.black,
              ])),

//          color: Colors.black,
          // padding:
          //     EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 10.0),
          alignment: Alignment.bottomRight,
          child: SizedBox(),
        ),
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
              iconSize: 28,
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
                  icon: Icon(Icons.directions_car),
                  label: 'my Car',
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
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Stack(
                // alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Image.network(
                    listData.buttonimage,
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),

                  // Image(
                  //   image: NetworkImage(listData.buttonimage),
                  //   alignment: Alignment.center,
                  //   height: double.infinity,
                  //   width: double.infinity,
                  //   fit: BoxFit.fill,
                  // ),
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
