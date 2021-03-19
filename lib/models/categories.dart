import 'package:flutter/material.dart';

class Categories {
  final String id;
  final String title;
  final String buttonimage;

  Categories({
    @required this.id,
    @required this.title,
    @required this.buttonimage,
  });

  static List<Categories> maincategories = [
    Categories(
      id: 'c1',
      title: 'Vehicle Ratings',
      buttonimage: // 'http://www.engnear.com/img/portfolio/01-full.jpg'
          'https://www.iihs.org/media/653f765f-66cc-4df3-b92d-fa5b49e6555c/YIUE5w/Home/dummy-tsp2020.jpg',
    ),
    Categories(
      id: 'c2',
      title: 'Find your Vehicle Model',
      buttonimage:
          'https://www.iihs.org/media/3750e123-dbe4-4e00-8df2-8c4c054c7b60/5shZNw/Ratings/About%20our%20tests/BioRID.jpg',
    ),
    Categories(
      id: 'c3',
      title: 'Top Statistics',
      buttonimage:
          'https://www.iihs.org/media/e262cd2d-92d9-4322-b598-2f4994bd0cc6/NM5UaA/Ratings/About%20our%20tests/dummy-painting.jpg',
    ),
    Categories(
      id: 'c3',
      title: 'Crash Tests',
      buttonimage:
          'https://www.iihs.org/media/e262cd2d-92d9-4322-b598-2f4994bd0cc6/NM5UaA/Ratings/About%20our%20tests/dummy-painting.jpg',
    ),
  ];
}
