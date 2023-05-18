import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:validators/validators.dart';

class CacheImage extends StatefulWidget {
  final BoxFit? fit;
  const CacheImage(this.url, {this.fit});
  final String? url;

  @override
  State<StatefulWidget> createState() {
    return _CacheImageState();
  }
}

class _CacheImageState extends State<CacheImage> {
  @override
  Widget build(BuildContext context) {
    //check if it is a online image
    bool isurl = widget.url!.startsWith("http") ? true : false;
    //check if it is an assets image
    bool isasset = isurl
        ? false
        : widget.url!.startsWith("assets")
            ? true
            : false;

    // debugPrint("Image status: isurl: $isurl  isasset: $isasset url: widget.url");

    return isurl
        ? CachedNetworkImage(
            imageUrl: isurl
                ? widget.url!
                : "http://www.netzerotools.com/assets/images/msa-10162695-workman-arc-flash-full-body-harness.png",
            placeholder: (context, url) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                ),
              );
            },
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: widget.fit ?? BoxFit.cover,
          )
        : Image(
            image: AssetImage(
              isasset ? widget.url! : "/assets/images/img/noImage.png",
            ),
            fit: BoxFit.fitWidth,
          );

    // Image.asset(
    //   isasset ? widget.url : "/assets/images/img/noImage.png",
    //   fit: BoxFit.fitWidth,
    // );
  }
}
