import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

// import 'JasonHolders/RemoteApi.dart';

// const PrimaryColor = const Color(0xff0065a3);

List<S2Choice<String>> clientStatus = [
  S2Choice<String>(value: 'Hidden', title: 'Hidden'),
  S2Choice<String>(value: 'Shown', title: 'Shown'),
];

List<S2Choice<String>> client = [
  S2Choice<String>(value: 'DHarmoni', title: 'DHarmoni'),
  S2Choice<String>(value: 'Digi', title: 'Digi'),
  S2Choice<String>(value: 'Sacofa', title: 'Sacofa'),
  S2Choice<String>(value: 'U Mobile', title: 'U Mobile'),
  S2Choice<String>(value: 'EDOTCO', title: 'EDOTCO'),
  S2Choice<String>(value: 'Maxis', title: 'Maxis'),
  S2Choice<String>(value: 'Red One', title: 'Red One'),
  S2Choice<String>(value: 'xenox', title: 'xenox'),
  S2Choice<String>(value: 'sampugita', title: 'sampugita'),
  S2Choice<String>(
      value: 'Research & Development Department',
      title: 'Research & Development Department'),
  S2Choice<String>(
      value: 'Comdelta Technologies', title: 'Comdelta Technologies'),
  S2Choice<String>(value: 'Test Log', title: 'Test Log'),
  S2Choice<String>(value: 'YTL', title: 'YTL'),
  S2Choice<String>(value: 'Telekom', title: 'Telekom'),
  S2Choice<String>(value: 'Bullish Aim', title: 'Bullish Aim'),
  S2Choice<String>(value: 'Comdelta Test', title: 'Comdelta Test'),
];
// List<S2Choice<String>> client;

// List<S2Choice<String>> clientCompressed = [
//   S2Choice<String>(value: 'DHarmoni', title: 'DHarmoni'),
//   S2Choice<String>(value: 'Digi', title: 'Digi'),
//   S2Choice<String>(value: 'Sacofa', title: 'Sacofa'),
//   S2Choice<String>(value: 'U Mobile', title: 'U Mobile'),
//   S2Choice<String>(value: 'EDOTCO', title: 'EDOTCO'),
//   S2Choice<String>(value: 'Maxis', title: 'Maxis'),
//   S2Choice<String>(value: 'Red One', title: 'Red One'),
//   S2Choice<String>(value: 'xenox', title: 'xenox'),
//   S2Choice<String>(value: 'sampugita', title: 'sampugita'),
//   S2Choice<String>(
//       value: 'R&D',
//       title: 'R&D'),
//   S2Choice<String>(
//       value: 'Comdelta', title: 'Comdelta'),
//   S2Choice<String>(value: 'Test Log', title: 'Test Log'),
//   S2Choice<String>(value: 'YTL', title: 'YTL'),
//   S2Choice<String>(value: 'Telekom', title: 'Telekom'),
//   S2Choice<String>(value: 'Bullish Aim', title: 'Bullish Aim'),
//   S2Choice<String>(value: 'Comdelta Test', title: 'Comdelta Test'),
// ];

List<S2Choice<String>> location = [
  S2Choice<String>(value: 'Kuala Lumpur', title: 'Kuala Lumpur'),
  S2Choice<String>(value: 'Labuan', title: 'Labuan'),
  S2Choice<String>(value: 'Putrajaya', title: 'Putrajaya'),
  S2Choice<String>(value: 'Johor', title: 'Johor'),
  S2Choice<String>(value: 'Kedah', title: 'Kedah'),
  S2Choice<String>(value: 'Kelantan', title: 'Kelantan'),
  S2Choice<String>(value: 'Melaka', title: 'Melaka'),
  S2Choice<String>(value: 'Negeri Sembilan', title: 'Negeri Sembilan'),
  S2Choice<String>(value: 'pahang', title: 'pahang'),
  S2Choice<String>(value: 'Perak', title: 'Perak'),
  S2Choice<String>(value: 'Perlis', title: 'Perlis'),
  S2Choice<String>(value: 'Pulau Pinang', title: 'Pulau Pinang'),
  S2Choice<String>(value: 'Sabah', title: 'Sabah'),
  S2Choice<String>(value: 'Sarawak', title: 'Sarawak'),
  S2Choice<String>(value: 'Selangor', title: 'Selangor'),
  S2Choice<String>(value: 'Terengganu', title: 'Terengganu'),
];

List<S2Choice<String>> height = [
  S2Choice<String>(value: 'Below 45m', title: 'Below 45m'),
  S2Choice<String>(value: 'Above 45m', title: 'Above 45m'),
];

List<S2Choice<String>> siteRegion = [
  S2Choice<String>(value: 'Eastern', title: 'Eastern'),
  S2Choice<String>(value: 'Central', title: 'Central'),
  S2Choice<String>(value: 'Northern', title: 'Northern'),
  S2Choice<String>(value: 'Southern', title: 'Southern'),
  S2Choice<String>(value: 'Malaysia East', title: 'Malaysia East'),
];

List<S2Choice<String>> simCardProvider = [
  S2Choice<String>(value: 'Celcom', title: 'Celcom'),
  S2Choice<String>(value: 'Maxis', title: 'Maxis'),
  S2Choice<String>(value: 'Things Mobile', title: 'Things Mobile'),
];

List<S2Choice<String>> status = [
  S2Choice<String>(value: 'Inactive', title: 'Inactive'),
  S2Choice<String>(value: 'Active', title: 'Active'),
];

Map<int, Color> customColors = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
