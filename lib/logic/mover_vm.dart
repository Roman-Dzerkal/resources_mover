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

  bool startButtonActive = false;

  final List<String> _extensions = [
    '.dds',
    '.thm',
    '_bump#.dds',
    '_bump.dds',
    '_bump.thm'
  ];

  final p.Context _context = p.Context(style: p.Style.windows);

  TextEditingController logFilePathController = TextEditingController();
  TextEditingController targetPathController = TextEditingController();
  TextEditingController sourcePathController = TextEditingController();

  List<String> _textures = [];

  late File _notFound;

  String currentTexture = '';
  int amountTextures = 0;
  double value = 0.0;
  int i = 0;

  String message = '';

  void onReady() async {
    Directory appDocument = await getApplicationDocumentsDirectory();
    _notFound = File(_context.join(appDocument.path, 'NOT_FOUND.txt'));
    if (_notFound.existsSync()) {
      _notFound.deleteSync();
    }
    print(_notFound);
  }

  void openSourceFolder() async {
    String? selectedFolder = await FilePicker.platform.getDirectoryPath();

    if (selectedFolder != null) {
      String folderName = _context.basename(selectedFolder);
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
      if ('textures' != _context.basename(selectedFolder)) {
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
      amountTextures = list.length;
      logFilePath = platformLogFile.path!;
      logFilePathController.text = platformLogFile.path!;
      if (_textures.isNotEmpty) {
        _textures.clear();
      }
      _textures.addAll(list);
      list.clear();
    }
    startButtonActive = true;
    notifyListeners();
  }

  void startCopy(BuildContext context) async {
    message = 'Copying $amountTextures textures...';
    _checkExistence(_textures, sourceFolderPath!);
  }

  List<String> _getTexturesFromLog(String logFilePath) {
    File logFile = File(logFilePath);
    List<String> list = List.empty();
    try {
      list = logFile.readAsLinesSync();
    } catch (e) {
      if (e is FileSystemException) {
        BotToast.showText(text: 'change log encoding to UTF-8');
      }
    }
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

  void _checkExistence(List<String> textures, String sourceFolder) async {
    for (String texture in textures) {
      value = (i / textures.length);
      i = i + 1;
      currentTexture = texture;
      notifyListeners();
      /* Future.delayed(Duration(milliseconds: 1000))
          .then((value) => notifyListeners()); */

      File textureFile = File(_context.join(sourceFolder, texture) + '.dds');
      bool exist = await textureFile.exists();
      if (exist) {
        _checkOthers(texture, sourceFolder, targetFolderPath!);
      } else {
        _notFound.writeAsStringSync(texture + '\n', mode: FileMode.append);
      }
    }
    BotToast.showText(
        text: 'All textures was copied success!',
        duration: Duration(seconds: 5));
    message = 'Copied!';
    notifyListeners();
  }

  /// This method finds and copies the other files with required extensions
  ///
  /// relativePath -> materials\wood\fanera_01
  /// sourcePath -> path_to_sdk\gamedata\textures\
  /// targetPath -> path_to_game\gamedata\textures\
  void _checkOthers(String relativePath, String sourcePath, String targetPath) {
    for (var extension in _extensions) {
      // f = path_to_sdk\gamedata\textures\materials\wood\fanera_01.dds
      File f = File(_context.join(sourcePath, relativePath) + extension);
      bool exists = f.existsSync();

      if (!exists) continue;

      String textureDirPath = relativePath.contains('\\')
          ? _context.dirname(relativePath)
          : relativePath; // materials\wood
      String textureName = _context.basename(relativePath);

      // path_to_game\gamedata\textures\materials\wood\
      var fullDirPath = _context.join(targetPath, textureDirPath);
      Directory d = Directory(fullDirPath);

      if (!d.existsSync()) {
        d.createSync(recursive: true);
      }
      var newFullPath = _context.join(d.path, textureName) + extension;
      f.copySync(newFullPath);
    }
  }

  void openLog() async {
    Directory appDocument = await getApplicationDocumentsDirectory();
    File log = File(_context.join(appDocument.path, 'NOT_FOUND.txt'));
    if (log.existsSync()) {
      Process.runSync('notepad.exe', [log.path]);
    } else {
      BotToast.showText(text: 'The file doesn\'t exist!');
    }
  }
}
