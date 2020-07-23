import 'package:doctracking/src/models/models.dart';
import 'package:doctracking/src/util/date_util.dart';
import 'package:flutter/material.dart';

ListView buildDocList(int count, List<Doc> docs) {
  return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        String dd = Validate.getExpiryString(docs[position].expiration);
        String d1 = (dd != '1') ? 'days left' : 'day left';
        return Card(
          color: Colors.white,
          elevation: 1.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  (Validate.getExpiryString(docs[position].expiration) != '0')
                      ? Colors.blue
                      : Colors.red,
              child: Text(
                docs[position].title.toString(),
              ),
            ),
            title: Text(docs[position].expiration +
                d1 +
                "\nExp: " +
                DateUtils.convertToDateFull(docs[position].expiration)),
//TODO: think about this & implement the feature.
            onTap: () => null,
          ),
        );
      });
}
