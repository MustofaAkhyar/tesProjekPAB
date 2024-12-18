import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TODO: 1. Deklarasi Variable
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  String _errorText = '';
  bool _isSigned = false;
  bool _obscurePassword = true;

 Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs(
  SharedPreferences sharedPreferences,
) async {
  try {
    final encryptedUsername = sharedPreferences.getString('username');
    final encryptedPassword = sharedPreferences.getString('password');
    final keyString = sharedPreferences.getString('key');
    final ivString = sharedPreferences.getString('iv');

    if (encryptedUsername == null ||
        encryptedPassword == null ||
        keyString == null ||
        ivString == null) {
      throw Exception('Missing credentials in SharedPreferences.');
    }

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final encrypt.IV iv = encrypt.IV.fromBase64(ivString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    return {'username': decryptedUsername, 'password': decryptedPassword};
  } catch (e) {
    print('Decryption failed: $e');
    return {};
  }
}

void _signIn() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final String username = _usernameController.text;
    final String password = _passwordController.text;
    print('Sign in attempt: Username: $username, Password: $password');

    if (username.isNotEmpty && password.isNotEmpty) {
      final data = await _retrieveAndDecryptDataFromPrefs(prefs);

      if (data.isNotEmpty) {
        final decryptedUsername = data['username'];
        final decryptedPassword = data['password'];

        if (username == decryptedUsername && password == decryptedPassword) {
          setState(() {
            _isSigned = true;
          });
          prefs.setBool('isSignedIn', true);

          // Arahkan ke MainScreen setelah login berhasil
          Navigator.pushReplacementNamed(context, '/');
          print('Sign in succeeded!');
        } else {
          setState(() {
            _errorText = 'Username atau kata sandi salah';
          });
          print('Username or password is incorrect');
        }
      } else {
        setState(() {
          _errorText = 'No stored credentials found or decryption failed.';
        });
        print('No stored credentials found');
      }
    } else {
      setState(() {
        _errorText = 'Username dan kata sandi tidak boleh kosong.';
      });
      print('Username and password cannot be empty');
    }
  } catch (e) {
    print('An error occurred: $e');
    setState(() {
      _errorText = 'Terjadi kesalahan saat proses login.';
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 2 Pasang APP BAr
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      // TODO: 3 Pasang BOdy
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                // TODO: 4 Atur MainAxisAlignment dan CrossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TODO: 5 Pasang TextFormField
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pengguna',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // TODO: 6 Pasang TextFormField Kedua
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      errorText: _errorText.isNotEmpty ? _errorText : null,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  // TODO: 7 Pasang ElevatedButton Sign in
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signIn,
                    child: const Text('Sign in'),
                  ),
                  // TODO: 8 Pasang ElevatedButton Register
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Belum punya Akun?',
                      style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Daftar Disini',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {Navigator.pushNamed(context, '/signup');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
