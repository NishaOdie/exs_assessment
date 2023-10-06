import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({Key? key}) : super(key: key);

  @override
  State<InsertPage> createState() => _InsertPageState();
}

InputDecoration getCustomInputDecoration(String labelText) {
  return InputDecoration(
    filled: true,
    labelText: labelText,
    labelStyle: GoogleFonts.inter(
      color: const Color(0xFF525252),
      fontSize: 12,
    ),
    floatingLabelStyle: GoogleFonts.inter(
      color: const Color(0xFF224099),
      // fontSize: 18,
    ),
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFC5C5C5),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF224099),
      ),
    ),
  );
}

class _InsertPageState extends State<InsertPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  TextEditingController regNoTextController = TextEditingController();
  TextEditingController timeInController = TextEditingController();
  TextEditingController timeOutController = TextEditingController();
  TimeOfDay? selectedInTime;
  TimeOfDay? selectedOutTime;

  Future<void> _selectInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedInTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedInTime) {
      setState(() {
        selectedInTime = picked;
        final formattedTime = DateFormat('h:mm a').format(
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, selectedInTime!.hour, selectedInTime!.minute),
        );
        timeInController.text = formattedTime;
      });
    }
  }

  Future<void> _selectOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedOutTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedOutTime) {
      setState(() {
        selectedOutTime = picked;
        final formattedTime = DateFormat('h:mm a').format(
          DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              selectedOutTime!.hour,
              selectedOutTime!.minute),
        );
        timeOutController.text = formattedTime;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "EXS Synergy Technical Assessment",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Calculate Parking Fees",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF989898),
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: dateController,
                decoration: getCustomInputDecoration(
                  "Date",
                ),
                enabled: false,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: regNoTextController,
                decoration: getCustomInputDecoration(
                  "Register Number",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: timeInController,
                decoration: getCustomInputDecoration(
                  "Time in",
                ),
                onTap: () {
                  _selectInTime(context);
                },
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: timeOutController,
                decoration: getCustomInputDecoration(
                  "Time out",
                ),
                onTap: () {
                  _selectOutTime(context);
                },
                readOnly: true,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF224099),
                          ),
                          child: const Text('CALCULATE'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    TimeOfDay timeIn = selectedInTime ?? TimeOfDay.now();
    TimeOfDay timeOut = selectedOutTime ?? TimeOfDay.now();

    // Calculate the total hours
    int hours = (timeOut.hour - timeIn.hour).abs();
    int minutes = (timeOut.minute - timeIn.minute).abs();
    double totalHours = hours + (minutes / 60);

    // Calculate the duration
    int durationHours = totalHours.floor();
    int durationMinutes = ((totalHours - durationHours) * 60).round();
    String durationString = '$durationHours hours $durationMinutes minutes';

    //(Monday = 1, Sunday = 7)
    bool isWeekend = DateTime.now().weekday >= 6;

    double maxCharge = 0.0;

    double parkingFee = 0.0;

    if (totalHours < 1.0 / 4.0) {
      parkingFee = 0.0;
    } else if (isWeekend) {
      parkingFee = totalHours <= 3 ? 5.0 : 5.0 + (totalHours - 3) * 2.0;
      maxCharge = 40.0;
    } else {
      if (totalHours <= 3) {
        parkingFee = totalHours * 1.0;
      } else {
        parkingFee = 3.0 + (totalHours - 3) * 1.5;
      }
      maxCharge = 20.0;
    }

    parkingFee = parkingFee > maxCharge ? maxCharge : parkingFee;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Parking Fee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text('Reg.No :'),
                        ],
                      ),
                      Text(' ${regNoTextController.text}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text('In :'),
                        ],
                      ),
                      Text(
                          '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${timeInController.text}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text('Out :'),
                        ],
                      ),
                      Text(
                          '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${timeOutController.text}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text('Duration:'),
                        ],
                      ),
                      Text(durationString),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text('Amount to paid :'),
                        ],
                      ),
                      Text('\$ ${parkingFee.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
