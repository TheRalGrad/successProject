part of '../pages.dart';

class ConsultationScheduleDetail extends StatefulWidget {
  final ConsultationSchedule schedule;
  const ConsultationScheduleDetail({Key? key, required this.schedule})
      : super(key: key);

  @override
  _ConsultationScheduleDetailState createState() =>
      _ConsultationScheduleDetailState();
}

class _ConsultationScheduleDetailState
    extends State<ConsultationScheduleDetail> {
  ConsultationSchedule get schedule => widget.schedule;

  final List<DaySchedule> _day = [
    DaySchedule(
      '1',
      1,
    ),
    DaySchedule(
      '2',
      2,
    ),
    DaySchedule(
      '3',
      3,
    ),
    DaySchedule(
      '4',
      4,
    ),
    DaySchedule(
      '5',
      5,
    ),
    DaySchedule(
      '6',
      6,
    ),
    DaySchedule(
      '7',
      7,
    ),
    DaySchedule(
      '8',
      8,
    ),
    DaySchedule(
      '9',
      9,
    ),
    DaySchedule(
      '10',
      10,
    ),
    DaySchedule(
      '11',
      11,
    ),
    DaySchedule(
      '12',
      12,
    ),
    DaySchedule(
      '13',
      13,
    ),
    DaySchedule(
      '14',
      14,
    ),
    DaySchedule(
      '15',
      15,
    ),
    DaySchedule(
      '16',
      16,
    ),
    DaySchedule(
      '17',
      17,
    ),
    DaySchedule(
      '18',
      18,
    ),
    DaySchedule(
      '19',
      19,
    ),
    DaySchedule(
      '20',
      20,
    ),
    DaySchedule(
      '21',
      21,
    ),
    DaySchedule(
      '22',
      22,
    ),
    DaySchedule(
      '23',
      23,
    ),
    DaySchedule(
      '24',
      24,
    ),
    DaySchedule(
      '25',
      25,
    ),
    DaySchedule(
      '26',
      26,
    ),
    DaySchedule(
      '27',
      27,
    ),
    DaySchedule(
      '28',
      28,
    ),
    DaySchedule(
      '29',
      29,
    ),
    DaySchedule(
      '30',
      30,
    ),
    DaySchedule(
      '31',
      31,
    ),
  ];

  final List<MonthSchedule> _month = [
    MonthSchedule(
      'January',
      1,
    ),
    MonthSchedule(
      'February',
      2,
    ),
    MonthSchedule(
      'March',
      3,
    ),
    MonthSchedule(
      'April',
      4,
    ),
    MonthSchedule(
      'May',
      5,
    ),
    MonthSchedule(
      'June',
      6,
    ),
    MonthSchedule(
      'Sunday',
      7,
    ),
    MonthSchedule(
      'July',
      8,
    ),
    MonthSchedule(
      'August',
      9,
    ),
    MonthSchedule(
      'September',
      10,
    ),
    MonthSchedule(
      'November',
      11,
    ),
    MonthSchedule(
      'December',
      12,
    ),
  ];

  DaySchedule? _selectedDay;
  MonthSchedule? _selectedMonth;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final TextEditingController _txtPrice = TextEditingController();
  final FocusNode _fnPrice = FocusNode();

  bool _isLoading = false;

  _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
        pickedTime.minute >= 30
            ? _endTime = pickedTime.replacing(
                hour: pickedTime.hour + 1,
                minute: pickedTime.minute - 30,
              )
            : _endTime = pickedTime.replacing(
                hour: pickedTime.hour,
                minute: pickedTime.minute + 30,
              );
      });
    }
  }

  Doctor? currentDoctor;

  @override
  void initState() {
    currentDoctor = Provider.of<DoctorProvider>(context, listen: false).admin;
    _selectedDay = _day.firstWhere(
        (element) => element.intValue == schedule.daySchedule!.intValue);
    _selectedMonth = _month.firstWhere(
        (element) => element.intValue1 == schedule.monthSchedule!.intValue1);
    _startTime = schedule.startAt;
    _endTime = schedule.endAt;
    _txtPrice.text = NumberFormat("#,###").format(schedule.price);
    super.initState();
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
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Work Schedule Detail",
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
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text("Pick Day"),
                                  const SizedBox(height: 4.0),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: DropdownButton<DaySchedule>(
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        value: _selectedDay,
                                        items: generateItems(_day),
                                        onChanged: (item) {
                                          setState(() {
                                            _selectedDay = item;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const Text("Pick Day"),
                                  const SizedBox(height: 4.0),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: DropdownButton<MonthSchedule>(
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        value: _selectedMonth,
                                        items: generateItems1(_month),
                                        onChanged: (item) {
                                          setState(() {
                                            _selectedMonth = item;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  const Text("Time"),
                                  const SizedBox(height: 4.0),
                                  MaterialButton(
                                    color: AppTheme.secondaryColor,
                                    textColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    onPressed: () async =>
                                        await _selectTime(context),
                                    child: _startTime != null
                                        ? Text(
                                            "${_startTime!.format(context)} - ${_endTime!.format(context)}")
                                        : const Text("Pick Time"),
                                  ),
                                  const SizedBox(height: 12.0),
                                  const Text("Price"),
                                  const SizedBox(height: 4.0),
                                  TextFormField(
                                    focusNode: _fnPrice,
                                    controller: _txtPrice,
                                    maxLength: 16,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      NumericTextFormatter(),
                                    ],
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: true,
                                      counterText: "",
                                      fillColor: Colors.white,
                                      hintText: 'Price',
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
                                          ? const CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            )
                                          : Row(
                                              children: [
                                                MaterialButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    await _deleteSchedule();
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  },
                                                  child: const Text("Delete"),
                                                  color: AppTheme.dangerColor,
                                                  textColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                const SizedBox(width: 8.0),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    await _updateSchedule();
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  },
                                                  child: const Text("Update"),
                                                  color: AppTheme
                                                      .lighterSecondaryColor,
                                                  textColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ],
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
                )),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<DaySchedule>> generateItems(List<DaySchedule> days) {
    List<DropdownMenuItem<DaySchedule>> items = [];
    for (var day in days) {
      items.add(
        DropdownMenuItem(
          child: Text("${day.day}"),
          value: day,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<MonthSchedule>> generateItems1(
      List<MonthSchedule> months) {
    List<DropdownMenuItem<MonthSchedule>> items1 = [];
    for (var month in months) {
      items1.add(
        DropdownMenuItem(
          child: Text("${month.month}"),
          value: month,
        ),
      );
    }
    return items1;
  }

  _updateSchedule() async {
    NumberFormat format = NumberFormat();

    DateTime now = DateTime.now();

    // กำหนด TimeOfDay เป็น DateTime
    DateTime startAt = DateTime(
        now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    DateTime endtAt = DateTime(
        now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

    Map<String, dynamic> data = {
      'day_schedule': _selectedDay!.toJson(),
      'month_schedule': _selectedMonth!.toJson(),
      'start_at': DateFormat("hh:mm a").format(startAt),
      'end_at': DateFormat("hh:mm a").format(endtAt),
      'price': format.parse(_txtPrice.text),
    };

    await Provider.of<ConsultationScheduleProvider>(context, listen: false)
        .updateConsultationSchedule(schedule.docId, data, currentDoctor!.uid);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Update success"),
      ),
    );

    await Provider.of<ConsultationScheduleProvider>(context, listen: false)
        .getListConsultationSchedule(currentDoctor!.uid);

    Navigator.of(context).pop();
  }

  _deleteSchedule() async {
    await Provider.of<ConsultationScheduleProvider>(context, listen: false)
        .deleteConsultationSchedule(schedule.docId, currentDoctor!.uid);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Delete success"),
      ),
    );

    await Provider.of<ConsultationScheduleProvider>(context, listen: false)
        .getListConsultationSchedule(currentDoctor!.uid);

    Navigator.of(context).pop();
  }
}
