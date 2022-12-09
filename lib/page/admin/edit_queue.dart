part of '../pages.dart';

class EditQueue extends StatefulWidget {
  final Queue queue;
  const EditQueue({Key? key, required this.queue}) : super(key: key);

  @override
  _EditQueueState createState() => _EditQueueState();
}

class _EditQueueState extends State<EditQueue> {
  Queue get queue => widget.queue;

  bool _isLoading = false;

  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtPhoneNumber = TextEditingController();
  final TextEditingController _txtNumber = TextEditingController();

  final FocusNode _fnName = FocusNode();
  final FocusNode _fnPhoneNumber = FocusNode();
  final FocusNode _fnNumber = FocusNode();

  @override
  void initState() {
    _txtName.text = queue.transactionData!.createdBy!.name!;
    _txtPhoneNumber.text = queue.transactionData!.createdBy!.phoneNumber!;
    _txtNumber.text = queue.queueNumber.toString();
    super.initState();
  }

  @override
  void dispose() {
    _txtName.dispose();
    _txtPhoneNumber.dispose();
    _txtNumber.dispose();

    _fnName.dispose();
    _fnPhoneNumber.dispose();
    _fnNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
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
                              "Edit Queue",
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
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 18.0),
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text("Name"),
                                const SizedBox(height: 4.0),
                                TextFormField(
                                  focusNode: _fnName,
                                  controller: _txtName,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                const Text("Phone Number"),
                                const SizedBox(height: 4.0),
                                TextFormField(
                                  focusNode: _fnPhoneNumber,
                                  controller: _txtPhoneNumber,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                const Text("Queue Number"),
                                const SizedBox(height: 4.0),
                                TextFormField(
                                  focusNode: _fnNumber,
                                  controller: _txtNumber,
                                  maxLength: 16,
                                  keyboardType: TextInputType.number,
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
                                    hintText: 'Queue Number',
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
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                                const SizedBox(height: 22.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _isLoading
                                        ? const CircularProgressIndicator()
                                        : MaterialButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              await _editQueue();

                                              setState(() {
                                                _isLoading = false;
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Queue Number Updated"),
                                                ),
                                              );

                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Edit"),
                                            color: AppTheme.warningColor,
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
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                  ],
                                )
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
          );
        },
      ),
    );
  }

  _editQueue() async {
    int? queueNumber = int.tryParse(_txtNumber.text);
    if (queueNumber == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("0 is not valid Queue Number"),
        ),
      );
      return;
    }

    await Provider.of<QueueProvider>(context, listen: false).updateQueueNumber(
      adminId: queue.transactionData!.adminProfile!.uid,
      queueId: queue.docId,
      number: queueNumber,
    );
    await Provider.of<QueueProvider>(context, listen: false)
        .getAllQueue(queue.transactionData!.adminProfile!.uid);
  }
}
