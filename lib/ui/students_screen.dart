import 'package:flutter/material.dart';
import '../models/list_etudiants.dart';
import '../models/scol_list.dart';
import '../util/dbuse.dart';
import 'list_student_dialog.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;
  StudentsScreen(this.scolList);

  @override
  _StudentsScreenState createState() => _StudentsScreenState(this.scolList);
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScolList scolList;
  dbuse helper = dbuse();
  List<ListEtudiants> students = [];

  _StudentsScreenState(this.scolList);

  @override
  Widget build(BuildContext context) {
    showData(scolList.codClass);

    return Scaffold(
      appBar: AppBar(title: Text(scolList.nomClass)),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(students[index].nom),
            subtitle: Text('Prenom: ${students[index].prenom} - Date Nais: ${students[index].datNais}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showStudentDialog(context, students[index], false); // Show dialog for editing student
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showStudentDialog(context, ListEtudiants(0, scolList.codClass, '', '', ''), true); // Show dialog for adding new student
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future showData(int codClass) async {
    await helper.openDb();
    students = await helper.getEtudiants(codClass);
    setState(() {});
  }

  // Function to show the dialog
  void _showStudentDialog(BuildContext context, ListEtudiants student, bool isNew) {
    ListStudentDialog dialog = ListStudentDialog();
    showDialog(
      context: context,
      builder: (BuildContext context) => dialog.buildDialog(context, student, isNew),
    ).then((_) {
      // Refresh data after the dialog is closed
      showData(scolList.codClass);
    });
  }
}
