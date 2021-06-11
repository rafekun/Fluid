import 'package:fluid/app/task/task_model.dart';
import 'package:fluid/app/task/task_serivce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final TaskService _taskService = Get.put(TaskService());
  final FocusNode desktopFocusNode = FocusNode();

  final textEditingController = TextEditingController();

  // var count = 0.obs;

  // void increment() => count++;

  Future<void> createTask(
      {required String title, required String subtitle}) async {
    await _taskService.createTask(title: title, subtitle: subtitle);
  }

  Future<void> finishTask(String taskId) async =>
      await _taskService.finishTask(taskId);

  Stream<List<TaskModel>> get taskListStream => _taskService.taskListStream;
}
