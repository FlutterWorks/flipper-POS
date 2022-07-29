import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'gerror_message.dart';

class NoNet extends StatelessWidget {
  const NoNet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GErrorMessage(
        icon: const Icon(Icons.wifi_off_outlined),
        title: "No internet",
        subtitle:
            "Can't connect to the internet.\nPlease check your internet connection",
        onPressed: () async {
          GoRouter.of(context).push("/login");
          GoRouter.of(context).refresh();
        },
      ),
    );
  }
}
