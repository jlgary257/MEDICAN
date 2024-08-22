
import 'package:codetest/data_visual/SystemDV.dart';
import 'package:codetest/data_visual/yearCases.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import'package:flutter/material.dart';

class MainBi extends StatefulWidget {
  const MainBi({super.key});

  @override
  State<MainBi> createState() => _MainBiState();
}

class _MainBiState extends State<MainBi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Admin"),
      body: Padding(
        padding: const EdgeInsets.symmetric(),
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Data Visualization and BI", style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 30),),
              SizedBox(width: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    RedBigButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SystemDataV()),
                        );
                      },
                      text: "Main Analytics",
                    ),
                    SizedBox(width: 10,),
                    RedBigButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TraumaCase()),
                        );
                      },
                      text: "Cases Analytics",
                    ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
