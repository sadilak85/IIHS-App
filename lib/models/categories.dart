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
      buttonimage:
          'https://www.iihs.org/media/653f765f-66cc-4df3-b92d-fa5b49e6555c/YIUE5w/Home/dummy-tsp2020.jpg',
    ),
    Categories(
      id: 'c2',
      title: 'Award Winners',
      buttonimage:
          'https://www.iihs.org/media/653f765f-66cc-4df3-b92d-fa5b49e6555c/YIUE5w/Home/dummy-tsp2020.jpg',
    ),
    Categories(
      id: 'c3',
      title: 'Find my Vehicle first',
      buttonimage:
          'https://www.iihs.org/media/3750e123-dbe4-4e00-8df2-8c4c054c7b60/5shZNw/Ratings/About%20our%20tests/BioRID.jpg',
    ),
    Categories(
      id: 'c4',
      title: 'About our Crash Tests',
      buttonimage:
          'https://www.iihs.org/media/653f765f-66cc-4df3-b92d-fa5b49e6555c/YIUE5w/Home/dummy-tsp2020.jpg',
    ),
  ];
}
