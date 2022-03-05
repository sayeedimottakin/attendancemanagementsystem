
import 'package:flutter/material.dart';

class TestApp extends StatefulWidget {
  static String id = 'test';
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  List<int> val = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // shrinkWrap: true,
          children: [
            TextButton(
                onPressed: (){
                  setState(() {
                    val = List.filled(15, 10);
                  });
                },
                child: Text('Press')),
            val.isNotEmpty?
            ListView.builder(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: val.length,
                  itemBuilder: (context, index){
                    return CheckboxListTile(
                        title: Text('$val[index]'),
                        value: false,
                        onChanged: (val){

                        });
                  }):Text("Loading"),
            TextButton(onPressed: null, child: Text('save'))
          ],
        ),
      ),
    );
  }
}
