import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:night_watch/Services/auth.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  _ProfileInfo createState() => _ProfileInfo();
}

class _ProfileInfo extends State<ProfileInfo> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            counter = counter + 1;
          });
        },
        child: Container(
          width: 60,
          height: 60,
          child: const Icon(
            Icons.add
          ),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.black,Colors.black],)),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex:5,
                child:Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade900,Colors.black],
                    ),
                  ),
                  child: Column(
                    children: const [
                      SizedBox(height: 110.0,),
                      CircleAvatar(
                        radius: 65.0,
                        backgroundImage: AssetImage(''),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10.0,),
                      Text('',
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 20.0,
                      )),
                      SizedBox(height: 10.0,),
                      Text('',
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 15.0,
                      ),)
                  ]
                  ),
                ),
              ),

              Expanded(
                flex:5,
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                      child:Card(
                          margin: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                        child: SizedBox(
                          width: 310.0,
                          height:290.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Information",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w800,
                                ),),
                                Divider(color: Colors.grey[300],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Icon(
                                    //   Icons.home,
                                    //   color: Colors.blueAccent[400],
                                    //   size: 35,
                                    // ),
                                    const SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),),
                                        Text("",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
                                          ),)
                                      ],
                                    )

                                  ],
                                ),
                                const SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Icon(
                                    //   Icons.auto_awesome,
                                    //   color: Colors.yellowAccent[400],
                                    //   size: 35,
                                    // ),
                                    const SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),),
                                        Text("",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
                                          ),)
                                      ],
                                    )

                                  ],
                                ),
                                const SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Icon(
                                    //   Icons.favorite,
                                    //   color: Colors.pinkAccent[400],
                                    //   size: 35,
                                    // ),
                                    const SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),),
                                        Text("",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
                                          ),)
                                      ],
                                    )

                                  ],
                                ),
                                const SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Icon(
                                    //   Icons.people,
                                    //   color: Colors.lightGreen[400],
                                    //   size: 35,
                                    // ),
                                    const SizedBox(width: 20.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),),
                                        Text("",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
                                          ),)
                                      ],
                                    )

                                  ],
                                ),
                              ],
                            ),
                          )
                        )
                      )
                    ),
                  ),
              ),

            ],
          ),
          Positioned(
              top:MediaQuery.of(context).size.height*0.45,
              left: 20.0,
              right: 20.0,
              child: Card(
                child: Padding(
                  padding:const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('Distance',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.0
                          ),),
                          const SizedBox(height: 5.0,),
                          Text("$counter",
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),)
                        ],
                      ),

                      Column(
                      children: [
                        Text('Birthday',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.0
                          ),),
                        const SizedBox(height: 5.0,),
                        const Text('April 7th',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),)
                      ]),

                      Column(
                        children: [
                          Text('Age',
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14.0
                            ),),
                          const SizedBox(height: 5.0,),
                          const Text('19 yrs',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),)
                        ],
                      ),
                    ],
                  ),
                )
              )
          )
        ],

      ),
    );
  }
}

