import 'package:flutter/material.dart';
import 'translation.dart'; // Assuming this contains the Translation class
import 'translation_model.dart'; // Assuming this contains your TranslationService
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => BaseScaffold(child: Home()),
        '/translate': (context) => BaseScaffold(child: TranslateScreen()),
        '/info': (context) => BaseScaffold(child: InfoScreen()),
      },
    );
  }
}

class BaseScaffold extends StatelessWidget {
  final Widget child;

  BaseScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Eng To Mon Dictionary',
          style: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.bold),
        ),
        leading: null,
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.red),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.red),
            label: 'Dictionary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.red),
            label: 'About',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/'); // Home
              break;
            case 1:
              Navigator.pushNamed(context, '/translate'); // Translate
              break;
            case 2:
              Navigator.pushNamed(context, '/info'); // Info
              break;
          }
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                   "မွန်စာပေတွင် သရ(၁၂)လုံး၊ ဗျည်း(၃၅)လုံး၊ ပင့်၊ရစ်၊ဆွဲ၊ထိုး အဖွဲ့ဝင်ဗျည်း(၁၀)လုံး၊ ဟထိုးဗျည်း (၉)လုံးနှင့် အသတ် (၁၀)မျိုးရှိပါသည်။အေဒီ(၅)ရာစုမှ အေဒီ(၁၂)ရာစုအတွင်းရှိ ရှေးဟောင်းမွန်စာပေကို ထိုင်းနိုင်ငံ ဒွါရဝတီ နှင့် ဟရိဘုဥ္ဇယဒေသတို့တွင်လည်းကောင်း၊ မြန်မာနိုင်ငံ သထုံမြို့နှင့်ပုဂံမြို့တို့တွင်လည်းကောင်း တွေ့မြင်နိုင်သည်။အေဒီ(၁၃)ရာစုမှ အေဒီ(၁၆)ရာစုအတွင်းရှိ ခေတ်လယ်မွန်စာပေကို ဟံသာဝတီပြည်(ပဲခူး) မွန်ဘုရင်မကြီးရှင်စောဗုနှင့်ဓမ္မစေတီမင်းလက်ထက်၌ နေရာအများအပြားတွင် ရေးသားထားသည်။ကျိုက်မရောမြို့ရှိ ဆုတောင်းပြည့်ဘုရားကြီးကျောက်စာ၊ ရွှေတိဂုံဘုရားကျောက်စာ၊ ကလျာဏီသိမ်ကျောက်စာ တို့တွင်တွေ့ရှိနိုင်သည်။အေဒီ(၁၇)ရာစုမှ ယနေ့ပစ္စုန်ပန်အထိခေတ်သစ်မွန်စာပေများကို မွန်ပညာရှင်များမှ ပေစာများပေါ်တွင်လည်ကောင်း စက္ကူများပေါ်တွင်ရိုက်နှိပ်ပြီး စာအုပ်များ၊စာစဉ်များ၊ကျမ်းများအဖြစ် ရေးသားထားသောစာပေကို ခေတ်သစ်မွန်စာပေများဟု ခေါ်သည်။",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          Image(
            image: AssetImage("img/mn.jpg"),
            width: 300,
            height: 200,
          ),
        ],
      ),
    );
  }
}

class TranslateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search words...',style: TextStyle(fontSize: 14),),
        //leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              // Load translations to pass to the search delegate
              final translations = await TranslationService().loadTranslations();
              showSearch(
                context: context,
                delegate: TranslationSearchDelegate(translations),
              );
            },
          ),
          
        ],
      automaticallyImplyLeading: false  
      ),
      body: TranslationPage(), // Your main page content
    );
  }
}

class TranslationPage extends StatefulWidget {
  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  late Future<List<Translation>> futureTranslations;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    futureTranslations = TranslationService().loadTranslations(); // Load translations
  }

  void playAudio(String audioFile) async {
    try {
      await audioPlayer.play(AssetSource('audio/$audioFile')); // Ensure audio path is correct
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Translation>>(
      future: futureTranslations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final translations = snapshot.data!; // Store the loaded translations
          return ListView.builder(
            itemCount: translations.length,
            itemBuilder: (context, index) {
              final translation = translations[index];
              return ListTile(
                title: Text(translation.english),
                subtitle: Text(translation.mon),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () => playAudio(translation.audio),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class TranslationSearchDelegate extends SearchDelegate {
  final List<Translation> translations; // List of translations

  TranslationSearchDelegate(this.translations);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the query
          showSuggestions(context); // Show suggestions again
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search
      },
    );
  }











  @override
  Widget buildResults(BuildContext context) {
    final results = translations.where((translation) {
      return translation.english.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ListTile(
          title: Text(result.english),
          subtitle: Text(result.mon),
          trailing: IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () => playAudio(result.audio),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = translations.where((translation) {
      return translation.english.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion.english),
          subtitle: Text(suggestion.mon),
          onTap: () {
            query = suggestion.english; // Update query to selected suggestion
            showResults(context); // Show results for the selected suggestion
          },
        );
      },
    );
  }

  void playAudio(String audioFile) async {
    final audioPlayer = AudioPlayer();
    try {
      await audioPlayer.play(AssetSource('audio/$audioFile')); // Ensure audio path is correct
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
}











class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Center(child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("ဤပလက်ဖောင်းကိုဖန်တီးလိုက်ရသည့်အကြောင်းအရင်း",style: TextStyle(fontSize: 14,color: Colors.red,fontWeight:FontWeight.bold
            
            ),textAlign: TextAlign.center,),
          ))),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("မွန်ဘာသာစကားသည် သမိုင်းနောက်ခံနှင့် ယဉ်ကျေးမှုတို့ကြွယ်ဝသည့် ဘာသာစကားဖြစ်ပြီး ‌‌ယျေဘုယျအားဖြင့် မြန်မာနိုင်ငံနှင့် ထိုင်းနိုင်ငံတို့တွင် စကားပြောဆက်သွယ်နေကြသည်။ သို့သော် အခြားသော လူနည်းစု ဘာသာစကားများကဲ့သို့ပင် ခေတ်မီကမ္ဘာတွင် မထင်ရှားတော့ဘဲ ရှိနေသည့်အတွက် အန္တရာယ်ရှိပါသည်။ ဤဘာသာပြန် ကိရိယာကို ဖန်တီးခြင်းဖြင့် မွန်ဘာသာစကားကို ထိန်းသိမ်းကာကွယ်ရေးနှင့် ထူထောင်ပြန်လည် ဆောက်လုပ်ရေးတို့ကို အထောက်အကူ ပြုနိုင်ရန် ရည်ရွယ်ပါသည်။ အပြည်ပြည်ဆိုင်ရာ ဘာသာစကားဆိုင်ရာ အမွေအနှစ်တစ်ခုအဖြစ် တည်ရှိစေရန် ဖြစ်ပါသည်။",style: TextStyle(fontSize: 12,),textAlign: TextAlign.justify,),
        ),

          
  
       Container(
                width: 320,
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
    'img/flag.png',width: 500,height: 200,fit: BoxFit.cover,
  ),
                ),
              ),
          
          
   
        ],


      
      ),
    );
  }
}
