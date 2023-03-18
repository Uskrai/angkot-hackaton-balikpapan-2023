import 'package:angkot_ku/client/ApiClient.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({
    super.key,
    required this.apiClient,
    required this.onLoggedIn
  });

  final ApiClient apiClient;
  final void Function() onLoggedIn;

  @override
  State<StatefulWidget> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

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
                height: size.height * 0.4,
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
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Container(
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
                  Image.asset('assets/images/icon.png', height: size.height * 0.35,),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
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
                        fillColor: const Color.fromRGBO(255, 255, 255, 1),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                      ),
                      controller: TextEditingController(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
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
                    width: double.infinity,
                    height: 47,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            _isLoading = true;
                          });

                          

                        } catch (e) {
                          //TODO()
                        }

                        setState(() {
                          _isLoading = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: const Color.fromRGBO(0, 96, 194, 1),
                      ),
                      child: const Text(
                        'Masuk',
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