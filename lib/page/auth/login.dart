part of '../pages.dart';

class LoginPage extends StatefulWidget {
  final bool? isDokter;
  const LoginPage({Key? key, required this.isDokter}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _emailValid = false;
  bool _passValid = false;

  late Size size;
  double height = 0;
  double width = 0;

  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();

  final FocusNode _fnEmail = FocusNode();
  final FocusNode _fnPassword = FocusNode();

  bool? get isDokter => widget.isDokter;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _txtEmail.dispose();
    _txtPassword.dispose();

    _fnEmail.dispose();
    _fnPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              "assets/login.png",
                              fit: BoxFit.cover,
                              height: 250,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                ),
                                color: AppTheme.darkerPrimaryColor,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 56),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          " Email",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        TextFormField(
                                          focusNode: _fnEmail,
                                          controller: _txtEmail,
                                          maxLength: 30,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'You must fill this field';
                                            }

                                            return null;
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            filled: true,
                                            counterText: "",
                                            fillColor: Colors.white,
                                            hintText: 'email@gmail.com',
                                            errorStyle: const TextStyle(
                                              color: Colors.amber,
                                            ),
                                          ),
                                          onChanged: (value) {
                                            if (EmailValidator.validate(
                                                    value) &&
                                                !_emailValid) {
                                              setState(() {
                                                _emailValid = true;
                                              });
                                            }
                                          },
                                          onFieldSubmitted: (value) {
                                            setState(() {
                                              _emailValid =
                                                  EmailValidator.validate(
                                                value,
                                              );
                                            });
                                            FocusScope.of(context)
                                                .requestFocus(_fnPassword);
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          " Password",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        TextFormField(
                                          focusNode: _fnPassword,
                                          controller: _txtPassword,
                                          maxLength: 16,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            filled: true,
                                            counterText: "",
                                            fillColor: Colors.white,
                                            hintText: 'Password',
                                            errorStyle: const TextStyle(
                                              color: Colors.amber,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'You must fill this field';
                                            }

                                            return null;
                                          },
                                          onChanged: (value) {
                                            if (value.length > 6 &&
                                                !_passValid) {
                                              setState(() {
                                                _passValid = true;
                                              });
                                            }
                                          },
                                          onFieldSubmitted: (value) {
                                            if (value.length > 6) {
                                              setState(() {
                                                _passValid = true;
                                              });
                                            }
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                        const SizedBox(height: 18),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Or",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      InkWell(
                                        onTap: () {
                                          if (isDokter!) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterDoctorPage(),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterPage(),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Register a new account",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 16,
                                  ),
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )
                                      : SizedBox(
                                          width: width / 2.5,
                                          height: height / 18,
                                          child: MaterialButton(
                                            onPressed: _emailValid && _passValid
                                                ? () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    if (!_formKey.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      return;
                                                    }

                                                    try {
                                                      await FirebaseAuth
                                                          .instance
                                                          .signInWithEmailAndPassword(
                                                              email: _txtEmail
                                                                  .text,
                                                              password:
                                                                  _txtPassword
                                                                      .text);

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Login Success, redirecting..."),
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Incorrect email or password"),
                                                        ),
                                                      );
                                                    }

                                                    if (mounted) {
                                                      setState(() {
                                                        _isLoading = false;
                                                        _emailValid = false;
                                                        _passValid = false;
                                                        _txtPassword.clear();
                                                        _txtEmail.clear();
                                                      });
                                                    }
                                                  }
                                                : null,
                                            child: const Text("Login"),
                                            color: AppTheme.secondaryColor,
                                            textColor: Colors.black,
                                            disabledColor: Colors.grey.shade300,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: height / 36.6,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
