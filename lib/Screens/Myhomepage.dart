import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spacenews/datas/riverpodVar.dart';
import 'package:spacenews/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';

var kutu = Hive.box('testBox');
bool DisclaimerTrueFalsetf = true;
var next;
MapDatasToPage MAPDATAS = MapDatasToPage();

TextEditingController vSilinmekIstenenId = TextEditingController();

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  void showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Disclaimer"),
          content: const Text(
              "I need your acceptance of the disclaimer to continue"),
          actions: [
            TextButton(
              child: const Text("Quit"),
              onPressed: () {
                SystemNavigator.pop();
                // Kullanıcının disclaimer'ı reddettiği durumu işleyebilirsiniz.
              },
            ),
            TextButton(
              child: const Text("Accept"),
              onPressed: () {
                ref.read(DisclaimerTFProvider.notifier).state = false;
                Navigator.of(context).pop();
                // Kullanıcının disclaimer'ı kabul ettiği durumu işleyebilirsiniz.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var disclaimerTFstring = ref.watch(DisclaimerTFProvider).toString();
    bool truefboolref = disclaimerTFstring.toBoolean();
    return Scaffold(
        drawer: const AcilirMenu(),
        appBar: AppBar(
          elevation: 4,
          title: Row(
            children: [
              const Center(child: Text('Space News')),
            ],
          ),
        ),
        bottomNavigationBar: BottomMethod(),
        backgroundColor: const Color.fromARGB(255, 78, 67, 67),
        body: truefboolref
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(
                            16.0), // İçerik kenar boşlukları için padding ekleyin
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Disclaimer:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    16.0), // Metin ile düğme arasına boşluk ekleyin
                            const Text(
                                '''The news content provided in this mobile application is for general informational purposes only. There is no guarantee of accuracy, completeness, or timeliness of these contents. Users should use this content at their own risk and discretion and take necessary precautions.\n\n
This mobile application may contain links redirecting to other sources. These links are provided for informational purposes, and we have no control over the content of the linked sources. Therefore, we recommend reading the privacy policies and terms of use of the linked sources.\n\n
The application content does not substitute for legal, medical, or professional advice. It is strongly advised to consult your independent advisor for expert advice on any subject. The information provided in the application emphasizes the need to consult your legal advisor before making decisions regarding legal matters.\n\n
We are not liable for any direct or indirect damages or losses that may arise from using the application. This disclaimer statement binds anyone using the application.\n\n
This disclaimer statement may be modified at any time, and the updated version will be applicable.''',
                                textAlign: TextAlign.justify),
                            const SizedBox(
                                height:
                                    16.0), // Metin ile düğme arasına boşluk ekleyin
                            ElevatedButton(
                              onPressed: () {
                                // var trueT = 'true';
                                // kutu.put('DisclaimerTFHive', trueT);
                                showDisclaimerDialog(context);
                              },
                              child: const Text('Kabul Et'),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint(
                                      kutu.get('DisclaimerTFHive').toString());
                                },
                                child: const Text('sa'))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: truefalse ? ref.watch(haberlerProvider.future) : next,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          Center(
                            child: Container(
                              alignment: Alignment
                                  .bottomCenter, // Ortaya hizalamak için alignment ekleyin
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ); // veriler yüklenirken gösterilecek animasyon
                    } else if (snapshot.hasError) {
                      return Text(
                          'Hata: ${snapshot.error}'); // veriler getirilirken bir hata oluştuysa gösterilecek mesaj
                    } else {
                      final data = snapshot.data!;
                      var nextdatalink = data["next"];
                      var previousdatalink = a["previous"];

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(NextLinkProvider.notifier).state =
                            nextdatalink;
                        ref.read(PreviousLinkProvider.notifier).state =
                            previousdatalink;
                      });

                      return ListViewExpanded(snapshot);
                    }
                  },
                )
              ]));
  }

  Expanded ListViewExpanded(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data!["results"].length,
        itemBuilder: (BuildContext context, int index) {
          String titleD = snapshot.data!["results"][index]["title"];
          String image_urlD = snapshot.data!["results"][index]["image_url"];
          String news_siteD = snapshot.data!["results"][index]["news_site"];
          String summaryD = snapshot.data!["results"][index]["summary"];
          String published_at =
              snapshot.data!["results"][index]["published_at"];
          String urlD = snapshot.data!["results"][index]["url"];
          return Column(
            children: [
              IcMenu(snapshot, index, image_urlD, summaryD, news_siteD, titleD,
                  published_at, urlD, context),
            ],
          );
        },
      ),
    );
  }

  Container IcMenu(
      AsyncSnapshot<Map<String, dynamic>> snapshot,
      int index,
      String image_urlD,
      String summaryD,
      String news_siteD,
      String titleD,
      String published_at,
      String urlD,
      BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Image.network(
          snapshot.data!["results"][index]["image_url"],
          fit: BoxFit.cover,
          width: 60,
          height: 60,
        ),
        title: Text(
          utf8.decode(snapshot.data!["results"][index]["title"].codeUnits),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          utf8.decode(snapshot.data!["results"][index]["news_site"].codeUnits),
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        onTap: () async {
          ref.read(CountProvider.notifier).state = index;
          ref.read(MAPDATAS.ImageUrlProvider.notifier).state = image_urlD;
          ref.read(MAPDATAS.SummaryProvider.notifier).state = summaryD;
          ref.read(MAPDATAS.NewsSiteProvider.notifier).state = news_siteD;
          ref.read(MAPDATAS.TitleProvider.notifier).state = titleD;
          ref.read(MAPDATAS.PublishTimeProvider.notifier).state = published_at;
          ref.read(MAPDATAS.UrlDProvider.notifier).state = urlD;

          context.go(
            '/detailednews',
          );
          // Tıklama işlemleri için kullanabilirsiniz
        },
      ),
    );
  }

  BottomNavigationBar BottomMethod() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_left),
          label: 'Previous',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.api_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_right),
          label: 'Next',
        ),
      ],
      currentIndex: 1,
      selectedItemColor: Colors.black,
      backgroundColor: const Color.fromARGB(255, 237, 153, 153),
      onTap: (value) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: false,
            backgroundColor: Colors.green,
            content: Row(
              children: [
                const Text('New Page Is Loading Wait  '),
                const Expanded(
                  child: SizedBox(
                    width: 0,
                  ),
                ),
                Icon(Icons.replay_circle_filled_sharp,
                    textDirection: TextDirection.rtl, color: Colors.green[300]),
              ],
            ),
            duration: const Duration(seconds: 2), // Bildirim süresi
          ),
        );

        // var data = await _getArticles(ref.read(LinkProvider));
        // var nextdatalink = data["next"];
        print(value);
        if (value == 2) {
          print(' selam sonraki link ${ref.read(NextLinkProvider)}');
          next = Future.value(await _getArticles(ref.read(NextLinkProvider)));
          setState(() {
            truefalse = false;
          });
        } else if (value == 1) {
          var data = await _getArticles(ref.read(NextLinkProvider));
          var nextdatalink = data["next"];
          print('2 sonraki next data link $nextdatalink');
        } else {
          print('back');

          next =
              Future.value(await _getArticles(ref.read(PreviousLinkProvider)));
          print(ref.read(PreviousLinkProvider));
          setState(() {
            truefalse = false;
          });
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getArticles(String Link) async {
    final response = await http.get(Uri.parse(Link));
    final data = jsonDecode(response.body);
    return data;
  }
}

class AcilirMenu extends StatelessWidget {
  const AcilirMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 120,
            child:
                const Text('Space News', style: TextStyle(color: Colors.white)),
            decoration: const BoxDecoration(color: Colors.black),
          ),
          const SizedBox(
            height: 6,
          ),
          ElevatedButton(
              style: const ButtonStyle(),
              onPressed: () {
                context.go(
                  '/launches',
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 60,
                child: const Text('Launches',
                    style: TextStyle(color: Colors.white)),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(19)),
                  color: Colors.blue,
                ),
              )),
        ],
      ),
    );
  }
}

Future<Box> boxopen() async {
  var hivebox = await Hive.openBox('testBox');
  return hivebox;
}
