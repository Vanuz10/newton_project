import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';


class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return LineChart(_createSampleData(),
      animate: false,
      animationDuration: const Duration(seconds:1),
      
      defaultRenderer: LineRendererConfig(
        strokeWidthPx: 4,
        
        roundEndCaps: true,
      ),
      behaviors: [
      // Optional - Configures a [LinePointHighlighter] behavior with a
      // vertical follow line. A vertical follow line is included by
      // default, but is shown here as an example configuration.
      //
      // By default, the line has default dash pattern of [1,3]. This can be
      // set by providing a [dashPattern] or it can be turned off by passing in
      // an empty list. An empty list is necessary because passing in a null
      // value will be treated the same as not passing in a value at all.
      LinePointHighlighter(
          showHorizontalFollowLine:
              LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine:
              LinePointHighlighterFollowLineType.nearest),
      // Optional - By default, select nearest is configured to trigger
      // with tap so that a user can have pan/zoom behavior and line point
      // highlighter. Changing the trigger to tap and drag allows the
      // highlighter to follow the dragging gesture but it is not
      // recommended to be used when pan/zoom behavior is enabled.
      SelectNearest(eventTrigger: SelectionTrigger.tapAndDrag)
    ]
    );
  }

  /// Create one series with sample hard coded data.
  
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

List<Series<List, double>> _createSampleData() {
  num deltax =-2;
  List<List<double>> lista=[];
  for (var i = 0; i < 43 ; i++) {
    num deltay= pow(deltax,2);
    lista.add([deltax.toDouble(),deltay.toDouble()]);
    deltax+=.01;
  }

    return [
      Series<List, double>(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
       
        domainFn: (List lista, _) => lista[0],
        measureFn: (List lista, _) => lista[1],
        data: lista,
      )
    ];
  }



