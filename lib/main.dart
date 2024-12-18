import 'package:flutter/material.dart';
import 'package:projek_bounty_hunter/screens/Home.dart';
import 'package:projek_bounty_hunter/screens/Favorite.dart';
import 'package:projek_bounty_hunter/screens/Profile.dart';
import 'package:projek_bounty_hunter/screens/Report.dart';
import 'package:projek_bounty_hunter/screens/SignIn.dart';
import 'package:projek_bounty_hunter/screens/SignUp.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:   FlutterSplashScreen.fadeIn(
          backgroundColor: const Color.fromRGBO(
          255, 248, 242, 1),
          childWidget: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset("images/Logo MDP.jpeg"),
          ),
          
          nextScreen: const MainScreen(),
        ),
      initialRoute: '/',
      routes: {
        '/mainscreen': (context) => const MainScreen(),
        '/homescreen': (context) => const HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 10,
              blurRadius: 7,
              offset: const Offset(0,3),
            ),
          ],
        ),
        child: BottomBarBubble(
          backgroundColor: const Color.fromRGBO(240, 238, 225, 1),
          selectedIndex: 0,
          color: Colors.black,
          height: 60,
          items: [
            BottomBarItem(
              iconData: Icons.home,
              // label: 'Home',
            ),
            BottomBarItem(
              iconData: Icons.description,
              // label: 'Chat',
            ),
            BottomBarItem(
              iconData: Icons.star,
              // label: 'Notification',
            ),
            BottomBarItem(
              iconData: Icons.person,
              // label: 'Calendar',
            ),
          ],
          onSelect: (index) {
            // implement your select function here
            controller.jumpToPage(index);
          },
        ),
      ),
      body: PageView(
        controller: controller,
        children: <Widget>[
          const Center(
            child: HomeScreen(),
          ),
          const Center(
            child: ReportScreen(),
          ),
          Center(
            child: FavoriteScreen(),
          ),
          const Center(
            child: ProfileScreen(),
          ),
        ],
      ),
            );
  }
}
