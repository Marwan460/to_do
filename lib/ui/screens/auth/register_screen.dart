import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/user_dm.dart';
import 'package:todo/ui/screens/home/home.dart';
import 'package:todo/ui/utils/constant.dart';
import 'package:todo/ui/utils/dialog_utils.dart';

import '../../utils/app_style.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "registerScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userName = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: AppStyle.appBarStyle,
        ),
        elevation: 0,
      ),
      body: buildRegisterScreenBody(),
    );
  }

  buildRegisterScreenBody() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .25),
            TextFormField(
              onChanged: (text) {
                userName = text;
              },
              decoration: const InputDecoration(
                label: Text("User name"),
              ),
            ),
            const SizedBox(height: 8),
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
            SizedBox(height: MediaQuery.of(context).size.height * .20),
            ElevatedButton(
                onPressed: () {
                  signUp();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    children: [
                      Text("Create account"),
                      Spacer(),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                )),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  void signUp() async {
    try {
      showLoading(context);
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserDM.currentUser = UserDM(
          userId: credential.user!.uid, email: email, userName: userName);
      registerUserInFireStore(UserDM.currentUser!);
      if (context.mounted) {
        hideLoading(context);
        Navigator.pushNamed(context, Home.routeName);
      }
    } on FirebaseAuthException catch (authError) {
      String message;
      if (authError.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (authError.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = Constant.defaultErrorMessage;
      }
      if (context.mounted) {
        hideLoading(context);
        showMessage(context,
            title: "Error", body: message, posButtonTitle: "Ok");
      }
    } catch (e) {
      if (context.mounted) {
        hideLoading(context);
        showMessage(context,
            title: "Error",
            body: Constant.defaultErrorMessage,
            posButtonTitle: "Ok");
      }
    }
  }

  void registerUserInFireStore(UserDM user) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(UserDM.collectionName);
    DocumentReference userDoc = collectionReference.doc(user.userId);
    await userDoc.set(user.toJson());
  }
}
