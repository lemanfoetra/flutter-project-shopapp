import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  /*
   * Untuk validasi inputan
   */
  String validateInput(String value, String namaInput) {
    if (value.isEmpty) {
      return '$namaInput tidak boleh kosong.';
    }
    return null;
  }

  /*
   * Untuk Sumbit Login
   */
  Future<void> submitLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await Provider.of<AuthProvider>(context).login(_email, _password);
      } catch (error) {
        _alert(context, error);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  /// Widget untuk alert kesalahan error atau apapun itu.
  void _alert(BuildContext context, String message) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(message.toString())),
    );
  }

  /// button submit
  Widget _widgetSubmitButton(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                submitLogin(context);
              },
              child: Text('Login', style: TextStyle(color: Colors.white)),
              color: Colors.teal,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Builder(
        builder: (contextBuilder) => Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'email'),
                      initialValue: _email,
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: (value) => validateInput(value, 'Email'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'password'),
                      initialValue: _password,
                      obscureText: true,
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (value) => validateInput(value, 'Password'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _widgetSubmitButton(contextBuilder),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
