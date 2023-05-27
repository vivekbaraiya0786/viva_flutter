import 'package:animated_neumorphic/animated_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String currenttime = DateFormat('HH:mm:ss').format(DateTime.now());
  String savedthrought = "";

  TextEditingController throghtcontroller = TextEditingController(text: "");
  String date = DateFormat.yMMMMEEEEd().format(DateTime.now());

  @override
  void initState() {
    super.initState();
    loadSavedThought();
    updateClock();
    stopclock();
  }

  void updateClock() {
    setState(() {
      currenttime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
    Future.delayed(const Duration(seconds: 1), updateClock);
  }

  void loadSavedThought() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedthrought = prefs.getString('savedThought') ?? '';
    });
  }

  void saveThought(String thought) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedThought', thought);
    setState(() {
      savedthrought = thought;
      isclockrunnig = false;
    });
  }

  bool _isActive = false;
  bool isclockrunnig = false;

  void stopclock(){
    if(isclockrunnig){
      setState(() {
        currenttime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
      stopclock();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _height = size.height;
    double _width = size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Digital Clock",
            style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.grey.shade300,
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Enter your thought'),
                        content: TextField(
                          controller: throghtcontroller,
                          decoration: const InputDecoration(
                            labelText: "Enter Thought",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          onChanged: (text) => saveThought(text),
                        ),
                        actions: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
                setState(() {
                  _isActive = !_isActive;
                });
              },
              child: Transform.scale(
                scale: 0.6,
                child: AnimatedNeumorphicContainer(
                  depth: _isActive ? 0.0 : 1.0,
                  color: const Color(0xFFF2F2F2),
                  width: 80,
                  radius: 16,
                  child: const Icon(Icons.list, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          toolbarHeight: 80,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: _height * 0.03,
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              Container(
                height: _height * 0.2,
                width: _width * 0.8,
                decoration: BoxDecoration(
                  // color: Color(0xff2e94e3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color(0xff2e94e3),
                  //     blurRadius: 2,
                  //     offset: Offset(0,5),
                  //     spreadRadius: 5,
                  //   )
                  // ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Current Date : ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 10),
                    Text(date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                    const SizedBox(height: 15),
                    const Text("Current Time : ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 10),
                    Text(currenttime,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: _height * 0.07,
                width: _width * 0.33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  // color: Colors.black,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Thought : ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ListTileTheme(
                  child: ListTile(
                    shape: const OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                    )),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        savedthrought,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    // subtitle: Text("${}"),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
