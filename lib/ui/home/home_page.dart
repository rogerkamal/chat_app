import 'package:chat_app/domain/utils/app_routes.dart';
import 'package:chat_app/ui/contacts/contacts_page.dart';
import 'package:chat_app/ui/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) async {
              if (value == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }

              if (value == 2) {
                /// Logout logic
                SharedPreferences? prefs =
                    await SharedPreferences.getInstance();
                // prefs.remove(AppConstants.prefUserIdKey);
                Navigator.pushReplacementNamed(context, AppRoutes.signin);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Logged out !")));
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<int>(
                    value: 1,
                    enabled: false, // disable default tap
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*isDarkTheme
                        ? Text(
                      "Dark Theme",
                      style: TextStyle(color: Colors.white),
                    )
                        : Text(
                      "Dark Theme",
                      style: TextStyle(color: Colors.black),
                    ),
                    Switch(
                      value: isDarkTheme,
                      onChanged: (val) {
                        context.read<ThemeProvider>().isDarkTheme = val;
                        Navigator.pop(context); // close popup
                      },
                    ),*/
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Text("Logout"),
                        SizedBox(width: 10),
                        Icon(Icons.logout, weight: 20),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      children: [
                        Text("Settings"),
                        SizedBox(width: 10),
                        Icon(Icons.settings),
                      ],
                    ),
                  ),
                ],
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Messages")],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactsPage()),
          );
        },
        child: Icon(Icons.add,color: Colors.orange,),
      ),
    );
  }
}
