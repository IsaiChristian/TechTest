import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TtAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const TtAppBar({super.key , this.title});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/images/tt_ico.svg', height: 32),
            if(title != null) Text( title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: .left,),
          ],
        ),
      ),
    );
  }
}
