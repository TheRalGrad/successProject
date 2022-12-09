part of '../pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _txtname = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtAddress = TextEditingController();
  final TextEditingController _txtPhoneNumber = TextEditingController();

  final FocusNode _fnName = FocusNode();
  final FocusNode _fnEmail = FocusNode();
  final FocusNode _fnPassword = FocusNode();
  final FocusNode _fnAddress = FocusNode();
  final FocusNode _fnPhoneNumber = FocusNode();

  bool _isLoading = false;

  late Size size;
  double height = 0;
  double width = 0;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _txtname.dispose();
    _txtEmail.dispose();
    _txtPassword.dispose();
    _txtAddress.dispose();
    _txtPhoneNumber.dispose();

    _fnName.dispose();
    _fnEmail.dispose();
    _fnPassword.dispose();
    _fnAddress.dispose();
    _fnPhoneNumber.dispose();
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/register.png",
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                  Container(
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
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 56),
                          child: DefaultTextStyle(
                            style: const TextStyle(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Full Name",
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _txtname,
                                  focusNode: _fnName,
                                  maxLength: 30,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    filled: true,
                                    counterText: "",
                                    fillColor: Colors.white,
                                    hintText: 'Full Name',
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
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_fnEmail);
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Email",
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _txtEmail,
                                  focusNode: _fnEmail,
                                  maxLength: 30,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    filled: true,
                                    counterText: "",
                                    fillColor: Colors.white,
                                    hintText: 'example@gmail.com',
                                    errorStyle: const TextStyle(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'You must fill this field';
                                    }

                                    if (!EmailValidator.validate(value)) {
                                      return 'Email is invalid';
                                    }

                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_fnPassword);
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Password",
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  focusNode: _fnPassword,
                                  controller: _txtPassword,
                                  maxLength: 16,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
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

                                    if (value.length <= 6) {
                                      return 'Password must more than 6 char';
                                    }

                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_fnPhoneNumber);
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Phone Number",
                                ),
                                const SizedBox(height: 4.0),
                                TextFormField(
                                  focusNode: _fnPhoneNumber,
                                  controller: _txtPhoneNumber,
                                  maxLength: 16,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    counterText: "",
                                    fillColor: Colors.white,
                                    hintText: 'Phone Number',
                                    errorStyle: const TextStyle(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'You must fill this field';
                                    }

                                    if (value.length < 10 ||
                                        value.length > 16) {
                                      return 'Must more than 10 and less than 16';
                                    }

                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_fnAddress);
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Department",
                                ),
                                const SizedBox(height: 4.0),
                                TextFormField(
                                  focusNode: _fnAddress,
                                  controller: _txtAddress,
                                  keyboardType: TextInputType.streetAddress,
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    counterText: "",
                                    fillColor: Colors.white,
                                    hintText: 'Your department',
                                    errorStyle: const TextStyle(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : SizedBox(
                                height: height / 18,
                                width: width / 2.5,
                                child: MaterialButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    await _register();

                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      return;
                                    }
                                  },
                                  child: const Text("Register"),
                                  color: AppTheme.secondaryColor,
                                  textColor: Colors.black,
                                  disabledColor: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _register() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      //สร้าง new user
      final dataAuth =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _txtEmail.text,
        password: _txtPassword.text,
      );

      // User data
      Map<String, dynamic> data = {
        'doc_id': dataAuth.user!.uid,
        'name': _txtname.text,
        'email': _txtEmail.text,
        'phone_number': _txtPhoneNumber.text,
        'address': _txtAddress.text,
        'profile_url': "",
      };

      await FirebaseFirestore.instance.doc('users/${dataAuth.user!.uid}').set(
            data,
            SetOptions(merge: true),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register Success, redirecting..."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }
}
