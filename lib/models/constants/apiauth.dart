// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

// Create a json web token
// final jwt = JWT(
//   {
//     ' User-Agent': 'MyAutoSafetyApp/v1',
//     'Pragma': 'no-cache',
//   },
//   issuer: 'api.iihs.org',
// );

// Sign it (default with HS256 algorithm)
// var token = jwt.sign(SecretKey(apiKey));

const iihsURL = 'https://www.iihs.org';
const iihsApiURL = 'https://api.iihs.org';
const apiKey = 'wWyy9pboIUa2zHyPhYPVKhjSHQoCDslFiNYlTF9VLSw';
const v4ratings = '/V4/ratings';
const v4mediaphoto = '/V4/media/photo';
const v4mediavideo = '/V4/media/video';
const v4mediaheadlightchart = '/v4/media/headlightchart';
