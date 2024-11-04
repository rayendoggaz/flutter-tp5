import 'package:flutter/material.dart';
import '../util/dbuse.dart';
import '../models/scol_list.dart';

class ScolListDialog {
  final txtNomClass = TextEditingController();
  final txtNbreEtud = TextEditingController();

  Widget buildDialog(BuildContext context, ScolList list, bool isNew) {
    dbuse helper = dbuse();

    if (!isNew) {
      txtNomClass.text = list.nomClass;
      txtNbreEtud.text = list.nbreEtud.toString();
    } else {
      txtNomClass.clear();
      txtNbreEtud.clear();
    }

    return AlertDialog(
      title: Text(isNew ? 'New Class' : 'Edit Class'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: txtNomClass,
            decoration: InputDecoration(hintText: 'Class Name'),
          ),
          TextField(
            controller: txtNbreEtud,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Number of Students'),
          ),
          ElevatedButton(
            child: Text('Save Class'),
            onPressed: () {
              if (txtNomClass.text.isEmpty || txtNbreEtud.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }
              list.nomClass = txtNomClass.text;
              list.nbreEtud = int.parse(txtNbreEtud.text);
              helper.insertClass(list);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}