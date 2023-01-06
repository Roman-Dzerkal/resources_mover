// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart' as p;

class MoverViewModel extends BaseViewModel {
  String? sourceFolderPath;
  String? targetFolderPath;
  String? logFilePath;

  bool startButtonActive = true;

  final List<String> extensions = [
    '.dds',
    '.thm',
    '_bump#.dds',
    '_bump.dds',
    '_bump.thm'
  ];

  final p.Context windowsContext = p.Context(style: p.Style.windows);

  TextEditingController logFilePathController = TextEditingController();
  TextEditingController targetPathController = TextEditingController();
  TextEditingController sourcePathController = TextEditingController();

  List<String> textures = [];

  void openSourceFolder() async {
    String? selectedFolder = await FilePicker.platform.getDirectoryPath();

    if (selectedFolder != null) {
      String folderName = windowsContext.basename(selectedFolder);
      if ('textures' != folderName) {
        BotToast.showText(text: 'Selected folder must be \'textures\'');
      } else {
        sourceFolderPath = selectedFolder;
        sourcePathController.text = selectedFolder;
      }
    }
  }

  void openTargetFolder() async {
    String? selectedFolder = await FilePicker.platform.getDirectoryPath();
    if (selectedFolder != null) {
      if ('textures' != windowsContext.basename(selectedFolder)) {
        BotToast.showText(text: 'Selected folder must be \'textures\'');
      } else if (sourceFolderPath == selectedFolder) {
        BotToast.showText(
            text:
                'Source and Target folders cannot be the same! Please choose other folder.');
      } else {
        targetFolderPath = selectedFolder;
        targetPathController.text = selectedFolder;
      }
    }
  }

  void openLogFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['log']);
    if (result != null) {
      PlatformFile platformLogFile = result.files.first;

      if (platformLogFile.size == 0) {
        BotToast.showText(text: 'Selected file is empty!');
        throw '${platformLogFile.path} is empty!';
      }



      List<String> list = _getTexturesFromLog(platformLogFile.path!);
      BotToast.showText(text: 'Extracted ${list.length} textures');
      logFilePath = platformLogFile.path!;
      logFilePathController.text = platformLogFile.path!;
      if (textures.isNotEmpty) {
        textures.clear();
      }
      textures.addAll(list);
      list.clear();


    }
  }

  void startCopy() {
    print('start');
    _checkExistence(textures, sourceFolderPath!);
  }

  List<String> _getTexturesFromLog(String logFilePath) {
    File logFile = File(logFilePath);

    List<String> list = logFile.readAsLinesSync();
    list.removeWhere((line) => !line.contains('Can\'t find texture'));

    if (list.isEmpty) {
      BotToast.showText(text: 'There are no one texture in log file');
      throw 'Log file hasn\'t necessary information';
    }

    return list
        .map((line) =>
            line.substring(line.indexOf(' \'') + 2, line.lastIndexOf('\'')))
        .toList();
  }

  List<String> _collectAllFiles(
      List<String> textures, String sourceFolderPath) {
    return List.empty();
  }

  void _checkExistence(List<String> textures, String sourceFolder) async {
    Directory documentFolder = await getApplicationDocumentsDirectory();
    File notFoundFile =
        File(windowsContext.join(documentFolder.path, 'NOT_FOUND.txt'));

    for (String texture in textures) {
      File textureFile =
          File(windowsContext.join(sourceFolder, texture) + '.dds');
      bool exist = await textureFile.exists();
      if (!exist) {
        notFoundFile.writeAsStringSync(texture + '\n', mode: FileMode.append);
      } else {
        _checkOther(texture, sourceFolder, targetFolderPath!);
      }
    }
  }

  void _checkOther(String relativePath, String sourcePath, String targetPath) {
    var dirname = windowsContext.dirname(relativePath);
  }
}
