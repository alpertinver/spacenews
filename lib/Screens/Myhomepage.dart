import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spacenews/datas/riverpodVar.dart';
import 'package:spacenews/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

var DisclaimerTrueFalsetf = true;
var box;
bool truefalse = true;
var next;
MapDatasToPage MAPDATAS = MapDatasToPage();

TextEditingController vSilinmekIstenenId = TextEditingController();

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    box = boxopen();
    return Scaffold(
        drawer: AcilirMenu(),
        appBar: AppBar(
          elevation: 4,
          title: Row(
            children: [
              Center(child: const Text('Space News')),
              ElevatedButton(
                  onPressed: () async {
                    var box = await Hive.openBox('testBox');
                    await box.put('DisclaimerTrueFalse', true);
                    DisclaimerTrueFalsetf = box.get('DisclaimerTrueFalse');
                    print('TrueFalse: ${box.get('DisclaimerTrueFalse')}');
                  },
                  child: Icon(Icons.abc)),
            ],
          ),
        ),
        bottomNavigationBar: BottomMethod(),
        backgroundColor: Color.fromARGB(255, 78, 67, 67),
        body: DisclaimerTrueFalsetf
            ? Column(
                children: [
                  Center(
                    child: Container(
                      alignment: Alignment
                          .bottomCenter, // Ortaya hizalamak için alignment ekleyin
                      child: Column(
                        children: [
                          const Text(
                              'Sorumluluk Reddi Beyanı:Bu mobil uygulama üzerinde sunulan haber içerikleri, yalnızca genel bilgilendirme amaçlıdır. Bu içeriklerindoğruluğu, eksiksizliği veya güncelliği konusunda herhangi bir garanti verilmemektedir. Kullanıcılar, bu içerikleri kendi riskleri ve takdirlerine göre kullanmalı ve gerekli önlemleri almalıdır.Bu mobil uygulama, diğer kaynaklara yönlendiren bağlantılar içerebilir. Bu bağlantılar, bilgi sağlama amacıyla sunulmuş olup, bağlantılı kaynakların içerikleri üzerinde kontrolümüz yoktur. Bu nedenle, bağlantılı kaynakların gizlilik politikalarını ve kullanım şartlarını okumanızı öneririz.Uygulama içeriği, hukuki, tıbbi veya profesyonel tavsiye yerine geçmez. Herhangi bir konuda uzman tavsiyesi almak için kendi bağımsız danışmanınıza başvurmanız önemle tavsiye edilir. Uygulama üzerinde sunulan bilgiler, hukuki konularla ilgili kararlar vermeden önce hukuki danışmanınızla görüşmeniz gerektiğini vurgular.Uygulamayı kullanmanız sonucunda ortaya çıkabilecek herhangi bir doğrudan veya dolaylı zarardan veya kayıptan sorumlu değiliz. Bu sorumluluk reddi beyanı, uygulamayı kullanan herkesi bağlar.Bu sorumluluk reddi beyanı, herhangi bir zamanda değiştirilebilir ve güncellenen sürümü geçerli olacaktır.'),
                          ElevatedButton(
                              onPressed: () {
                                showDisclaimerDialog(context);
                              },
                              child: Text('Accept'))
                        ],
                      ),
                    ),
                  ),
                ],
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          utf8.decode(snapshot.data!["results"][index]["news_site"].codeUnits),
          textAlign: TextAlign.end,
          style: TextStyle(
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
      backgroundColor: Color.fromARGB(255, 237, 153, 153),
      onTap: (value) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: false,
            backgroundColor: Colors.green,
            content: Row(
              children: [
                Text('New Page Is Loading Wait  '),
                Expanded(
                  child: SizedBox(
                    width: 0,
                  ),
                ),
                Icon(Icons.replay_circle_filled_sharp,
                    textDirection: TextDirection.rtl, color: Colors.green[300]),
              ],
            ),
            duration: Duration(seconds: 2), // Bildirim süresi
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
            child: Text('Space News', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(color: Colors.black),
          ),
          SizedBox(
            height: 6,
          ),
          ElevatedButton(
              style: ButtonStyle(),
              onPressed: () {
                context.go(
                  '/launches',
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 60,
                child: Text('Launches', style: TextStyle(color: Colors.white)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(19)),
                  color: Colors.blue,
                ),
              )),
        ],
      ),
    );
  }
}

void showDisclaimerDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Disclaimer"),
        content: Text("I need your consent to proceed."),
        actions: [
          TextButton(
            child: Text("Decline"),
            onPressed: () {
              // Kullanıcının disclaimer'ı reddettiği durumu işleyebilirsiniz.
            },
          ),
          TextButton(
            child: Text("Accept"),
            onPressed: () {
              Navigator.of(context).pop();
              // Kullanıcının disclaimer'ı kabul ettiği durumu işleyebilirsiniz.
            },
          ),
        ],
      );
    },
  );
}

Future<Box> boxopen() async {
  var box = await Hive.openBox('testBox');
  return box;
}
