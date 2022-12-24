import 'package:flutter/material.dart';

void showActivityIndicator(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Container(
                height: 60.0,
                width: 60.0,
                color: Colors.transparent,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      )),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff435EE6))),
                    ),
                  ),
                )),
          ),
        );
      });
}

void hideActivityIndicator(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
