import 'package:example/app/modules/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('LoginPage')),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Login'),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    MinX<LoginController>(
                      builder: (context, controller) => TextFormField(
                        onChanged: (_) => controller.onChangedName(_),
                        validator: (_) => controller.validateName(_),
                        onSaved: (_) => controller.onSaveName(_),
                        decoration:
                            const InputDecoration(hintText: 'Escreva seu nome'),
                      ),
                    ),
                    TextButton(
                        onPressed: () => context.goNamed('signup'),
                        child: const Text('Signup'))
                  ],
                ),
              ),
            ),
            MinX<LoginController>(
              builder: (context, controller) => $(
                (loading) => loading
                    ? const CircularProgressIndicator()
                    : MaterialButton(
                        color: Colors.blue,
                        height: 60.0,
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (await controller.login()) {
                              context.goNamed('home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text('Verify data and try again.'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('LOGIN'),
                      ),
                listener: controller.loading,
              ),
            )
          ],
        )));
  }
}
