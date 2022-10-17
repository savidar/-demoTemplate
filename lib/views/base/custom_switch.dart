import 'dart:developer';

import 'package:flutter/material.dart';

import '../../services/enums/gender.dart';

class CustomSwitch<T> extends StatefulWidget {
  const CustomSwitch({Key? key, required this.items, required this.onChanged, this.enabled}) : super(key: key);

  final List<T> items;
  final Function(T value) onChanged;
  final bool? enabled;

  @override
  State<CustomSwitch<T>> createState() => _CustomSwitchState<T>();
}

class _CustomSwitchState<T> extends State<CustomSwitch<T>> {
  int _selectedItem = 0;
  AlignmentGeometry _alignment = const Alignment(-1, 0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // log("${constraints.maxWidth}");
        // log("${constraints.}");
        return Container(
          // width: size.width,
          decoration: BoxDecoration(
            color: const Color(0XFFF1F1F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 50),
                  child: Container(
                    height: 40,
                    width: (constraints.maxWidth) / widget.items.length,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF941F37),
                          Color(0xFF590012),
                        ],
                      ),
                    ),

                    // color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < widget.items.length; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.enabled ?? true) {
                              double x = -1;
                              double res = 2 / (widget.items.length - 1);
                              x += (res * i);
                              _selectedItem = i;
                              try {
                                widget.onChanged((widget.items[i]));
                              } catch (e) {
                                log('---- ${e.toString()} ----', name: "ERROR AT build()");
                              }
                              _alignment = Alignment(x, 0);
                              setState(() {});
                            }
                          },
                          // onHorizontalDragStart: (DragStartDetails? drag) {
                          //   log("${drag}");
                          // },
                          // onHorizontalDragEnd: (DragEndDetails? drag) {
                          //   log("${drag}");
                          // },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              // gradient: const LinearGradient(
                              //   begin: Alignment.topLeft,
                              //   end: Alignment.bottomRight,
                              //   colors: [
                              //     Color(0xFF941F37),
                              //     Color(0xFF590012),
                              //   ],
                              // ),
                            ),
                            child: Center(
                              child: Text(
                                widget.items[i].runtimeType == Gender ? (widget.items[i] as Gender).value : widget.items[i].toString(),
                                style: Theme.of(context).textTheme.headline2!.copyWith(color: _selectedItem == i ? Colors.white : null),
                              ),
                            ),

                            // color: Colors.grey,
                          ),
                        ),
                      ),
                    // Expanded(
                    //   child: Container(
                    //     height: 40,
                    //     child: const Center(
                    //       child: Text("Female"),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
