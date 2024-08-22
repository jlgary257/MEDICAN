
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class SystemDataV extends StatelessWidget {
  const SystemDataV({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Medican'),
      body: GridView.count(
        crossAxisCount: 2,children: [
          Container(color: Colors.redAccent,)
      ],
      )
    );
  }
}
