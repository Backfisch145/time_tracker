import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: AccountForm(),
      ),
    );
  }
}

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              value ??= "";
              if (value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          const Gap(16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              value ??= "";
              if (value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const Gap(32),
          MaterialButton(
            onPressed: () {
              if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                // Perform the account creation logic here
                // For demo, just print the username and password
                if (kDebugMode) {
                  print('Username: ${_usernameController.text}');
                  print('Password: ${_passwordController.text}');
                }
              }
            },
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountPage(),
  ));
}
