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
  //TODO: CACHING, maybe using redis even tho it might not be the most
  // appropriate tool here.
  /*
  * I think it might be useful to do some kind of caching
  * instead of an http request every time the user needs data.
  * we can set up some logic that makes sense for invalidating cache.
  * actually this might be an opportunity to use Redis. huh!
  * */
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
      docs = state.props.first;
      count = docs.length;
      print("first doc: ${docs[0].title}");
    }
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          String dd = Validate.getRemainingTimeBeforeExpiryString(
              docs[position].expiration);
          String d1 = (dd != '1') ? 'days left' : 'day left';
          print("");
          return Card(
            color: Colors.white,
            elevation: 1.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                //(Validate.getExpiryString(docs[position].expiration) != '0')
                //? Colors.blue
                //: Colors.red,
                child: Text('${position.toString()}'),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(docs[position].title),
                  Text(docs[position].expiration),
                  // d1 +
                  // "\nExp: " +
                  // DateUtils.convertToDateFull(docs[position].expiration)),
                ],
              ),
//TODO: think about this & implement the feature.
              onTap: () => null,
            ),
          );
        });
  }

  @override
  void dispose() {
    _docFirestoreBloc.close();
    super.dispose();
  }
}
