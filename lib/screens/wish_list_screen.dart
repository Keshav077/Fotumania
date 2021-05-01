// import 'package:flutter/material.dart';
// import 'package:fotumania/models/item_data.dart';
// import 'package:fotumania/providers/items_provider.dart';
// import 'package:fotumania/providers/user_provider.dart';
// import 'package:provider/provider.dart';

// import 'service_details_screen.dart';

// class WishList extends StatefulWidget {
//   static String routeName = "/wishList";
//   @override
//   _WishListState createState() => _WishListState();
// }

// class _WishListState extends State<WishList> {
//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = Provider.of<UserProvider>(context);
//     ItemProvider itemProvider = Provider.of<ItemProvider>(context);
//     List<ItemData> userWishList =
//         userProvider.getWishListItemData(itemProvider.itemsList);
//     final mqs = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         margin: EdgeInsets.all(mqs.height * 0.05),
//         alignment: Alignment.center,
//         child: ListView(
//           children: [
//             Text(
//               "Your Wish list",
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             ...userWishList
//                 .map(
//                   (e) => Card(
//                     child: ListTile(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (ctx) => ServiceDetails(e),
//                           ),
//                         );
//                       },
//                       title: Text(e.name),
//                       trailing: InkWell(
//                         onTap: () {
//                           setState(() {
//                             userProvider.removeItemFromWishList(e.itemId);
//                           });
//                         },
//                         child: Icon(Icons.delete),
//                       ),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
