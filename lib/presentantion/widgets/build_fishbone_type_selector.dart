import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:provider/provider.dart';

class FishboneTypeSelector extends StatefulWidget {
  const FishboneTypeSelector({super.key});

  @override
  State<FishboneTypeSelector> createState() => _FishboneTypeSelectorState();
}

class _FishboneTypeSelectorState extends State<FishboneTypeSelector> {
  bool showPanel = true;

  @override
  void didChangeDependencies() {
    print("changed.......");
    super.didChangeDependencies();
    final provider = Provider.of<DrawingProvider>(context);
    if (provider.currentShape == ShapeType.fishbone && !showPanel) {
      setState(() {
        showPanel = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 60,
      top: 0,
      child: Consumer<DrawingProvider>(
        builder: (context, provider, _) {
          if (provider.currentShape != ShapeType.fishbone) return SizedBox();

          return !showPanel
              ? SizedBox()
              : Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    // width: MediaQuery.of(context).size.width * 0.8,
                    // width: 500,
                    constraints: BoxConstraints(
                      maxWidth: 300,
                      // maxWidth:MediaQuery.of(context).size.width * 0.8
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xb5b5b5).withOpacity(1),
                          offset: Offset(1, 1),
                          blurRadius: 11,
                          spreadRadius: -3,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 0, bottom: 10),
                                    child: Text(
                                      'Ploting Type:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  // Section-wise content
                                  ...sectionMapping.entries.map(
                                    (section) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            margin: EdgeInsets.only(left: 2),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0, vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.black,
                                            ),
                                            child: Text(
                                              sectionTitles[section.key] ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IntrinsicWidth(
                                          child: Column(
                                            spacing: 3,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ...section.value.map(
                                                (type) => Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0),
                                                    child: DottedBorder(
                                                      borderType:
                                                          BorderType.RRect,
                                                      radius:
                                                          const Radius.circular(
                                                              12),
                                                      child: Container(
                                                        // constraints: BoxConstraints(
                                                        //   minHeight: 100,
                                                        //   minWidth: 100,
                                                        // ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        // height: 100,
                                                        // constraints: const BoxConstraints(
                                                        //   minWidth: 100,
                                                        // ),
                                                        child: Row(
                                                          spacing: 8,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Radio(
                                                              visualDensity: const VisualDensity(
                                                                  horizontal:
                                                                      VisualDensity
                                                                          .minimumDensity,
                                                                  vertical:
                                                                      VisualDensity
                                                                          .minimumDensity),
                                                              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                                                              fillColor:
                                                                  WidgetStateProperty
                                                                      .all(Colors
                                                                          .black),
                                                              value: type,
                                                              groupValue: provider
                                                                  .currentFishboneType,
                                                              onChanged:
                                                                  (FishboneType?
                                                                      value) {
                                                                if (value !=
                                                                    null) {
                                                                  provider
                                                                      .setFishboneType(
                                                                          value);
                                                                }
                                                              },
                                                              focusNode:
                                                                  FocusNode(),
                                                              autofocus: true,
                                                            ),
                                                            Image.asset(
                                                              "assets/images/1.png",
                                                              height: 15,
                                                              width: 30,
                                                            ),
                                                            Wrap(
                                                              children: [
                                                                Text(
                                                                  type.name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            // SizedBox(height: 2),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Add spacing between sections
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            child: NIconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () {
                                  setState(() {
                                    showPanel = false;
                                  });
                                }))
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

// Add this enum at the top of your file
enum FishboneSection {
  mineTypes,
  impactTypes,
  contributors,
}
