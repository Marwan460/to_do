import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/user_dm.dart';
import 'package:todo/ui/screens/auth/register_screen.dart';
import 'package:todo/ui/utils/app_style.dart';
import 'package:todo/ui/utils/dialog_utils.dart';

import '../../utils/constant.dart';
import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "loginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login", style: AppStyle.appBarStyle),
        elevation: 0,
      ),
      body: buildLoginScreenBody(),
    );
  }

  buildLoginScreenBody() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .25),
            Text("Welcome back !",
                style: AppStyle.titlesTextStyle.copyWith(color: Colors.black)),
            TextFormField(
              onChanged: (text) {
                email = text;
              },
              decoration: const InputDecoration(
                label: Text("Email"),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              onChanged: (text) {
                password = text;
              },
              decoration: const InputDecoration(
                label: Text("Password"),
              ),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
                onPressed: () {
                  signIn();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    children: [
                      Text("Login"),
                      Spacer(),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                )),
            const SizedBox(height: 18),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                },
                child: const Text("Create account")),
          ],
        ),
      ),
    );
  }

  signIn() async {
    try {
      showLoading(context);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      UserDM.currentUser = await getUserFromFireStore(credential.user!.uid);
      if (context.mounted) {
        hideLoading(context);
        Navigator.pushNamed(context, Home.routeName);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }else {
        message = Constant.defaultErrorMessage;
      }
      if (context.mounted) {
        hideLoading(context);
        showMessage(context,
            title: "Error", body: message, posButtonTitle: "ok");
      }
    } catch (e) {
      if (context.mounted) {
        hideLoading(context);
        showMessage(context,
            title: "Error",
            body: Constant.defaultErrorMessage,
            posButtonTitle: "ok");
      }
    }
  }
  Future<UserDM> getUserFromFireStore(String id) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(UserDM.collectionName);
    DocumentReference userDoc = collectionReference.doc(id);
    DocumentSnapshot userSnapshot = await userDoc.get();
    return UserDM.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }
}
