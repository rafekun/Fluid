import 'package:fluid/app/auth/auth_service.dart';
import 'package:fluid/app/task/task_model.dart';
import 'package:fluid/app/welcome/sign_up/sign_up_page.dart';
import 'package:fluid/app/welcome/welcome_page/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../colors.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(HomeViewModel());
    final authService = Get.put(AuthService());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FluidColor.baseGrey,
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await authService.signOut();
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WelcomePage()));
          },
        ),
        actions: [
          authService.hasRegisteredWithAnonymous()
              ? IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  icon: Icon(Icons.account_circle),
                )
              : SizedBox(),
        ],
      ),
      backgroundColor: FluidColor.baseGrey,
      body: Focus(
        onKey: (FocusNode node, RawKeyEvent event) => true,
        child: RawKeyboardListener(
            autofocus: true,
            focusNode: viewModel.desktopFocusNode,
            onKey: (RawKeyEvent event) async {
              if (event.logicalKey == LogicalKeyboardKey.enter &&
                  event.runtimeType.toString() == "RawKeyDownEvent") {
                await viewModel.createTask(
                    title: 'title', subtitle: 'subtitle');
              }
            },
            child: StreamBuilder<List<TaskModel>>(
              stream: viewModel.taskListStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final taskList = snapshot.data!;
                return ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      final task = taskList[index];
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ListTile(
                          tileColor: FluidColor.green,
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.id),
                            // child: Form(
                            //   key: _formKey,
                            //   child: TextFormField(
                            //     controller: viewModel.textEditingController,
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'Please enter some text';
                            //       }
                            //       if (value.length < 6) {
                            //         return 'password length must be over 6 words';
                            //       }
                            //       return null;
                            //     },
                            //   ),
                            // ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await viewModel.finishTask(task.id);
                            },
                            icon: Icon(Icons.check),
                          ),
                        ),
                      );
                    });
              },
            )),
      ),
    );
  }
}
