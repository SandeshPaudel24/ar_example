import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
// import 'package:ar_flutter_plugin/models/ar_types.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Example',
      home: ARScreen(),
    );
  }
}

class ARScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? localObjectNode;
  ARNode? webObjectNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Example'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: onLocalObjectButtonPressed,
              child: Text(localObjectNode != null
                  ? 'Remove Local Object'
                  : 'Add Local Object'),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: onWebObjectButtonPressed,
              child: Text(webObjectNode != null
                  ? 'Remove Web Object'
                  : 'Add Web Object'),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arObjectManager = arObjectManager;
    this.arSessionManager = arSessionManager;

    this.arSessionManager.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "image",
          showWorldOrigin: true,
          handleTaps: false,
        );
  }

  Future<void> onLocalObjectButtonPressed() async {
    if (localObjectNode != null) {
      arObjectManager.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(
        type: NodeType.localGLTF2,
        // addd image in gltf . its means graphic language transmission formate which contains ASCII fromate for camera material
        uri: "image_in_gltf",
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );
      bool? didAddLocalNode = await arObjectManager.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
    setState(() {});
  }

  Future<void> onWebObjectButtonPressed() async {
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
        // GLB means graphic lanaguage binary formate which store in  binary formate
        type: NodeType.webGLB,
        uri:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        scale: Vector3(0.2, 0.2, 0.2),
      );
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
    setState(() {});
  }
}
