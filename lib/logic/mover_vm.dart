// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart' as p;

class MoverViewModel extends BaseViewModel {
  String? sourceFolderPath;
  String? targetFolderPath;
  String? logFilePath;

  double progressValue = 0.67;

  String currentFile = '';

  void openSourceFolder() async {
    var selectedFolder = await FilePicker.platform.getDirectoryPath();
    if (selectedFolder != null) {
      sourceFolderPath = selectedFolder;
      print(sourceFolderPath);
    }
  }

  void openTargetFolder() async {
    var selectedFolder = await FilePicker.platform.getDirectoryPath();
    if (selectedFolder != null) {
      targetFolderPath = selectedFolder;
      print(targetFolderPath);
    }
  }

  void openLogFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['log']);
    if (result != null) {
      logFilePath = result.files.first.path;
      print(logFilePath);
    }
  }

  void startCopy() async {
    List<String> textures = parseLog();
    if (sourceFolderPath == targetFolderPath) {
      throw 'Source and target folders cannot be the same';
    }

    copyDirectories(textures, targetFolderPath!, sourceFolderPath!);

    currentFile = textures.first;
    notifyListeners();
  }

  List<String> parseLog() {
    File logFile = File(logFilePath!);
    List<String> list = logFile.readAsLinesSync();
    list.removeWhere((line) => !line.contains('Can\'t find texture'));
    list = list
        .map((line) =>
            line.substring(line.indexOf(' \'') + 2, line.lastIndexOf('\'')))
        .toList();

    return list;
  }

  void copyDirectories(List<String> textures, String targetFolderPath,
      String sourceFolder) async {
    var context = p.Context(style: p.Style.windows);
    textures.forEach((element12) {
      if (element12.contains('\\')) {
        // var s = context.dirname(element);
        // var t = targetFolderPath + '\\' + s;
        Directory dir =
            Directory(targetFolderPath + '\\' + context.dirname(element12));
        List<FileSystemEntity> l = dir.listSync();
        l.removeWhere(
            (element) => !element.path.contains(context.basename(element12)));
        print(l);
      }
    });
  }
}
