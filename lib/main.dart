import 'package:flutter/material.dart';
import 'models/scol_list.dart';
import 'util/dbuse.dart';
import 'ui/scol_list_dialog.dart';
import 'ui/students_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ScolList> scolList = [];
  dbuse helper = dbuse();

  @override
  void initState() {
    super.initState();
    showData();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(title: Text('Class List')),
      body: ListView.builder(
        itemCount: scolList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentsScreen(scolList[index]),
                ),
              );
            },
            title: Text(scolList[index].nomClass),
            leading: CircleAvatar(
              child: Text(scolList[index].codClass.toString()),
            ),
            trailing: Icon(Icons.edit),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showClassDialog(context, ScolList(0, '', 0), true); // New class dialog
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    scolList = await helper.getClasses();
    setState(() {});
  }

  // Function to show the dialog
  void _showClassDialog(BuildContext context, ScolList classItem, bool isNew) {
    ScolListDialog dialog = ScolListDialog();
    showDialog(
      context: context,
      builder: (BuildContext context) => dialog.buildDialog(context, classItem, isNew),
    ).then((_) {
      // Refresh data after the dialog is closed
      showData();
    });
  }
}
