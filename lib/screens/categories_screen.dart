import 'package:flutter/material.dart';

import 'package:iihs/widgets/main_drawer.dart';
import 'package:iihs/helpers/dummy_data.dart';
import 'package:iihs/widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(
                      top: 20.0, left: 0.0, right: 0.0, bottom: 0.0),
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    icon: Container(
                      color: Colors.black,
                      child: Icon(
                        Icons.search,
                        size: 30.0,
                        color: Colors.yellow,
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
                              Icons.list,
                              size: 35.0,
                              color: Colors.black,
                            ),
                            onPressed: () =>
                                _scaffoldKey.currentState.openDrawer(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.all(10),
                children: MAIN_CATEGORIES
                    .map(
                      (catData) => CategoryItem(
                        catData.id,
                        catData.title,
                        catData.color,
                        catData.buttonimage,
                      ),
                    )
                    .toList(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  childAspectRatio: MAIN_CATEGORIES.length / 1.8,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// CircleAvatar(
//   child: IconButton(
//       icon: Icon(
//         Icons.list,
//         size: 30.0,
//         color: Colors.grey,
//       ),
//       onPressed: () => _scaffoldKey.currentState.openDrawer(),
//       ),
//   backgroundColor: Colors.black,
//   radius: 30.0,
// ),
// SizedBox(
//   height: 10.0,
// ),
// Text(
//   'IIHS',
//   style: TextStyle(
//     color: Colors.black,
//     fontSize: 40.0,
//     fontWeight: FontWeight.w700,
//   ),
// ),
// Text(
//   '    HLDI',
//   style: TextStyle(
//     color: Colors.black,
//     fontSize: 40,
//     fontWeight: FontWeight.w700,
//   ),
// ),
