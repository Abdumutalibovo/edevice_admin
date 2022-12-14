import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edevice_admin/data/repositories/order_repository.dart';
import 'package:edevice_admin/data/repositories/profile_repository.dart';
import 'package:edevice_admin/presentation/admin/admin_screen.dart';
import 'package:edevice_admin/presentation/auth/auth_page.dart';
import 'package:edevice_admin/view_model/auth_view_model.dart';
import 'package:edevice_admin/view_model/categories_view_model.dart';
import 'package:edevice_admin/view_model/orders_view_model.dart';
import 'package:edevice_admin/view_model/products_view_model.dart';
import 'package:edevice_admin/view_model/profile_view_model.dart';
import 'package:edevice_admin/view_model/tab_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/categories_repository.dart';
import 'data/repositories/product_repository.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  // await Firebase.initializeApp();
  print("Handling a background message : ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  var fireStore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductViewModel(
            productRepository: ProductRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) => CategoriesViewModel(
                categoryRepository:
                    CategoryRepository(firebaseFirestore: fireStore))),
        ChangeNotifierProvider(
            create: (context) => OrdersViewModel(
                ordersRepository:
                    OrdersRepository(firebaseFirestore: fireStore))),
        Provider(
            create: (context) => AuthViewModel(
                    authRepository: AuthRepository(
                  firebaseAuth: FirebaseAuth.instance,
                ))),
        ChangeNotifierProvider(create: (context) => TabViewModel()),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
              firebaseAuth: FirebaseAuth.instance,
              profileRepository: ProfileRepository(firebaseFirestore: fireStore)
          ),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminScreen(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return const AdminScreen();
        } else {
          print(snapshot.error);
          return const AuthPage();
        }
      },
    );
  }
}
