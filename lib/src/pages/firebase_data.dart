import 'dart:math';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/notifications.dart';

class FirebaseDataPage extends StatefulWidget {
  FirebaseDataPage({Key? key}) : super(key: key);

  static const routeName = '/firebase_stream';

  @override
  State<FirebaseDataPage> createState() => _FirebaseDataPageState();
}

class _FirebaseDataPageState extends State<FirebaseDataPage> {
  bool loadData = false;
  bool futureView = false;
  bool streamView = false;
  int length = 0;
  late FirebaseFirestore _firestore;
  late CollectionReference _dataCollection;

  DateTime dateNow = DateTime.now();
  late DateTime initDate;
  late DateTime endDate;

  List<FormModel> lstModel = [];
  late Future<List<FormModel>> futureLst;
  late Stream<QuerySnapshot> streamLst;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _dataCollection = _firestore.collection('data');
    initDate = DateTime(dateNow.year, dateNow.month, dateNow.day, 0, 0, 0);
    endDate = DateTime(dateNow.year, dateNow.month, dateNow.day, dateNow.hour,
        dateNow.minute, dateNow.second);
    // ! Importante Asignar un Future a una variable y esta usarla
    futureLst = getDataFuture();
    streamLst = getDataStream();
  }

  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;
    Timestamp dateInit = Timestamp.fromDate(initDate);
    Timestamp dateEnd = Timestamp.fromDate(endDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data Page'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.greenAccent,
            ),
            tooltip: 'Add data',
            onPressed: () async {
              createData();
            },
          ),
          const SizedBox(height: 25),
          IconButton(
            icon: const Icon(
              Icons.update,
              color: Colors.amberAccent,
            ),
            tooltip: 'Update',
            onPressed: () async {
              setState(() {
                loadData = false;
              });
              futureLst = getDataFuture();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
            width: sizeScreen.width * 0.7,
            height: sizeScreen.height,
            color: Colors.white,
            child:
                // loadData ?
                Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          futureView = true;
                          streamView = false;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple)),
                      child: const Text('Future Builder'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          streamView = true;
                          futureView = false;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurpleAccent)),
                      child: const Text('Stream Builder'),
                    ),
                  ],
                ),
                if (futureView)
                  SizedBox(
                    height: sizeScreen.height * 0.5,
                    child: FutureBuilder(
                      future: futureLst,
                      // initialData: lstModel,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FormModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(color: Colors.amber),
                            // itemCount: lstModel.length,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              FormModel formModel = snapshot.data![index];

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Future Builder',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    // '${lstModel[index].name} - ${lstModel[index].id}',
                                    '${formModel.name} - ${formModel.id}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child:
                                  CircularProgressIndicator(color: Colors.red));
                        }
                      },
                    ),
                  ),
                if (streamView)
                  SizedBox(
                    height: sizeScreen.height * 0.5,
                    child: StreamBuilder(
                      stream: streamLst,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(color: Colors.amber),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Stream Builder',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '${doc['name']} - ${doc['id']}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child:
                                  CircularProgressIndicator(color: Colors.red));
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  'Length - $length',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            )
            // : const Center(
            //     child: CircularProgressIndicator(color: Colors.red)),
            ),
      ),
    );
  }

  Future<void> createData() async {
    DateTime dateNow = DateTime.now();

    String randomName = generateRandomString(5);
    String randomId = generateRandomInt(2);
    var r = Random();

    DateTime createdOn = DateTime(dateNow.year, dateNow.month, dateNow.day,
        r.nextInt(12), r.nextInt(59), r.nextInt(59));

    FormModel formModel =
        FormModel(name: randomName, createdOn: createdOn, id: randomId);

    Map data = formModel.toMap();

    await _dataCollection.add(data).whenComplete(() {
      Notifications.goodNotification(msg: 'Data creada correctamente');
    }).catchError((e) {
      Notifications.badNotification(msg: e);
    });
  }

  Future<List<FormModel>> getDataFuture() async {
    Timestamp dateInit = Timestamp.fromDate(initDate);
    Timestamp dateEnd = Timestamp.fromDate(endDate);

    print('initDate: $initDate');
    print('endDate: $endDate');

    lstModel = [];

    await _dataCollection
        // .where("id", isEqualTo: "45")
        .where("createdOn", isGreaterThanOrEqualTo: dateInit)
        .where("createdOn", isLessThanOrEqualTo: dateEnd)
        .orderBy("createdOn", descending: true)
        .get()
        .then((QuerySnapshot forms) {
      print('docs ${forms.docs.length}');
      for (var form in forms.docs) {
        var formTmp = form.data() as Map<String, dynamic>;
        FormModel formModel = FormModel.fromMap(formTmp);
        lstModel.add(formModel);
      }

      loadData = true;
    }).catchError((e) {
      print(e);
    });
    setState(() {});
    return lstModel;
  }

  Stream<QuerySnapshot> getDataStream() async* {
    Timestamp dateInit = Timestamp.fromDate(initDate);
    Timestamp dateEnd = Timestamp.fromDate(endDate);

    yield* _dataCollection
        .where("id", isEqualTo: "45")
        .where("createdOn", isGreaterThanOrEqualTo: dateInit)
        .where("createdOn", isLessThanOrEqualTo: dateEnd)
        .orderBy("createdOn", descending: true)
        .snapshots();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  String generateRandomInt(int len) {
    var r = Random();
    const _chars = '1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}

class FormModel {
  FormModel({
    required this.name,
    required this.createdOn,
    required this.id,
  });

  String name;
  DateTime createdOn;
  String id;

  factory FormModel.fromMap(Map<String, dynamic> json) => FormModel(
        name: json["name"],
        createdOn: json["createdOn"].toDate(),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "createdOn": createdOn,
        "id": id,
      };

  @override
  String toString() {
    return "\nname: " +
        name +
        "\nid: " +
        id +
        "\ncreatedOn: " +
        createdOn.toIso8601String();
  }
}
