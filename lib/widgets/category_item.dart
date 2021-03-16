import 'package:flutter/material.dart';
import 'package:iihs/screens/loading_screen.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  final String buttonimage;

  CategoryItem(this.id, this.title, this.color, this.buttonimage);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 10.0,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              buttonimage,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 35,
            right: 0,
            child: Container(
              width: 250,
              color: Colors.black54,
              padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 20,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline2,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Positioned.fill(
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(LoadingScreen.routeName);
                },
                splashColor: Color.fromRGBO(255, 255, 255, 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// InkWell(
//         onTap: () => selectCategory(context),
//         splashColor: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           padding: const EdgeInsets.all(15),
//           child: Text(
//             title,
//             style: Theme.of(context).textTheme.headline1,
//           ),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               image: NetworkImage(buttonimage),
//               fit: BoxFit.contain,
//               // colorFilter: ColorFilter.mode(
//               //     Colors.black.withOpacity(0.8), BlendMode.dstATop),
//             ),
// /*           gradient: LinearGradient(
//               colors: [
//                 color.withOpacity(1),
//                 color,
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ), */
//             //borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//       ),
