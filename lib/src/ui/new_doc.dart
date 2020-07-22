import 'package:doctracking/src/bloc/bloc.dart';
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

  final int daysAhead = 5475;

  @override
  void initState() {
    _docFormBloc = BlocProvider.of<DocFormBloc>(context);
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
            //TODO: THIS SHOULD GO THROUGH THE BLOC. CONSULT THEMEING EXAMPLE FROM BLOC DOCUMENTATION
            onPressed: () => Navigator.pushNamed(context, 'docList'),
          ),
        ),
        body: SafeArea(child: _buildDocForm()),
      ),
    );
  }

  Widget _buildDocForm() {
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
              onPressed: () => _saveForm(),
            )
          ],
        ));
  }

  _chooseDate(BuildContext context) {
    var now = DateTime.now();
    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      _datePickerBloc.add(DatePickerDoneButtonPressed(
          expirationDate: DateUtils.ftDateAsStr(date)));
    }, currentTime: now);
  }

  _saveForm() {
    if (!form.validate())
      _docFormBloc.add(DocumentFormSubmissionFailure(
          error: 'Some data is invalid. please correct'));
  }
}
