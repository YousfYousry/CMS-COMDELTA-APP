// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
// import 'package:upgrader/upgrader.dart';
//
// class NewUpdateChecker {
//   final context;
//
//   NewUpdateChecker(this.context) {
//     toast("launched");
//     // Instantiate NewVersion manager object (Using GCP Console app as example)
//     final newVersion = NewVersion(
//       iOSId: 'com.cmscomdelta.ssaol',
//       androidId: 'com.Comdelta.cms_comdelta',
//     );
//
//     // You can let the plugin handle fetching the status and showing a dialog,
//     // or you can fetch the status and display your own dialog, or no dialog.
//     // const simpleBehavior = true;
//
//     // if (simpleBehavior) {
//     //   basicStatusCheck(newVersion);
//     // } else {
//       advancedStatusCheck(newVersion);
//     // }
//   }
//
//   // basicStatusCheck(NewVersion newVersion) {
//   //   newVersion.showAlertIfNecessary(context: context);
//   // }
//
//   advancedStatusCheck(NewVersion newVersion) async {
//     final status = await newVersion.getVersionStatus();
//     if(status.canUpdate){
//       toast("can");
//     }else{
//       toast("cannot");
//     }
//     // if (status != null) {
//     //   debugPrint(status.releaseNotes);
//     //   debugPrint(status.appStoreLink);
//     //   debugPrint(status.localVersion);
//     //   debugPrint(status.storeVersion);
//     //   debugPrint(status.canUpdate.toString());
//       newVersion.showUpdateDialog(
//         context: context,
//         versionStatus: status,
//         dialogTitle: 'Custom Title',
//         dialogText: 'Custom Text',
//       );
//     // }
//   }
// }
