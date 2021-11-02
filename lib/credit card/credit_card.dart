import 'package:flutter/material.dart';
import '../main.dart';

class CrediteCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CrediteCardState();
}

class _CrediteCardState extends State<CrediteCard>{

  @override
  Widget build(BuildContext context) => Scaffold(

    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(
            "Payment method",
            style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 1.0,
                ),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Card number",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),  TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "MM/YY",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "CVC",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Cardholder name",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),  TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Address Line",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),  TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Town / City",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "postcode",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  height: 20.0,
                ),

                RaisedButton(
                  color: Colors.yellow,
                  textColor: Colors.white,
                  onPressed: () {  },
                  child: Container(
                    height: 50.0,

                    child: Center(
                      child: Text(
                        "save",
                        style: TextStyle(
                            fontSize: 18.0, fontFamily: "Brand Bold"),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    ),
  );


}