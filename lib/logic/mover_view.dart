import 'package:flutter/material.dart';
import 'package:resources_mover/logic/mover_vm.dart';
import 'package:stacked/stacked.dart';

class MoverView extends StatelessWidget {
  const MoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MoverViewModel>.reactive(
      viewModelBuilder: () => MoverViewModel(),
      onModelReady: (model) {
        model.onReady();
      },
      builder: (context, model, child) => Scaffold(
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('SDK textures folder'),
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: SizedBox(
                      height: 50,
                      width: 500,
                      child: TextField(
                        readOnly: true,
                        controller: model.sourcePathController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: model.openSourceFolder,
                      child: const Text('Open')),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Game textures folder'),
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: SizedBox(
                      height: 50,
                      width: 500,
                      child: TextField(
                        readOnly: true,
                        controller: model.targetPathController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: model.openTargetFolder,
                      child: const Text('Open')),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Game .log file'),
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: SizedBox(
                      height: 50,
                      width: 500,
                      child: TextField(
                        readOnly: true,
                        controller: model.logFilePathController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: model.openLogFile, child: const Text('Open')),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: model.startButtonActive
                      ? () => model.startCopy(context)
                      : null,
                  child: const Text('Start copy')),
              ElevatedButton(
                  onPressed: model.openLog, child: Text('Open NOT_FOUND file'))
            ],
          ),
          Text(model.message),
          Text('Current: ${model.currentTexture}'),
          LinearProgressIndicator(
            value: model.value,
          )
        ]),
      ),
    );
  }
}
