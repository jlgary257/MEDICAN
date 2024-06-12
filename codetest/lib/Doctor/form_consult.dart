

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/user_auth/presentation/pages/login_page.dart';
import '../features/user_auth/presentation/widgets/form_container_widget.dart';
import '../global/toast.dart';

class DrForm extends StatefulWidget {
  const DrForm({super.key});

  @override
  State<DrForm> createState() => _drFormState();
}

class _drFormState extends State<DrForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Dr",),
      body: Column(

      ),
    );
  }
}
