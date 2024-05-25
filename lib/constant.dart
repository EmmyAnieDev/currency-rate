import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final kTextStyle1 = TextStyle(
  color: Colors.white,
  fontSize: 35.sp,
  fontWeight: FontWeight.bold,
);

final kTextStyle2 = TextStyle(
  color: Colors.yellow,
  fontSize: 28.sp,
  fontWeight: FontWeight.bold,
);

final kTextStyle3 = TextStyle(
  color: Colors.yellow,
  fontSize: 18.sp,
  fontWeight: FontWeight.bold,
);

final kTextStyle4 = TextStyle(
  color: Colors.white,
  fontSize: 18.sp,
  fontWeight: FontWeight.bold,
);

final kTextStyle5 = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 18.sp,
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter amount',
  hintStyle: TextStyle(color: Colors.white24),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
);
