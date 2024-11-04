import 'package:flutter/material.dart';
import '../models/list_etudiants.dart';
import '../util/dbuse.dart';

class ListStudentDialog {
  final txtNom = TextEditingController();
  final txtPrenom = TextEditingController();
  final txtDatNais = TextEditingController();

  Widget buildDialog(BuildContext context, ListEtudiants student, bool isNew) {
    dbuse helper = dbuse();

    if (!isNew) {
      txtNom.text = student.nom;
      txtPrenom.text = student.prenom;
      txtDatNais.text = student.datNais;
    } else {
      txtNom.clear();
      txtPrenom.clear();
      txtDatNais.clear();
    }

    return AlertDialog(
      title: Text(isNew ? 'New Student' : 'Edit Student'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtNom,
              decoration: InputDecoration(hintText: 'Student Last Name'),
            ),
            TextField(
              controller: txtPrenom,
              decoration: InputDecoration(hintText: 'Student First Name'),
            ),
            TextField(
              controller: txtDatNais,
              decoration: InputDecoration(hintText: 'Date of Birth (dd-mm-yyyy)'),
            ),
            ElevatedButton(
              child: Text(isNew ? 'Add Student' : 'Update Student'),
              onPressed: () {
                if (txtNom.text.isEmpty || txtPrenom.text.isEmpty || txtDatNais.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                student.nom = txtNom.text;
                student.prenom = txtPrenom.text;
                student.datNais = txtDatNais.text;

                if (isNew) {
                  helper.insertEtudiant(student);
                } else {
                  helper.updateEtudiant(student);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

