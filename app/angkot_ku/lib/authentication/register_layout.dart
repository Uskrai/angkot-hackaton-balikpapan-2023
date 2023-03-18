import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../client/ApiClient.dart';
import '../constant.dart';

class RegisterLayout extends StatefulWidget {
  const RegisterLayout({
    super.key,
    required this.apiClient,
    required this.onLoggedIn
  });

  final ApiClient apiClient;
  final void Function() onLoggedIn;

  @override
  State<StatefulWidget> createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends State<RegisterLayout> {
  String _email = "";
  String _password = "";
  String _type = "Penumpang";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                height: size.height * 0.15,
                decoration: const BoxDecoration(
                    borderRadius : BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color : mPrimaryColor
                )
            ),
            const SizedBox(height: 35),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('ANGKOTKU', textAlign: TextAlign.left, style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 29,
                            fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height : 0),
                        Text('Siap menjadi pemandumu', textAlign: TextAlign.left, style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) => _email = value,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Email Kamu',
                        labelStyle: const TextStyle(
                          color: Color.fromRGBO(26, 37, 42, 1),
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 96, 194, 1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 96, 194, 1),
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                      ),
                      controller: TextEditingController(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) => _password = value,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        labelStyle: const TextStyle(
                          color: Color.fromRGBO(26, 37, 42, 1),
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 96, 194, 1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 96, 194, 1),
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                      ),
                      controller: TextEditingController(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 96, 194, 1),
                            width: 1,
                          ),
                        ),
                      ),
                      items: ["Penumpang", "Angkot", "Bis"].map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        _type = value!;
                      },
                      hint: const Text('Select an option'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 47,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => RegisterLayout())
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: const Color.fromRGBO(0, 96, 194, 1),
                      ),
                      child: const Text(
                        'Daftar',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}