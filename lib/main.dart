import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:snap_fit/component/checkerboard/checkerboard.dart';
import 'package:snap_fit/feature/drag/bloc/drag_bloc.dart';
import 'package:snap_fit/feature/drag/view/drag_view.dart';
import 'package:snap_fit/feature/fit/bloc/fit_bloc.dart';
import 'package:snap_fit/feature/fit/view/fit_view.dart';
import 'package:snap_fit/feature/header/header.dart';
import 'package:snap_fit/feature/snap/bloc/snap_bloc.dart';
import 'package:snap_fit/feature/snap/view/snap_view.dart';
import 'package:snap_fit/feature/theme/bloc/theme_bloc.dart';
import 'package:snap_fit/feature/theme/repository/theme_repository.dart';

import 'package:snap_fit/service/storage.dart';
import 'package:snap_fit/service/window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.init();
  await Window().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(ThemeRepository.themeModes),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState state) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('uk', '')],
            theme: ThemeRepository.light,
            darkTheme: ThemeRepository.dark,
            themeMode: state.themeMode,
            home: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => DragBloc()),
                BlocProvider(create: (context) => FitBloc()),
                BlocProvider(create: (context) => SnapBloc(fitBloc: context.read<FitBloc>())),
              ],
              child: Scaffold(
                appBar: const Header(),
                body: Checkerboard(
                  child: DragView(
                    child: Stack(
                      children: [
                        const SizedBox.expand(
                          child: SnapView(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const FitView(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _FooterLeftBox(),
                                _FooterCenterBox(),
                                _FooterRightBox(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FooterLeftBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: FloatingActionButton(
        child: const Icon(Icons.image_search_rounded, size: 30),
        onPressed: () => context.read<SnapBloc>().add(SnapPickEvent()),
      ),
    );
  }
}

class _FooterCenterBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SnapBloc snapBloc = context.watch<SnapBloc>();

    if (snapBloc.state.originalSnap == null) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: 33,
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 33,
                child: FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.remove, size: 17),
                  onPressed: () => snapBloc.add(SnapScaleEvent(scale: snapBloc.state.snapScale - 0.1)),
                ),
              ),
              SizedBox(width: 2),
              FloatingActionButton(
                onPressed: () => snapBloc.add(SnapScaleEvent(scale: 1)),
                child: Text((snapBloc.state.snapScale * 100).round().toString()),
              ),
              SizedBox(width: 2),
              SizedBox(
                width: 33,
                child: FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.add, size: 17),
                  onPressed: () => snapBloc.add(SnapScaleEvent(scale: snapBloc.state.snapScale + 0.1)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _FooterRightBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SnapBloc snapBloc = context.watch<SnapBloc>();

    if (snapBloc.state.originalSnap == null || snapBloc.state.processedSnap == null) {
      return Container();
    } else {
      final originalSize = ((snapBloc.state.originalSnap?.statSync().size ?? 0) / 1000).round();
      final processedSize = ((snapBloc.state.processedSnap?.statSync().size ?? 0) / 1000).round();

      int average;

      if (processedSize > originalSize) {
        average = ((processedSize - originalSize) / originalSize * 100).round();
      } else {
        average = ((originalSize - processedSize) / processedSize * 100).round();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 209,
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(text: originalSize.toString(), style: TextStyle(fontSize: 15)),
                        TextSpan(text: 'кБ', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  SizedBox(width: 7),
                  ClipPath(
                    clipper: Clipper(),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 3, right: 11),
                      decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(4)),
                      constraints: BoxConstraints(minWidth: 90),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            originalSize < processedSize ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            size: 17,
                          ),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(text: average.toString(), style: TextStyle(fontSize: 27)),
                                TextSpan(text: '%', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 7),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(text: processedSize.toString(), style: TextStyle(fontSize: 15)),
                        TextSpan(text: 'кБ', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: snapBloc.state.processedSnap != null ? () => snapBloc.add(SaveSnapEvent()) : null,
              child: const Icon(Icons.download, size: 30),
            ),
          ],
        ),
      );
    }
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - 15, 0);
    path.lineTo(size.width, size.height / 2 - 1);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height / 2 + 1);
    path.lineTo(size.width - 15, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
