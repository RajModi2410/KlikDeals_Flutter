import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebdeskWidget extends StatelessWidget {
  const WebdeskWidget({Key key}) : super(key: key);

  final String urlToLoad = "https://www.webdesksolution.com";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () async {
                bool canLaunches = await canLaunch(urlToLoad);
                if (canLaunches) {
                  await launch(urlToLoad, forceWebView: true);
                } else {
                  throw 'Could not launch $urlToLoad';
                }
              },
              child: Text(
                "Developed by: WebDesk Solution Ltd",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.grey),
              ),
            ),
          ),
        )
      ],
    );
  }
}
