import 'package:angkot/authentication/register_layout.dart';
import 'package:angkot/client/ApiClient.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout(
      {super.key, required this.apiClient, required this.onLoggedIn});

  final ApiClient apiClient;
  final void Function() onLoggedIn;

  @override
  State<StatefulWidget> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;

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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: mPrimaryColor)),
            Align(
              alignment: Alignment.center,
              child: ListView(
                children: [
                  const SizedBox(height: 35),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'ANGKOTKU',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 29,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 0),
                        Text(
                          'Siap menjadi pemandumu',
                          textAlign: TextAlign.left,
                          style: TextStyle(
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
                  Image.asset(
                    'assets/images/icon.png',
                    height: size.height * 0.35,
                  ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 15,
                        ),
                      ),
                      controller: _email,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },

                          child: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 15,
                        ),
                      ),
                      controller: _password,
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
                          await widget.apiClient.signIn(
                            _email.value.text,
                            _password.value.text
                          );

                          widget.onLoggedIn.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("login"),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
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
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterLayout(
                              apiClient: widget.apiClient,
                              onLoggedIn: widget.onLoggedIn),
                        ),
                      );
                      // Tambahkan kode untuk menangani aksi ketika tombol "Daftar" ditekan
                    },
                    child: const Text(
                      'Belum punya akun? Daftar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue, // Warna teks menjadi biru
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

