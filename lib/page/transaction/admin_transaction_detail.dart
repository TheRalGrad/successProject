part of '../pages.dart';

class DoctorTransactionDetail extends StatefulWidget {
  final TransactionModel transaction;

  const DoctorTransactionDetail({Key? key, required this.transaction})
      : super(key: key);
  @override
  _DoctorTransactionDetailState createState() =>
      _DoctorTransactionDetailState();
}

class _DoctorTransactionDetailState extends State<DoctorTransactionDetail> {
  TransactionModel get transaction => widget.transaction;

  bool _isLoading = false;

  final List<String> _status = ['Success', 'Failed'];
  String? _selectedStatus = 'Success';

  List<DropdownMenuItem> generateItems(List<String> statuses) {
    List<DropdownMenuItem> items = [];
    for (var status in statuses) {
      items.add(
        DropdownMenuItem(
          child: Text(status),
          value: status,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Toolbar(),
            const SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Review ID #${transaction.docId}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      DateFormat("dd MMMM yyyy").format(transaction.createdAt),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Review Detail",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      buildText("Admin Name", transaction.adminProfile!.name),
                      const SizedBox(
                        height: 5,
                      ),
                      buildText("Consultation Time",
                          "${transaction.consultationSchedule!.startAt!.format(context)} - ${transaction.consultationSchedule!.endAt!.format(context)}"),
                      const SizedBox(
                        height: 5,
                      ),
                      buildText("Phone Number",
                          transaction.adminProfile!.phoneNumber),
                      const SizedBox(
                        height: 5,
                      ),
                      buildText("Bank Account",
                          transaction.adminProfile!.bankAccount),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text("Total"),
                          ),
                          Expanded(
                            child: Text(
                              "\$${NumberFormat("#,###").format(transaction.consultationSchedule!.price)},-",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text("Status"),
                          ),
                          Expanded(
                            child: StatusText(text: transaction.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Choose Status",
                      ),
                      const SizedBox(height: 4),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            value: _selectedStatus,
                            items: generateItems(_status),
                            onChanged: (dynamic item) {
                              setState(() {
                                _selectedStatus = item;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.28,
                          width: MediaQuery.of(context).size.width * 0.56,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (transaction.paymentProof != ""
                                      ? NetworkImage(transaction.paymentProof!)
                                      : const AssetImage('assets/images.png'))
                                  as ImageProvider<Object>,
                              fit: BoxFit.contain,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1,
                                offset: Offset(4, 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Center(
                        child: Text("* Payment Proof",
                            style: Theme.of(context).textTheme.caption),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Column(
                                children: [
                                  MaterialButton(
                                    minWidth: 148,
                                    height: 39,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    color: AppTheme.primaryColor,
                                    child: const Text(
                                      "Update Review",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      await Provider.of<TransactionProvider>(
                                              context,
                                              listen: false)
                                          .updateStatus(
                                        transaction.docId,
                                        transaction.createdBy!.uid,
                                        _selectedStatus,
                                        transaction.adminProfile!.uid,
                                      );

                                      await Provider.of<TransactionProvider>(
                                              context,
                                              listen: false)
                                          .getAllTransaction(true,
                                              transaction.adminProfile!.uid);

                                      setState(() {
                                        _isLoading = false;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Update success",
                                          ),
                                        ),
                                      );

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  MaterialButton(
                                    minWidth: 148,
                                    height: 39,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    color: AppTheme.darkerPrimaryColor,
                                    child: const Text(
                                      "Download Invoice",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await _downloadData(context, transaction);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _downloadData(BuildContext ctx, TransactionModel data) async {
    var status = await Permission.storage.status;
    // Checking for storage permission, if not granted will be requested
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            child: pw.Text('Invoice #${data.docId}',
                style: pw.Theme.of(context).header3),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Table.fromTextArray(
              context: context,
              border: pw.TableBorder.all(),
              headers: <String>[
                'No',
                'Name',
                'Consultation Time',
                'Price',
              ],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#FFF'),
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(AppTheme.primaryInt),
              ),
              headerAlignment: pw.Alignment.centerLeft,
              data: <List<String>>[
                <String>[
                  '1',
                  'Consultation ${data.adminProfile!.name} Specialist ${data.adminProfile!.specialist}',
                  '${data.consultationSchedule!.startAt!.format(ctx)} - ${data.consultationSchedule!.endAt!.format(ctx)}',
                  '\$${NumberFormat("#,###").format(data.consultationSchedule!.price)}'
                ],
              ]),
          pw.Paragraph(text: ""),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text("Status Review : ${data.status}"),
              ),
              pw.Expanded(
                child: pw.Text(
                  "Total : \$${NumberFormat("#,###").format(data.consultationSchedule!.price)}",
                ),
              ),
            ],
          ),
          pw.Padding(padding: const pw.EdgeInsets.all(10)),
        ],
      ),
    );

    // Get ApplicationDocumentsDirectory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;

    // Filename and path
    final file = File("$path/invoice_${data.docId}.pdf");

    // Saving file as pdf
    await file.writeAsBytes(await pdf.save()).whenComplete(
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Downloaded at ${file.path}"),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: "Open",
                onPressed: () async => await OpenFile.open(file.path),
              ),
            ),
          ),
        );
  }

  buildText(String title, String? text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(title),
        ),
        Expanded(
          child: Text(
            "$text",
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
