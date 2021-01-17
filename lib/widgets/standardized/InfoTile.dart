import 'package:budgetour/tools/GlobalValues.dart';
import 'package:flutter/material.dart';

import 'EnhancedListTile.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String infoText;
  final Color titleColor;
  final Color infoTextColor;
  final Function onTap;
  final EdgeInsets padding;

  const InfoTile({
    Key key,
    this.title,
    this.titleColor = Colors.white,
    this.infoText,
    this.infoTextColor = Colors.white,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: GlobalValues.defaultTilePadding,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Row(
          children: [
            // Builds leading
            Expanded(
              flex: 2,
              child: _buildLeading(),
            ),
            // Fills empty space inbetween leading and trailing
            Flexible(
              fit: FlexFit.tight,
              child: Container(),
            ),
            // Builds trailing
            Expanded(
              flex: 2,
              child: _buildTrailing(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        infoText != null
            ? Text(
                infoText,
                style: TextStyle(
                    color: infoTextColor, fontWeight: FontWeight.bold),
              )
            : Container(),
        Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
      ],
    );
  }

  Text _buildLeading() {
    return Text(
      title,
      style: TextStyle(
        color: titleColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// child: ListTile(
//   // backgroundColor: Colors.black,
//   // padding: const EdgeInsets.symmetric(horizontal: 16),

//   leading: Expanded(
//     flex: 2,
//     child: Container(
//       child: Text(
//         title,
//         style: TextStyle(
//           color: titleColor,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ),
//   trailing: Expanded(
//     flex: 2,
//     child: Row(
//       children: [
//         infoText != null
//             ? Text(
//                 infoText,
//                 style: TextStyle(
//                     color: infoTextColor, fontWeight: FontWeight.bold),
//               )
//             : Container(),
//         Icon(
//           Icons.more_vert,
//           color: Colors.white,
//         ),
//       ],
//     ),
//   ),
// ),
