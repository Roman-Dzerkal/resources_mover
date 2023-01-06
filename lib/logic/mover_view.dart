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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
          ElevatedButton(
              onPressed: model.startCopy, child: const Text('Start move')),
        ]),
      ),
    );
  }
}
