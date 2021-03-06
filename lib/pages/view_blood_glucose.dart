import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_medical_journal/controller/bg_controller.dart';
import 'package:my_medical_journal/entities/bloodGlucose.dart';
import 'package:my_medical_journal/pages/add_blood_glucose.dart';
import '../pages/list_health_vitals.dart';

class ViewBloodGlucose extends StatefulWidget{
  ViewBloodGlucose({Key key, this.generatedId}) : super(key: key);
  final String generatedId;
  @override
  State createState() => new ViewBloodGlucoseState(generatedId);
}


class ViewBloodGlucoseState extends State<ViewBloodGlucose>{
  String generatedId;
  static List<Widget> listItems = [];
  ViewBloodGlucoseState(this.generatedId);
  BloodGlucose bg = new BloodGlucose.defaults();
  BgController bgController = new BgController();

  void addToBgObserver() async{
   bgController.addBgObserver((List<BloodGlucose> bgList){
     updateBgItems(bgList);
   });
 } 

  void updateBgItems(List<BloodGlucose> bgList){
    setState(() {
        listItems = [];
      });
    for(var bg in bgList){
      setState(() {
        listItems.add(createBgCard(bg,context));
      });
    }
  }

  void retrieveBgUpdate() async{
    List<BloodGlucose> bgList = await bgController.listBg();
    updateBgItems(bgList);
  }

  Widget createBgCard(BloodGlucose bg, dynamic context){
        Widget glucose = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Text(bg.glucose, style:TextStyle(fontSize:30, fontWeight: FontWeight.bold,),),
        ],
      ),
    );
    Widget date = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(bg.date, style:TextStyle(fontSize:25, fontWeight: FontWeight.bold,),),
          Text(bg.time, style:TextStyle(fontSize:25, fontWeight: FontWeight.bold,),),
        ],
      ),
      );
    return new Center(
      child: new Container(
        color: Colors.green,
        height: 85.0,
        child: new Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
          splashColor: Colors.green.withAlpha(100),
          onTap:(){
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new ViewBloodGlucose(generatedId: bg.getId())
              )
            );  
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              date,
              glucose,
            ],)
        ),
        ),
        ),
      ),
    );
  }
  @override
  void initState(){
    super.initState();
    retrieveBgUpdate();
    addToBgObserver();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        flexibleSpace: new Container(
          alignment: Alignment.center,
          child: new Divider(
            color: Colors.white,
            thickness: 2,
          ),
        ),
        bottom: PreferredSize(
            child: new Container(), preferredSize: Size(100, 100)),
        title: new Row(
          children: <Widget>[
            new IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new HealthVitalsPage())),
            ),
            new Text(
              "Blood Glucose",
              style: new TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: 'OpenSans'),
            ),
          ],
        ),
      ),
      body: new Column(
          children:<Widget>[
            Container(
              height: 45.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    width: 220.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Date", style:TextStyle(fontSize:20, fontWeight: FontWeight.bold,),),
                        Text("Time", style:TextStyle(fontSize:15, fontWeight: FontWeight.bold,),),
                      ],
                    ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.0),
                      width: 160.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Glucose",style:TextStyle(fontSize:18, fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ),
                ]
              ),
            ),
            new Expanded(
              child: new ListView.builder(
                itemCount: listItems.length, // list.length to display all data
                itemBuilder: (context,index){
                  return listItems[index];
              }), 
              ),
          ],
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push( MaterialPageRoute(
            builder: (BuildContext context) => AddBloodGlucose())),
        tooltip: 'Increment Counter',
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}