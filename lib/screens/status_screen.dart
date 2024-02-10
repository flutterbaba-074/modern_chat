import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_status_model.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer' as console show log;

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.statusData, required this.tag});
  final UserStatusModel statusData;
  final UniqueKey tag;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animate;
  double value = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animate = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addListener(animateProgressBar)
      ..forward().then((value) {
        Navigator.pop(context);
      });
  }

  void animateProgressBar() {
    value = _animate.value;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _animate.removeListener(animateProgressBar);

    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onLongPress: () {
          _animate.stop();
          console.log("long pressed");
        },
        onLongPressCancel: () {
          _animate.forward(from: value).then((value) {
            Navigator.pop(context);
          });
         
        },
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Hero(
              tag: widget.tag,
              child: CachedNetworkImage(
                imageUrl: widget.statusData.statusImage,
                progressIndicatorBuilder: (context, url, progress) {
                  return Container(
                    decoration: const BoxDecoration(color: Colors.black),
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  );
                },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.statusData.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Text(
                      Jiffy.parse(widget.statusData.statusTime)
                          .format(pattern: "dd MMM yyyy"),
                      style: const TextStyle(
                          fontFamily: "poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey.withOpacity(0.4),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
