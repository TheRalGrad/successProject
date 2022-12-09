part of '../pages.dart';

class EditDoctorProfile extends StatefulWidget {
  final Doctor? admin;
  const EditDoctorProfile({Key? key, required this.admin}) : super(key: key);

  @override
  _EditDoctorProfileState createState() => _EditDoctorProfileState();
}

class _EditDoctorProfileState extends State<EditDoctorProfile> {
  Doctor? get admin => widget.admin;

  bool _isLoading = false;

  int? _radioValue = 0;

  String _genderValue = 'Male';

  String? selectedSpecialist = "Accounting  Manager";
  List<String> specialist = [
    "Accounting  Manager",
    "Accounting Supervisor",
    "Administrative Assistant",
    "Administrative Manager",
    "Air Hostess",
    "Assistant Accounting Manager",
    "Audio Video Engineer",
    "Customer",
    "Dentist",
    "Driver",
    "Electrician",
    "Finance",
    "General practitioners",
    "Guard",
    "guide",
    "Maintenance & Repair Technician",
    "Mechanic",
    "Surgeon",
    "Waitress"
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtAddress = TextEditingController();
  final TextEditingController _txtPhoneNumber = TextEditingController();
  final TextEditingController _txtBankAccount = TextEditingController();

  final FocusNode _fnName = FocusNode();
  final FocusNode _fnEmail = FocusNode();
  final FocusNode _fnAddress = FocusNode();
  final FocusNode _fnPhoneNumber = FocusNode();
  final FocusNode _fnBankAccount = FocusNode();

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value;
    });
    switch (_radioValue) {
      case 0:
        _genderValue = 'Male';
        break;
      case 1:
        _genderValue = 'Female';
        break;
    }
  }

  List<DropdownMenuItem> generateItems(List<String> spesialis) {
    List<DropdownMenuItem> items = [];
    for (var item in spesialis) {
      items.add(
        DropdownMenuItem(
          child: Text(item),
          value: item,
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    _txtName.text = admin!.name!;
    _txtEmail.text = admin!.email!;
    _txtAddress.text = admin!.address!;
    _txtPhoneNumber.text = admin!.phoneNumber!;
    _txtBankAccount.text = admin!.bankAccount!;
    selectedSpecialist = admin!.specialist;
    _radioValue = admin!.gender == 'Male' ? 0 : 1;
    _genderValue = admin!.gender!;
    super.initState();
  }

  @override
  void dispose() {
    _txtName.dispose();
    _txtEmail.dispose();
    _txtAddress.dispose();
    _txtPhoneNumber.dispose();
    _txtBankAccount.dispose();

    _fnName.dispose();
    _fnEmail.dispose();
    _fnAddress.dispose();
    _fnPhoneNumber.dispose();
    _fnBankAccount.dispose();
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Toolbar(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: const Center(
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppTheme.darkerPrimaryColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 18.0),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.white),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      "Full Name",
                                    ),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      keyboardType: TextInputType.name,
                                      controller: _txtName,
                                      focusNode: _fnName,
                                      maxLength: 30,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                      readOnly: true,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        filled: true,
                                        counterText: "",
                                        fillColor: Colors.white,
                                        hintText: 'example@gmail.com',
                                        errorStyle: const TextStyle(
                                          color: Colors.amber,
                                        ),
                                      ),
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(_fnPhoneNumber);
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Phone Number",
                                    ),
                                    const SizedBox(height: 4),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                      "Address",
                                    ),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      focusNode: _fnAddress,
                                      controller: _txtAddress,
                                      keyboardType: TextInputType.streetAddress,
                                      maxLength: 50,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        filled: true,
                                        counterText: "",
                                        fillColor: Colors.white,
                                        hintText: 'Address',
                                        errorStyle: const TextStyle(
                                          color: Colors.amber,
                                        ),
                                      ),
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Gender",
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 0,
                                          groupValue: _radioValue,
                                          fillColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.white),
                                          onChanged: _handleRadioValueChange,
                                        ),
                                        const Text(
                                          'Male',
                                        ),
                                        Radio(
                                          value: 1,
                                          groupValue: _radioValue,
                                          fillColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.white),
                                          onChanged: _handleRadioValueChange,
                                        ),
                                        const Text(
                                          'Female',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Choose Specialist",
                                    ),
                                    const SizedBox(height: 4),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          value: selectedSpecialist,
                                          items: generateItems(specialist),
                                          onChanged: (dynamic item) {
                                            setState(() {
                                              selectedSpecialist = item;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Bank Account",
                                    ),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      focusNode: _fnBankAccount,
                                      controller: _txtBankAccount,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CardNumberFormatter(),
                                        LengthLimitingTextInputFormatter(19),
                                      ],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        filled: true,
                                        counterText: "",
                                        fillColor: Colors.white,
                                        hintText: 'Bank Account',
                                        errorStyle: const TextStyle(
                                          color: Colors.amber,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'You must fill this field';
                                        }

                                        if (value.length <= 9) {
                                          return 'Must more than 9 char';
                                        }

                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                    const SizedBox(height: 22.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _isLoading
                                            ? const CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              )
                                            : MaterialButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });

                                                  await _editProfile();

                                                  setState(() {
                                                    _isLoading = false;
                                                  });

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Edit Profile Success"),
                                                    ),
                                                  );

                                                  Navigator.of(context).pop();
                                                },
                                                child:
                                                    const Text("Edit Profile"),
                                                color: AppTheme.secondaryColor,
                                                textColor: Colors.black,
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  _editProfile() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_genderValue == "") {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must choose gender"),
        ),
      );
      return;
    }

    if (selectedSpecialist == "") {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must choose Specialist"),
        ),
      );
      return;
    }

    try {
      Map<String, dynamic> data = {
        'doc_id': admin!.uid,
        'name': _txtName.text,
        'email': _txtEmail.text,
        'phone_number': _txtPhoneNumber.text,
        'address': _txtAddress.text,
        'gender': _genderValue,
        'specialist': selectedSpecialist,
        'bank_account': _txtBankAccount.text,
        'is_busy': false,
        'profile_url': admin!.profileUrl,
      };

      await FirebaseFirestore.instance.doc('admin/${admin!.uid}').update(data);

      Doctor newData = Doctor.fromJson(data);
      Provider.of<DoctorProvider>(context, listen: false).setDoctor = newData;
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
