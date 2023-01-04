import 'package:flutter/material.dart';
import 'package:resources_mover/logic/mover_vm.dart';
import 'package:stacked/stacked.dart';

class MoverView extends StatelessWidget {
  const MoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MoverViewModel>.reactive(
        viewModelBuilder: () => MoverViewModel(),
        builder: (context, model, child) => Scaffold(
              body: Center(
                child: Column(children: [
                  ElevatedButton(
                      onPressed: model.openSourceFolder,
                      child: const Text('Open')),
                  ElevatedButton(
                      onPressed: model.openTargetFolder,
                      child: const Text('Open')),
                  ElevatedButton(
                      onPressed: model.openLogFile, child: const Text('Open')),
                  ElevatedButton(
                      onPressed: model.startCopy, child: const Text('Start')),
                  Row(
                    children: [
                      CircularProgressIndicator(
                        value: model.progressValue,
                        backgroundColor: Colors.black,
                        color: Colors.white,
                        semanticsLabel: 'Semantic lable',
                        semanticsValue: 'Semantic value',
                        strokeWidth: 2.5,
                      ),
                      Text('Copying... ${model.currentFile}')
                    ],
                  )
                ]),
              ),
            ));
  }
}
