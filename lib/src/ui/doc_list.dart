import 'package:doctracking/src/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../src/blocs/doc_firestore/doc_firestore.dart';
import '../../src/models/doc.dart';

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
    _docFirestoreBloc = BlocProvider.of<DocFirestoreBloc>(context)
      ..add(DocFirestoreFetchAll());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cDate = DateTime.now();
    docs = List<Doc>();

    DocFirestoreState state = _docFirestoreBloc.state;
    if (state is DocFirestoreLoading) return CircularProgressIndicator();
    if (state is DocFirestoreSuccess) {
      if (docs.length > 0) docs.clear();
      docs = state.list;
      count = docs.length;
      print("first doc: ${docs[0].title}");
    }
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          String dd = Validate.getExpiryString(docs[position].expiration);
          String d1 = (dd != '1') ? 'days left' : 'day left';
          print("");
          return Card(
            color: Colors.white,
            elevation: 1.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                //(Validate.getExpiryString(docs[position].expiration) != '0')
                //? Colors.blue
                //: Colors.red,
                child: Text(
                  docs[position].title,
                ),
              ),
              title: Text(docs[position].expiration),
              // d1 +
              // "\nExp: " +
              // DateUtils.convertToDateFull(docs[position].expiration)),
//TODO: think about this & implement the feature.
              onTap: () => null,
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: It's not clear which widget is responsible for disposing the blocs.
    // it might be appropriate to do so within the parent widget, the widget creating the bloc.
    // make this clearer
    _docFirestoreBloc.close();
    super.dispose();
  }
}
