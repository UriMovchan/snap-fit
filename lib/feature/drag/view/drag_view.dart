import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:snap_fit/feature/drag/bloc/drag_bloc.dart';
import 'package:snap_fit/feature/snap/bloc/snap_bloc.dart';

class DragView extends StatelessWidget {
  final Widget? child;

  const DragView({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DragBloc, DragState>(
      builder: (context, state) {
        final dragBloc = context.read<DragBloc>();
        final snapBloc = context.read<SnapBloc>();

        return DropTarget(
          onDragEntered: (details) {
            dragBloc.add(EnterDragEvent());
          },
          onDragExited: (details) {
            dragBloc.add(ExitDragEvent());
          },
          onDragDone: (details) async {
            if (details.files.isNotEmpty) {
              final file = details.files.first;

              final allowedMimeTypes = ['image/png', 'image/jpeg', 'image/webp'];
              final mimeType = lookupMimeType(file.path);

              if (mimeType != null && allowedMimeTypes.contains(mimeType)) {
                snapBloc.add(SnapDropEvent(File(file.path)));
              } else {
                snapBloc.add(SnapErrorEvent('Не правильний формат файлу'));
              }
            }

            dragBloc.add(ExitDragEvent());
          },
          child: Stack(
            children: [
              if (child != null) child!,
              if (state is EnteredDragState) ...[
                OverflowBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(35),
                    child: DottedBorder(
                      color: Colors.green.shade500,
                      strokeWidth: 3,
                      dashPattern: const [7, 11],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      child: const Center(
                        child: Text(
                          'Відпусти..',
                          style: TextStyle(color: Colors.lightGreenAccent, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ],
          ),
        );
      },
    );
  }
}
