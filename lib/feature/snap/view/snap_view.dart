import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snap_fit/feature/snap/bloc/snap_bloc.dart';

class SnapView extends StatelessWidget {
  const SnapView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        double snapBoxWidth = context.select<SnapBloc, double>((snap) => snap.state.width.toDouble());

        double startSeparatorPosition = (constrains.maxWidth - snapBoxWidth - 40) / 2;

        context.read<SnapBloc>().add(SnapSetSeparatorPositionEvent(position: startSeparatorPosition));
        return BlocConsumer<SnapBloc, SnapState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error!),
                showCloseIcon: true,
                duration: Duration(milliseconds: 9999),
              ));
            }
          },
          builder: (context, state) {
            double snapBoxWidthFactor =
                (state.width + (startSeparatorPosition - (state.separatorPosition ?? startSeparatorPosition)))
                    .clamp(0, state.width);

            if (state.processedSnap != null) FileImage(state.processedSnap!).evict();

            return Center(
              child: state.originalSnap == null
                  ? const Text('Перетягни зображення сюди')
                  : Stack(
                      children: [
                        OverflowBox(
                          maxWidth: state.width,
                          maxHeight: state.height,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.scale(
                                scale: state.snapScale,
                                child: SizedBox(
                                  width: state.width,
                                  height: state.height,
                                  child: Image.file(
                                    state.originalSnap!,
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.cover,
                                    width: state.width,
                                    height: state.height,
                                  ),
                                ),
                              ),
                              if (state.processedSnap != null) ...[
                                Positioned(
                                  right: 0,
                                  child: ClipRect(
                                    child: SizedBox(
                                      width: snapBoxWidthFactor,
                                      height: state.height,
                                      child: OverflowBox(
                                        alignment: Alignment.centerRight,
                                        maxWidth: state.width,
                                        maxHeight: state.height,
                                        child: Transform.scale(
                                          scale: state.snapScale,
                                          child: SizedBox(
                                            width: state.width,
                                            height: state.height,
                                            child: Image.file(
                                              state.processedSnap!,
                                              key: ValueKey(state.processedSnap!.lastModifiedSync()),
                                              width: state.width,
                                              height: state.height,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.loading) ...[
                                  const Positioned.fill(child: Center(child: CircularProgressIndicator()))
                                ]
                              ] else
                                const Positioned.fill(child: Center(child: CircularProgressIndicator())),
                            ],
                          ),
                        ),
                        if (state.processedSnap != null) ...[_Separator()],
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snapBloc = context.read<SnapBloc>();

    return OverflowBox(
      maxHeight: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            left: snapBloc.state.separatorPosition,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                snapBloc.add(SnapUpdateSeparatorPositionEvent(position: details.delta.dx));
              },
              child: Container(
                width: 40,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    color: Colors.black.withOpacity(.57),
                    width: 10,
                    child: OverflowBox(
                      maxWidth: 50,
                      child: Center(
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.black.withOpacity(.57),
                          child: const Icon(
                            Icons.compare_arrows_rounded,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
