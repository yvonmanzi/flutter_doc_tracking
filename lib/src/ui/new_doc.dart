import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctracking/src/bloc/bloc.dart';
import 'package:doctracking/src/bloc/doc_firestore_bloc.dart';
import 'package:doctracking/src/bloc/doc_firestore_event.dart';
import 'package:doctracking/src/repository/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repository.dart';
import 'package:doctracking/src/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'doc_list.dart';

class NewDoc extends StatefulWidget {
  @override
  _NewDocState createState() => _NewDocState();
}

class _NewDocState extends State<NewDoc> {
  final _titleController = TextEditingController();
  final _expiryDateController = MaskedTextController(mask: '2000--00-00');

  final GlobalKey<FormState> _docFormKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  DatePickerBloc _datePickerBloc;
  DocFormBloc _docFormBloc;
  DocFirestoreBloc _docFirestoreBloc;

  final int daysAhead = 5475;

  @override
  void initState() {
    _docFormBloc = BlocProvider.of<DocFormBloc>(context);
    _docFirestoreBloc = BlocProvider.of<DocFirestoreBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/docList': (BuildContext context) => DocList()},
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('New Doc'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'back',
            //TODO: THIS SHOULD GO THROUGH THE BLOC. CONSULT THEMEING EXAMPLE FROM BLOC DOCUMENTATION
            onPressed: () {
              Navigator.pushNamed(context, 'docList');
              _docFirestoreBloc.add(DocFirestoreFetchAll());
            },
          ),
        ),
        body: BlocProvider<DocFormBloc>(
            create: (context) => DocFormBloc(
                initialState: DocumentFormInitial(),
                docFirestoreBloc: DocFirestoreBloc(
                    repository: DocRepository(
                        docFirestoreClient: DocFirestoreClient(
                            firestoreInstance: Firestore.instance)))),
            child: SafeArea(child: _buildDocForm())),
      ),
    );
  }

  Widget _buildDocForm() {
    return BlocBuilder(builder: (context, state) {
      if (state is DocumentFormSubmissionFailure) {
        _showMessage(state.error, Colors.red);
      }
      if (state is DocumentFormSubmissionSuccess) {
        _showMessage(
            '${state.toString()} is being uploaded to the web', Colors.green);
      }
      if (state is DocumentFormSubmissionLoading) {
        _showMessage('loading', Colors.white);
        return CircularProgressIndicator();
      }
      return Form(
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
                ],
                controller: _titleController,
                validator: (value) => Validate.validateTitle(value),
                decoration: InputDecoration(
                    labelText: 'doc name',
                    hintText: 'enter doc name',
                    icon: const Icon(Icons.title)),
              ),
              BlocProvider(
                create: (BuildContext context) => DatePickerBloc(),
                child: BlocBuilder(builder: (context, state) {
                  if (state is DatePickerInitial) _chooseDate(context);
                  if (state is DatePickerDatePickSuccess)
                    _expiryDateController.text = state.expirationDate;
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _expiryDateController,
                            validator: (expiryDate) =>
                                DateUtils.isValidDate(expiryDate)
                                    ? null
                                    : 'invalid date',
                            decoration: InputDecoration(
                                hintText: 'expiry date(i.e.' +
                                    DateUtils.daysAheadAsStr(daysAhead) +
                                    ')',
                                labelText: 'expiry date'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.more_horiz),
                            tooltip: 'pick date',
                            onPressed: () {
                              _datePickerBloc =
                                  BlocProvider.of<DatePickerBloc>(context);
                              _datePickerBloc.add(DatePickerButtonPressed());
                            }),
                      ]);
                }),
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                  child: Text('save'),
                  onPressed: () => _docFormBloc.add(
                      DocumentFormSaveButtonPressed(
                          title: _titleController.text.toString(),
                          expiration: _expiryDateController.text.toString(),
                          formKey: _docFormKey)))
            ],
          ));
    });
  }

  _chooseDate(BuildContext context) {
    var now = DateTime.now();
    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      _datePickerBloc.add(DatePickerDoneButtonPressed(
          expirationDate: DateUtils.ftDateAsStr(date)));
    }, currentTime: now);
  }

  void _showMessage(String message, MaterialColor color) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }
}
