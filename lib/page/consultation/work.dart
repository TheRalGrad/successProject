part of '../pages.dart';

class ConsultationPage extends StatefulWidget {
  final Queue queue;

  const ConsultationPage({Key? key, required this.queue}) : super(key: key);
  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  Queue get queue => widget.queue;

  bool _isLoading = false;

  bool _isDone = false;

  Doctor? currentDoctor;

  final TextEditingController _txtDiagnosis = TextEditingController();

  @override
  void initState() {
    currentDoctor = Provider.of<DoctorProvider>(context, listen: false).admin;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Toolbar(),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Transaction ID #${queue.transactionData!.docId}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    DateFormat("dd MMMM yyyy")
                        .format(queue.transactionData!.createdAt),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                  "\$${NumberFormat("#,###").format(queue.transactionData!.consultationSchedule!.price)}"),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "${queue.transactionData!.consultationSchedule!.startAt!.format(context)} - ${queue.transactionData!.consultationSchedule!.endAt!.format(context)}",
                ),
              ),
              const SizedBox(height: 56),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          queue.transactionData!.createdBy!.profileUrl != ""
                              ? NetworkImage(
                                  queue.transactionData!.createdBy!.profileUrl!)
                              : null,
                      child: queue.transactionData!.createdBy!.profileUrl != ""
                          ? null
                          : const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 86,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name : ${queue.transactionData!.createdBy!.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Email : ${queue.transactionData!.createdBy!.email}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Phone Number : ${queue.transactionData!.createdBy!.phoneNumber}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Address : ${queue.transactionData!.createdBy!.address}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : queue.isDone! || _isDone
                            ? MaterialButton(
                                minWidth: 148,
                                height: 39,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: AppTheme.darkerPrimaryColor,
                                child: const Text(
                                  "Work has ended",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              )
                            : currentDoctor!.isBusy!
                                ? MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: AppTheme.dangerColor,
                                    child: const Text(
                                      "Finish Work",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await _finish(context);
                                      setState(() {
                                        _isLoading = false;
                                        _isDone = true;
                                      });
                                    },
                                  )
                                : MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: AppTheme.primaryColor,
                                    child: const Text(
                                      "Start Work",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await _startConsulting();
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _startConsulting() async {
    bool konfirmasi = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure want to start?"),
        content: const Text(
            "You will be directed to WhatsApp, to start consulting with patient"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );

    if (konfirmasi) {
      // ส่วนของ What app
      String _url =
          "https://api.whatsapp.com/send?phone=${queue.transactionData!.createdBy!.phoneNumber}";

      await canLaunchUrlString(_url)
          ? await launchUrlString(
              _url,
              mode: LaunchMode.externalApplication,
            )
          : throw 'Could not launch $_url';

      Doctor newData = currentDoctor!;
      newData.isBusy = true;

      //  ส่วนของข้อมูล ที่ส่งข้อมูลอัพเดท
      Provider.of<DoctorProvider>(context, listen: false).setDoctor = newData;
      await FirebaseFirestore.instance
          .doc('admin/${newData.uid}')
          .update({'is_busy': true});
    }
  }

  _finish(BuildContext context) async {
    bool konfirmasi = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure want to finish this task?"),
        content: const Text(
            "when the job is finished You will be asked to review the performance."),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );

    if (konfirmasi) {
      Doctor newData = currentDoctor!;
      newData.isBusy = false;

      // ส่งข้อมูลไปยัง data
      Provider.of<DoctorProvider>(context, listen: false).setDoctor = newData;
      await FirebaseFirestore.instance
          .doc('admin/${newData.uid}')
          .update({'is_busy': false});

      ///ส่ง ข้อมูลโดยผูกกับ ID
      await FirebaseFirestore.instance
          .doc('admin/${currentDoctor!.uid}/queue/${queue.docId}')
          .update({
        'is_done': true,
      });

      // กล่องของฝั่ง Admin
      String? diagnosis = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("performance appraisal"),
          content: TextField(
            controller: _txtDiagnosis,
            decoration:
                const InputDecoration(hintText: "performance appraisal"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_txtDiagnosis.text),
              child: const Text("Done"),
            ),
          ],
        ),
      );

      DateTime now = DateTime.now();

      // กำหนด TimeOfDay ให้ DateTime
      DateTime startAt = DateTime(
          now.year,
          now.month,
          now.day,
          queue.transactionData!.consultationSchedule!.startAt!.hour,
          queue.transactionData!.consultationSchedule!.startAt!.minute);
      DateTime endAt = DateTime(
          now.year,
          now.month,
          now.day,
          queue.transactionData!.consultationSchedule!.endAt!.hour,
          queue.transactionData!.consultationSchedule!.endAt!.minute);

      Map<String, dynamic> dataSchedule = {
        'day_schedule':
            queue.transactionData!.consultationSchedule!.daySchedule!.toJson(),
        // Format ค่าที่ 00:00 PM, รับข้อมูลทีหลังเป็น TimeOfDay
        'start_at': DateFormat("hh:mm a").format(startAt),
        'end_at': DateFormat("hh:mm a").format(endAt),
        'price': queue.transactionData!.consultationSchedule!.price,
      };

      Map<String, dynamic> transactionData = {
        'doc_id': queue.transactionData!.docId,
        'admin_profile': queue.transactionData!.adminProfile!.toJson(),
        'consultation_schedule': dataSchedule,
        'status': queue.transactionData!.status,
        'proof_payment': queue.transactionData!.paymentProof,
        'created_at': Timestamp.fromDate(queue.transactionData!.createdAt),
        'created_by': queue.transactionData!.createdBy!.toJson(),
      };

      Map<String, dynamic> queueData = {
        'doc_id': queue.docId,
        'transaction_data': transactionData,
        'queue_number': queue.queueNumber,
        'is_done': false,
        'created_at': Timestamp.fromDate(queue.createdAt),
      };

      Map<String, dynamic> data = {
        'queue_data': queueData,
        // หากค่าเป็น null, มันจะ กำหนด Timestamp
        'diagnosis': diagnosis ?? "",
        'created_at': Timestamp.now(),
      };

      // เพิ่ม diagnosis ไปที่ user subCollection
      await Provider.of<DiagnosisProvider>(context, listen: false)
          .addDiagnosis(data, queue.transactionData!.createdBy!.uid);

      // รีเฟรท queue data
      await Provider.of<QueueProvider>(context, listen: false)
          .get7Queue(queue.transactionData!.adminProfile!.uid);
      await Provider.of<QueueProvider>(context, listen: false)
          .getAllQueue(queue.transactionData!.adminProfile!.uid);
    }
  }
}
