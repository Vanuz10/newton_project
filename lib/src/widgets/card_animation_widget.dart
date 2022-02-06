import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';



class CardAnimation extends StatefulWidget {
  final String riveFileName;
  final String animationName;

  const CardAnimation({Key? key, required this.riveFileName, required this.animationName}) : super(key: key);


  @override
  _CardAnimationState createState() => _CardAnimationState();
}

class _CardAnimationState extends State<CardAnimation> {
  // final riveFileName = 'assets/dinamica_rot.riv';

  Artboard? _riveArtboard;
  // RiveAnimationController _controller;

  @override
  void initState() {
    
    super.initState();
    
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    rootBundle.load(widget.riveFileName).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(SimpleAnimation(widget.animationName));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _artboard.addController(
    //       _wipersController = SimpleAnimation("RDAnim"),
    //     );
    return (_riveArtboard == null)
      ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black.withOpacity(0.25))
        ) 
      )
      : Rive(
        artboard: _riveArtboard!,
        fit: BoxFit.contain,
        alignment: Alignment.center,

      );
      
    
  }
}


// class CardAnimation extends StatefulWidget {
//   final String riveFileName;
//   final String animationName;

//   const CardAnimation({Key key, this.riveFileName, this.animationName}) : super(key: key);


//   @override
//   _CardAnimationState createState() => _CardAnimationState();
// }

// class _CardAnimationState extends State<CardAnimation> {
//   // final riveFileName = 'assets/dinamica_rot.riv';

//   Artboard _artboard;
//   // RiveAnimationController _wipersController; 

//   @override
//   void initState() {
    
//     super.initState();
    
//     _loadRiveFile();
//   }

//   void _loadRiveFile() async {
//     final bytes = await rootBundle.load(widget.riveFileName);
//     final file = RiveFile();
//     if (file.import(bytes)) {
//       setState(() => _artboard = file.mainArtboard..addController(SimpleAnimation(widget.animationName)));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _artboard.addController(
//     //       _wipersController = SimpleAnimation("RDAnim"),
//     //     );
//     return (_artboard == null)
//       ? Center(
//         child: CircularProgressIndicator(
//           valueColor: new AlwaysStoppedAnimation<Color>(Colors.black.withOpacity(0.25))
//         ) 
//       )
//       : Rive(
//         artboard: _artboard,
//         fit: BoxFit.contain,
//         alignment: Alignment.center,

//       );
      
    
//   }
// }

