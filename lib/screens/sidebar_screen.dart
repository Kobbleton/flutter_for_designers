import 'package:flutter/material.dart';

import '../components/sidebar_row.dart';
import '../constants.dart';
import '../model/sidebar.dart';

class SidebarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kSidebarBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(34),
        ),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/portrait small_cr.jpg'),
                  radius: 21,
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vitaly Shastun',
                      style: kHeadlineLabelStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text('License ends on 21 Jan 2023')
                  ],
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            SidebarRow(item: sidebarItem[0]),
            const SizedBox(height: 32),
            SidebarRow(item: sidebarItem[1]),
            const SizedBox(height: 32),
            SidebarRow(item: sidebarItem[2]),
            const SizedBox(height: 32),
            SidebarRow(item: sidebarItem[3]),
            const SizedBox(height: 32),
            const Spacer(),
            Row(
              children: [
                Image.asset(
                  'assets/icons/icon-logout.png',
                  width: 18,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  'Logout',
                  style: kSecondaryCalloutLabelStyle,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
