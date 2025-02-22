import 'package:flutter/material.dart';
import 'package:phone_book/generated/l10n.dart';
import '../viewmodels/navigation_view_model.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);

    final List<Widget> iconOutline = [
      const Icon(Icons.star_border),
      const Icon(Icons.access_time),
      const Icon(Icons.group_outlined, size: 28)
    ];

    final List<Widget> iconFilled = [
      const Icon(Icons.star),
      const Icon(Icons.access_time_filled),
      const Icon(Icons.group, size: 28)
    ];

    List<Widget> iconsToShow = List.from(iconOutline);
    iconsToShow[navigationViewModel.currentIndexPage] =
        iconFilled[navigationViewModel.currentIndexPage];

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            label: S.of(context).favourites, icon: iconsToShow[0]),
        BottomNavigationBarItem(
            label: S.of(context).recents, icon: iconsToShow[1]),
        BottomNavigationBarItem(
            label: S.of(context).contacts, icon: iconsToShow[2]),
      ],
      currentIndex: navigationViewModel.currentIndexPage,
      onTap: (value) {
        navigationViewModel.updateIndex(value);
      },
    );
  }
}
