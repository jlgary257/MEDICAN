




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/user_auth/presentation/pages/login_page.dart';
import '../features/user_auth/presentation/widgets/form_container_widget.dart';
import '../global/toast.dart';

class homeDoctor extends StatefulWidget {
  const homeDoctor({super.key});

  @override
  State<homeDoctor> createState() => _homeDoctorState();
}

class _homeDoctorState extends State<homeDoctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Doctor",),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ Center(
          child: Text("Welcome Dr."),
        )
          
        ],
      ),
    );
  }
}
