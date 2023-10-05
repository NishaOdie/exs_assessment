import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  TextEditingController nameTextController = TextEditingController();
  TextEditingController timeInController = TextEditingController();

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
                controller: nameTextController,
                decoration: getCustomInputDecoration(
                  "Date",
                ),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return '*Nama Penuh (Mengikut Kad Pengenalan) wajib diisi.';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameTextController,
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
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameTextController,
                decoration: getCustomInputDecoration(
                  "Time out",
                ),
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
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF224099),
                          ),
                          child: const Text('DAFTAR AKAUN'),
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

  Future _submitForm() async {}
}
