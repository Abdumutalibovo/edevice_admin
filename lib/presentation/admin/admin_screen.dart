import 'package:edevice_admin/presentation/admin/products/all_products_screen.dart';
import 'package:edevice_admin/presentation/chat/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'category/all_category_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  _printFirebaseCloudMessagingToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN : $token");
  }

  _handleFirebaseNotificationMessage() async {
    //Forgrounddan kelgan messagelarni tutib olamiz!
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foregroundda message ushladim");
      print("Message data : ${message.data}");

      if (message.notification != null) {
        print("NATIFICATION BOR: ${message.notification}");
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
  }

  _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    //Terminateddan kirganda bu ishlaydi
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    //Backgrounddan kirganda  shu ishlaydi
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ));
    }
  }

  @override
  void initState() {
    _printFirebaseCloudMessagingToken();
    _handleFirebaseNotificationMessage();
    _setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Page",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCategoriesScreen()),
              );
            },
            title: const Text("Categories"),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllProductsScreen()),
              );
            },
            title: Text("Products"),
          )
        ],
      ),
    );
  }
}
