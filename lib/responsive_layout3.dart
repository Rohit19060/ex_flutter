import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        builder: (context, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
          ),
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        ),
        designSize: const Size(360, 640),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const purpleColor = Color(0xff6688FF);
  static const darkTextColor = Color(0xff1F1A3D);
  static const lightTextColor = Color(0xff999999);
  static const textFieldColor = Color(0xffF5F6FA);
  static const borderColor = Color(0xffD9D9D9);

  Widget getTextField({required String hint}) => TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          filled: true,
          fillColor: textFieldColor,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 52.h,
                ),
                Text(
                  'Sign Up to Masterminds',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: darkTextColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: lightTextColor,
                      ),
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: purpleColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.h,
                ),
                getTextField(hint: 'Full Name'),
                SizedBox(height: 16.h),
                getTextField(hint: 'Email'),
                SizedBox(height: 16.h),
                getTextField(hint: 'Password'),
                SizedBox(height: 16.h),
                getTextField(hint: 'Confirm Password'),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purpleColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 14.h)),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    child: const Text('Create Account'),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      'or sign up via',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: lightTextColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            const BorderSide(color: borderColor)),
                        foregroundColor:
                            MaterialStateProperty.all(darkTextColor),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 14.h)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w700))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/Google.png'),
                        SizedBox(width: 10.w),
                        const Text('Google'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  children: [
                    Text(
                      'By signing up to Masterminds you agree to our ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: lightTextColor,
                      ),
                    ),
                    Text(
                      'terms and conditions',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: purpleColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(ColorProperty('textFieldColor', textFieldColor));
    properties.add(ColorProperty('lightTextColor', lightTextColor));
    properties.add(ColorProperty('darkTextColor', darkTextColor));
    properties.add(ColorProperty('purpleColor', purpleColor));
  }
}
