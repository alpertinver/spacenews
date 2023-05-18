import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacenews/Screens/Myhomepage.dart';
import 'package:spacenews/datas/riverpodVar.dart';
import 'dart:convert';

var data;

class DetailednewsPage extends ConsumerStatefulWidget {
  DetailednewsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailednewsPageState();
}

class _DetailednewsPageState extends ConsumerState<DetailednewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailednews();
    });
  }

  Future<void> detailednews() async {
    WidgetsFlutterBinding.ensureInitialized();
    data = await ref.watch(DatalarMapFProvider.future);
    setState(() {}); // trigger a rebuild after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    var TimeNotDivided = ref.read(MAPDATAS.PublishTimeProvider);
    var TitleFixed = ref.read(MAPDATAS.TitleProvider);
    TitleFixed = utf8.decode(TitleFixed.codeUnits);

    var SummaryFixed = ref.read(MAPDATAS.SummaryProvider);
    SummaryFixed = utf8.decode(SummaryFixed.codeUnits);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 78, 67, 67),
      appBar: AppBar(
        title: const Text('Detailed News'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        TitleFixed,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.network(
                    ref.read(MAPDATAS.ImageUrlProvider),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      SummaryFixed,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(
                      '${TimeNotDivided.substring(0, 10)}  ${TimeNotDivided.substring(11, 19)} ',
                      style: TextStyle(color: Colors.amberAccent)),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                    onTap: () async {
                      // final Uri _url =
                      //     Uri.parse(ref.read(MAPDATAS.UrlDProvider));

                      // await launchUrl(_url);
                      print(ref.read(MAPDATAS.UrlDProvider));
                    },
                    child: Text(ref.read(MAPDATAS.NewsSiteProvider),
                        style: TextStyle(color: Colors.amberAccent.shade200))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
