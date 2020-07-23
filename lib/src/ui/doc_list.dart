import 'package:doctracking/src/bloc/doc_firestore_bloc.dart';
import 'package:doctracking/src/bloc/doc_firestore_event.dart';
import 'package:doctracking/src/bloc/doc_firestore_state.dart';
import 'package:doctracking/src/models/doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'build_doc_list.dart';

class DocList extends StatefulWidget {
  @override
  _DocListState createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  DocFirestoreBloc _docFirestoreBloc;
  int count = 0;
  List<Doc> docs;
  DateTime cDate;

  @override
  void initState() {
    _docFirestoreBloc = BlocProvider.of<DocFirestoreBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cDate = DateTime.now();
    if (docs == null) {
      docs = List<Doc>();
      _docFirestoreBloc.add(DocFirestoreFetchAll());
      DocFirestoreState state = _docFirestoreBloc.state;
      if (state is DocFirestoreSuccess) {
        if (docs.length > 0) docs.clear();
        docs = state.list;
        count = docs.length;
      }
    }
    return Stack(
      children: <Widget>[buildDocList(count, docs)],
    );
  }
}
