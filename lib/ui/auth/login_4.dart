import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Login Screen UI Challenge',
                theme: ThemeData(),
                home: LoginScreen(),
              );
            },
          ));
}

class SizeConfig {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print(_blockWidth);
    print(_blockHeight);
    print(_screenWidth);
  }
}

const BoxDecoration containerGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE35300),
      Color(0xFFF27406),
    ],
  ),
);

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildTopContainer(),
          _buildBottomContainer(
            screenHeight,
            screenWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildTopContainer() => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          left: 7.29 * SizeConfig.widthMultiplier,
          top: 7.32 * SizeConfig.heightMultiplier,
        ),
        decoration: containerGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 4.40 * SizeConfig.textMultiplier,
              ),
            ),
            SizedBox(
              height: 1.17 * SizeConfig.heightMultiplier,
            ),
            Text(
              'Welcome Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 2.92 * SizeConfig.textMultiplier,
              ),
            ),
          ],
        ),
      );

  Widget _buildBottomContainer(double screenHeight, double screenWidth) =>
      ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(11.74 * SizeConfig.heightMultiplier),
        ),
        child: Container(
          color: Colors.white,
          height: screenHeight * 0.72,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 9 * SizeConfig.widthMultiplier,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 9.71 * SizeConfig.heightMultiplier,
              ),
              _buildTextFields(),
              SizedBox(
                height: 6 * SizeConfig.heightMultiplier,
              ),
              Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 2.34 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier,
              ),
              BuildButton(
                width: screenWidth * 0.35,
                onPressed: () {},
                title: 'Login',
                buttonColor: const Color(0xFFE65100),
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier,
              ),
              Text(
                'Continue with social media',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 2.1 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5 * SizeConfig.heightMultiplier,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildButton(
                    width: screenWidth * 0.35,
                    onPressed: () {},
                    title: 'Facebook',
                    buttonColor: Colors.blue,
                  ),
                  BuildButton(
                    width: screenWidth * 0.35,
                    onPressed: () {},
                    title: 'Github',
                    buttonColor: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildTextFields() => Container(
        padding: EdgeInsets.all(1.94 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            2.92 * SizeConfig.heightMultiplier,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade300,
              blurRadius: 15,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            const BuildTextField(
              hintText: 'Email or Phone number',
            ),
            Divider(color: Colors.grey[800]),
            const BuildTextField(
              hintText: 'Password',
              isPasswordField: true,
              obscureText: true,
            ),
          ],
        ),
      );
}

enum ButtonType { onlyText, withIconText }

class BuildButton extends StatelessWidget {
  const BuildButton({
    super.key,
    required this.buttonColor,
    this.textColor = Colors.black,
    this.elevation = 5.0,
    required this.title,
    required this.width,
    required this.onPressed,
  });
  final Color buttonColor;
  final Color textColor;
  final double elevation;
  final String title;
  final double width;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: buttonColor,
            elevation: elevation,
            padding: EdgeInsets.symmetric(
              vertical: 2.2 * SizeConfig.heightMultiplier,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(4.4 * SizeConfig.heightMultiplier),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.63 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Function>('onPressed', onPressed));
    properties.add(DoubleProperty('width', width));
    properties.add(StringProperty('title', title));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(ColorProperty('textColor', textColor));
    properties.add(ColorProperty('buttonColor', buttonColor));
  }
}

class BuildTextField extends StatefulWidget {
  const BuildTextField({
    super.key,
    required this.hintText,
    this.prefixIcon = Icons.email,
    this.obscureText = false,
    this.isPasswordField = false,
    this.keyBoardType = TextInputType.name,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
  });
  final String hintText;
  final IconData prefixIcon;
  final bool isPasswordField;
  final bool obscureText;
  final TextInputType keyBoardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties
        .add(EnumProperty<TextInputAction>('textInputAction', textInputAction));
    properties
        .add(DiagnosticsProperty<TextInputType>('keyBoardType', keyBoardType));
    properties.add(DiagnosticsProperty<bool>('obscureText', obscureText));
    properties
        .add(DiagnosticsProperty<bool>('isPasswordField', isPasswordField));
    properties.add(DiagnosticsProperty<IconData>('prefixIcon', prefixIcon));
    properties.add(StringProperty('hintText', hintText));
  }
}

class _BuildTextFieldState extends State<BuildTextField> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          prefixIcon: widget.isPasswordField
              ? InkWell(
                  child: IconButton(
                    icon: Icon(
                      widget.obscureText ? Icons.lock : Icons.lock_open,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () => setState(() {
                      obscureText = !obscureText;
                    }),
                  ),
                )
              : Icon(
                  widget.prefixIcon,
                  color: Colors.deepOrange,
                ),
        ),
        cursorColor: Colors.deepOrange,
        obscureText: widget.obscureText,
        keyboardType: widget.keyBoardType,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('obscureText', obscureText));
  }
}
