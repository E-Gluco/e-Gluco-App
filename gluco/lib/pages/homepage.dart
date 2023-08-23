// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, empty_catches

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:gluco/db/databasehelper.dart';
import 'package:gluco/models/measurement.dart';
import 'package:gluco/services/api.dart';
import 'package:gluco/services/bluetoothhelper.dart';
import 'package:gluco/services/customlog.dart';
import 'package:gluco/styles/defaultappbar.dart';
import 'package:gluco/styles/mainbottomappbar.dart';
import 'package:gluco/styles/customcolors.dart';
import 'package:gluco/views/historyvo.dart';
import 'package:gluco/widgets/iconcard.dart';
import 'package:gluco/widgets/sidebar.dart';
import 'package:intl/intl.dart';
import 'package:gluco/app_icons.dart';
import 'package:gluco/extensions/buildcontext/loc.dart';

class HomePage extends StatefulWidget {
  bool offline;
  bool popup = true;
  HomePage({this.offline = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<bool> btConn;

  @override
  void initState() {
    btConn = BluetoothHelper.instance.connected;
    WidgetsBinding.instance
        .addPostFrameCallback(_dialogNoConnection(context, widget));
    super.initState();
  }

  bool _isPacientSelected = false;
  String? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    Size heightSize = Size.fromHeight(MediaQuery.of(context).size.height *
        (MediaQuery.of(context).orientation == Orientation.portrait
            ? 0.2
            : 0.4));
    IconCard glucoseCard = IconCard(
      icon: Icon(AppIcons.molecula, color: Colors.white, size: 32),
      label: Text(
        context.loc.glucose,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
      data: HistoryVO.currentMeasurement.id != -1
          ? Text(
              '${HistoryVO.currentMeasurement.glucose} mg/dL',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            )
          : Text(context.loc.no_data),
      color: CustomColors.lightBlue.withOpacity(1.0),
      size: heightSize,
    );
    IconCard spo2Card = IconCard(
      icon: Icon(Icons.air, color: Colors.white),
      label: Text(
        context.loc.oxygen_saturation,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
      data: HistoryVO.currentMeasurement.id != -1
          ? Text(
              '${HistoryVO.currentMeasurement.spo2}%',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            )
          : Text(context.loc.no_data),
      color: CustomColors.lightGreen.withOpacity(1.0),
      size: heightSize,
    );
    IconCard rpmCard = IconCard(
      icon: Icon(Icons.favorite, color: Colors.white),
      label: Text(
        context.loc.heart_rate,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
      data: HistoryVO.currentMeasurement.id != -1
          ? Text(
              '${HistoryVO.currentMeasurement.pr_rpm} bpm',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            )
          : Text(context.loc.no_data),
      color: CustomColors.greenBlue.withOpacity(1.0),
      size: heightSize,
    );
    return Scaffold(
      backgroundColor: CustomColors.scaffLightBlue,
      appBar: imageAppBar(
        imagename: 'assets/images/logoblue.png',
        width: MediaQuery.of(context).size.width * 0.25,
      ),
      bottomNavigationBar: mainBottomAppBar(context, MainBottomAppBar.home),
      drawer: SideBar(),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          '${context.loc.homepage_view_last_measurement}: ${MediaQuery.of(context).orientation == Orientation.portrait ? '\n' : ' '}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                      children: [
                        TextSpan(
                          text: HistoryVO.currentMeasurement.id != -1
                              ? DateFormat('d MMM, E H:mm', 'pt_BR')
                                  .format(HistoryVO.currentMeasurement.date)
                                  .toUpperCase()
                              : context.loc.no_data,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MediaQuery.of(context).orientation == Orientation.portrait
                ? Column(
                    children: [
                      glucoseCard,
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025),
                      Row(
                        children: [
                          Expanded(
                            child: spo2Card,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.025),
                          Expanded(
                            child: rpmCard,
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: glucoseCard),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.015),
                      Expanded(child: spo2Card),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.015),
                      Expanded(child: rpmCard)
                    ],
                  ),
            StreamBuilder<bool>(
              stream: btConn,
              // stream: Stream.value(true), // TESTE BOTÃAAAAAAAO
              initialData: false,
              builder: (contextStream, snapshot) {
                return AsyncButtonBuilder(
                  loadingWidget: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3.0,
                  ),
                  successWidget: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    late MeasurementCollected measurement;

                    try {
                      measurement = await BluetoothHelper.instance.collect();
                    } catch (e) {
                      await _dialogErrorBluetooth(context);
                      throw context.loc
                          .homepage_error_measurement; // pro async_button mostrar ícone certo
                    }
                    bool response = false;
                    response = await _dialogMeasurement(context, measurement);
                    _isPacientSelected = false;
                    _dropdownValue = null;
                    if (!response) {
                      throw context.loc
                          .homepage_prompt_measurement_canceled; // pro async_button mostrar ícone certo
                    }
                    /////////////////// futuro
                    // MeasurementCompleted measurement = await API.instance.getMeasurement();
                    // await DatabaseHelper.instance
                    //     .insertMeasurement(API.instance.currentUser!, measurement);
                    ///////////////////
                    /// SIMULAÇÃO
                    //measurement = await BluetoothHelper.instance.collect_rand();
                    MeasurementCollected ms = measurement;
                    MeasurementCompleted mc = HistoryVO.currentMeasurement;
                    mc.id++;
                    mc.spo2 = ms.spo2;
                    mc.pr_rpm = ms.pr_rpm;
                    mc.glucose = ms.apparent_glucose!;
                    mc.date = ms.date;
                    HistoryVO.updateMeasurementsMap();
                    await DatabaseHelper.instance.insertMeasurementCompleted(
                        API.instance.currentUser!, mc);
                    setState(() {
                      HistoryVO.disposeHistory();
                      HistoryVO.fetchHistory();
                    });
                    /////////
                  },
                  builder: (contextButton, child, callback, _) {
                    Color color = CustomColors.greenBlue.withOpacity(1.0);
                    if (!snapshot.data!) {
                      color = Colors.grey;
                      callback = _dialogNoDevice(context);
                    }
                    return TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: color,
                        minimumSize: Size.fromHeight(
                            MediaQuery.of(context).size.height * 0.09),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: callback,
                      child: child,
                    );
                  },
                  child: Text(
                    context.loc.measure,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void Function(Duration) _dialogNoConnection(
    BuildContext context, HomePage widget) {
  return (_) async {
    if (widget.offline && widget.popup) {
      await showDialog(
        context: context,
        builder: (contextNoConn) {
          return AlertDialog(
            title: Text(context.loc.generic_error_no_connection),
            content: Text(context.loc.homepage_view_no_connection),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(contextNoConn).pop();
                },
                child: Text(context.loc.ok),
              )
            ],
          );
        },
      );
      widget.popup = false;
    }
  };
}

Future<void> _dialogErrorBluetooth(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (contextErrorBlue) {
      return AlertDialog(
        title: Text(context.loc.homepage_error_bluetooth),
        content: SingleChildScrollView(
          child: Column(
            children: [Text('${BluetoothHelper.instance.valuesError}')],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: [
          TextButton(
            onPressed: (() {
              Navigator.pop(contextErrorBlue);
            }),
            child: Text(context.loc.return_p),
          )
        ],
      );
    },
  );
}

Future<bool> _dialogMeasurement(
    BuildContext context, MeasurementCollected measurement) async {
  final formKey = GlobalKey<FormState>();
  bool response = false;
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (contextMeasurement) {
      TextEditingController controller = TextEditingController();
      return AlertDialog(
        title: Text(context.loc.homepage_prompt_glucose_measurement),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ALT
              // DropdownButtonFormField(
              //     value: _dropdownValue,
              //     icon: Icon(Icons.keyboard_arrow_down),
              //     onChanged: (String? value) {
              //       _isPacientSelected =
              //           value?.isNotEmpty ?? false;
              //       setState(() {
              //         _dropdownValue = value!;
              //       });
              //     },
              //     items: API.instance.pacientList
              //         .map((String value) {
              //       return DropdownMenuItem(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList()),
              TextFormField(
                controller: controller,
                validator: (value) {
                  String? message;
                  try {
                    double.parse(value!);
                  } catch (e) {
                    message = context.loc.homepage_prompt_decimal_value;
                  }
                  return message;
                },
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _dialogConfirmCancel(context, contextMeasurement);
            },
            child: Text(
              context.loc.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            style:
                TextButton.styleFrom(backgroundColor: CustomColors.lightGreen),
            child: Text(
              context.loc.send,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) {
                throw 'Form inválido';
              }
              measurement.apparent_glucose = double.parse(controller.text);
              response = await _dialogConfirmMeasurement(
                  context, contextMeasurement, measurement);
              Navigator.pop(contextMeasurement); // CORRIGIR NAO FUNCIONA
            },
          )
        ],
      );
    },
  );
  return response;
}

Future<void> _dialogConfirmCancel(
    BuildContext context, BuildContext contextMeasurement) async {
  await showDialog(
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    context: contextMeasurement,
    builder: (contextCancel) {
      return AlertDialog(
        title: Text(context.loc.generic_dialog_cancel),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.red[900]),
            onPressed: () {
              Navigator.pop(contextCancel);
              Navigator.pop(contextMeasurement); // talvez seja um problema
            },
            child: Text(
              context.loc.cancel,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style:
                TextButton.styleFrom(backgroundColor: CustomColors.lightGreen),
            onPressed: () {
              Navigator.pop(contextCancel);
            },
            child: Text(
              context.loc.homepage_prompt_continue_measurement,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      );
    },
  );
}

Future<bool> _dialogConfirmMeasurement(BuildContext context,
    BuildContext contextMeasurement, MeasurementCollected measurement) async {
  bool response = false;
  await showDialog(
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    context: contextMeasurement,
    builder: (contextConfirm) {
      return AlertDialog(
        title: Text(context.loc.homepage_prompt_confirm_data),
        content: Text(

            // ALT
            // '''Paciente: $_dropdownValue\n
            // '''
            '${context.loc.glucose} : ${measurement.apparent_glucose}'),
        // '''),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(contextConfirm);
            },
            child: Text(
              context.loc.correct,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          AsyncButtonBuilder(
            onPressed: () async {
              response = await API.instance.postMeasurements(measurement, 'Eu');
              // _dropdownValue!); // ALT
              if (!response) {
                await DatabaseHelper.instance.insertMeasurementCollected(
                    API.instance.currentUser!, measurement);
              }
              await _dialogSentMeasurement(context, contextMeasurement,
                  contextConfirm, measurement, response);
              Navigator.pop(contextConfirm);
              // Navigator.pop(contextMeasurement); // TALVEZ BOTAR FORA DO SHOWDIALOG
            },
            builder: (cont, child, callback, _) {
              return TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: CustomColors.lightGreen),
                onPressed: callback,
                child: child,
              );
            },
            child: Text(
              context.loc.confirm,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      );
    },
  );
  return response;
}

Future<void> _dialogSentMeasurement(
    BuildContext context,
    BuildContext contextMeasurement,
    BuildContext contextConfirm,
    MeasurementCollected measurement,
    bool response) async {
  await showDialog(
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    context: contextConfirm,
    builder: (contextSent) {
      return AlertDialog(
        title: Text(response
            ? context.loc.homepage_prompt_measurement_sent
            : context.loc.homepage_error_measurement_not_sent),
        // ALT
        content:
            // response
            //     ?
            SingleChildScrollView(
          child: Column(
            children: measurement
                .toMap()
                .entries
                .map((e) => Text('${e.key}: ${e.value}'))
                .toList(),
          ),
        )
        // : null
        ,
        //////////
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: [
          TextButton(
            onPressed: (() {
              Navigator.pop(contextSent);
              // Navigator.pop(contextConfirm);
              // Navigator.pop(contextMeasurement);
            }),
            child: Text(response ? 'Ok!' : context.loc.return_p),
          )
        ],
      );
    },
  );
}

Future<void> Function()? _dialogNoDevice(BuildContext context) {
  return () async {
    await showDialog(
      useRootNavigator: false,
      context: context,
      builder: (contextNoDev) {
        return AlertDialog(
          title: Text(context.loc.homepage_error_device_not_connected),
          content: Text(context.loc.homepage_prompt_connect_device),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actions: [
            TextButton(
              child: Text(context.loc.homepage_prompt_go_to_devicepage),
              onPressed: () async {
                await Navigator.popAndPushNamed(context, '/devices');
              },
            )
          ],
        );
      },
    );
  };
}
