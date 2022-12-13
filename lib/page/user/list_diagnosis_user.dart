part of '../pages.dart';

class ListDiagnosisUser extends StatefulWidget {
  const ListDiagnosisUser({Key? key}) : super(key: key);

  @override
  _ListDiagnosisUserState createState() => _ListDiagnosisUserState();
}

class _ListDiagnosisUserState extends State<ListDiagnosisUser> {
  @override
  void initState() {
    Provider.of<DiagnosisProvider>(context, listen: false).getAllDiagnosis(
      Provider.of<UserProvider>(context, listen: false).user!.uid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Consumer<DiagnosisProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (value.listDiagnosis.isEmpty) {
            return const Center(
              child: Text("There's no review from Admin"),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Toolbar(),
                const SizedBox(height: 16.0),
                const Text(
                  "List Review",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: value.listDiagnosis.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = value.listDiagnosis[index];

                      return _diagnosisCard(context, item);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _diagnosisCard(BuildContext context, Diagnosis item) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Admin : ${item.queueData!.transactionData!.adminProfile!.name}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    DateFormat("dd MMMM yyyy").format(item.createdAt),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Specialist : ",
                ),
                Text(
                  "${item.queueData!.transactionData!.adminProfile!.specialist}",
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Work Time : ",
                ),
                Text(
                  "${item.queueData!.transactionData!.consultationSchedule!.startAt!.format(context)} - ${item.queueData!.transactionData!.consultationSchedule!.endAt!.format(context)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Review : ",
                ),
                Text("${item.diagnosis}")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
