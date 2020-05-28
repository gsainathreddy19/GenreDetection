
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'dart:async';


// Future<String> fetchdata(data) async
// {
//   final response =await http.get('http://127.0.0.1:5000/'+data);
//   //print(json.decode(response.body));
//   final String s = json.decode(response.body).toString();
//   print(s);
// }
Future<Genre> fetchAlbum(data) async 
{
  final response =await http.get('http://127.0.0.1:5000/'+data);
  if (response.statusCode == 200) 
  {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Genre.fromJson(json.decode(response.body));
  } 
  else 
  {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class Genre{
  final String genre;

  Genre({this.genre});

  factory Genre.fromJson(Map<String, dynamic> json) 
  {
    return Genre
    (
      genre: json['genre'],
    );
  }
}
class Http extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<Http>
{
  Future<Genre> futuregenre;
  final myController = TextEditingController();
  @override
  void dispose() 
  {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) 
  {
    // Fill this out in the next step.
    return new  MaterialApp
    (
      home : Scaffold
      (
        appBar: AppBar
        (
          title: Text('give genre of book'),
        ),
        body: new Container
        (
          padding: EdgeInsets.all(80),
          alignment: Alignment.center,
          margin: EdgeInsets.all(80),
          decoration: BoxDecoration
          (
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: 
            [
              BoxShadow
              (
                  color: Colors.blue,
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: new Column
          (
            children :
            [
              new SizedBox
              (
                  height: 60,
                  width: 300,
              ),
              new Container
              ( 
                child : TextField
                (
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
                  controller: myController,

                  //cursor
                  cursorColor: Colors.blue,
                  cursorRadius: Radius.circular(16.0),
                  cursorWidth: 6.0,

                  decoration: InputDecoration
                  (
                    //icon: Icon(Icons.print),
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(),
                    //hintText: 'Enter a book name',
                    labelText: 'Enter a book name'
                  ),
                ),
              ),
              new SizedBox
              (
                  height: 20,
                  width: 300,
              ),
              new Container
              (
                child :IconButton
                (
                  icon: Icon
                  (
                    Icons.search,
                    size: 70,
                    color: Colors.blue,
                  ),
                  onPressed: () 
                  {
                    futuregenre = fetchAlbum(myController.text);
                    Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (
                        builder: (context) => ThirdWidget(futuregenre: futuregenre,),
                      ),
                    );
                  } 
                )        
              ),  
            ]
          )
        )
      )
    ); 
  }

}

class ThirdWidget extends StatelessWidget 
{ 
  Future<Genre> futuregenre;
  ThirdWidget({Key key, @required this.futuregenre}) : super(key: key);
  @override
  Widget build(BuildContext ctxt) 
  {
    return new MaterialApp
    (
      home : Scaffold
      (
          appBar: AppBar
          (
              title: Text('Genre'),
          ),

          body : new Container
          (
            padding: EdgeInsets.all(80),
            alignment: Alignment.center,
            margin: EdgeInsets.all(60),
            decoration: BoxDecoration
            (
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: 
              [
                BoxShadow
                (
                    color: Colors.blue,
                    blurRadius: 3.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child : new Column
            (
                children: 
                [
                  new Container
                  (
                    constraints: BoxConstraints.expand
                    (
                      height: Theme.of(ctxt).textTheme.headline4.fontSize * 1.1 + 130.0,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.blue[600],
                    //alignment: Alignment.center,
                    child: FutureBuilder<Genre>
                    (
                      future: futuregenre,
                      builder: (context, snapshot) 
                      {
                          if (snapshot.hasData) 
                          {
                            print(snapshot.data.genre+'hfjh');
                            return Text
                            (
                              snapshot.data.genre,
                              style: TextStyle
                              (
                                color: Colors.white,
                                fontSize: 30,
                                //fontStyle: FontStyle.italic

                              )
                              
                            );
                          } 
                          else if (snapshot.hasError) 
                          {
                            return Text("${snapshot.error}");
                          }
                      //print(snapshot.data);
                      return CircularProgressIndicator();
                      },
                      //transform: Matrix4.rotationZ(0.1)
                    ),

                  ),
                  new Container
                  (
                    child: SizedBox
                    (
                      height: 40,
                      width: 300,
                    ),
                  ),
                  new Container
                  (
                    child :IconButton
                    (
                      icon: Icon
                      (
                        Icons.arrow_back
                      ),
                      onPressed: () 
                      {
                        Navigator.push
                        (
                          ctxt,
                          MaterialPageRoute
                          (
                            builder: (context) => Http(),
                          ),
                        );
                      }   
                    )
                  ),
                ],
            )
          )
      )
    );     
  }
}