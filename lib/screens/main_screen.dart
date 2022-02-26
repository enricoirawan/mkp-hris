import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/screens/screens.dart';
import 'package:mkp_hris/utils/theme.dart';

import '../utils/lib.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final BottomNavCubit _bottomNavCubit = getIt<BottomNavCubit>();
  final List<IconData> _iconList = [Icons.home, Icons.account_circle];

  void _changeSelectedNavBar(int index) {
    _bottomNavCubit.changePage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavCubit, int>(builder: (context, state) {
        if (state == 0) {
          return const HomeScreen();
        } else if (state == 1) {
          return AccountScreen();
        } else if (state == 2) {
          return const AbsenScreen();
        }

        return const HomeScreen();
      }), //destination screen
      floatingActionButton: BlocBuilder<BottomNavCubit, int>(
        builder: (context, state) => FloatingActionButton(
          onPressed: () {
            _changeSelectedNavBar(2);
          },
          backgroundColor: state == 2 ? kPrimaryColor : kGreyColor,
          child: const Icon(Icons.schedule),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
        builder: (context, state) => AnimatedBottomNavigationBar.builder(
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? kPrimaryColor : kGreyColor;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _iconList[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    index == 1 ? "Akun" : "Home",
                    maxLines: 1,
                    style: isActive
                        ? primaryTextStyle.copyWith(
                            letterSpacing: 1,
                          )
                        : greyTextStyle.copyWith(
                            letterSpacing: 1,
                          ),
                  ),
                )
              ],
            );
          },
          elevation: 20,
          activeIndex: state,
          itemCount: _iconList.length,
          onTap: _changeSelectedNavBar,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          // backgroundColor: kPrimaryColor,
        ),
      ),
    );
  }
}
