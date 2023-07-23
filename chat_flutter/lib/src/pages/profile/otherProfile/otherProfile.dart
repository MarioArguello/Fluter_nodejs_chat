import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../api/environment.dart';
import '../image_page.dart';
import 'otherProfile_controller.dart';

class OtheProfileScreen extends StatefulWidget {
  @override
  _OtheProfileScreenState createState() => _OtheProfileScreenState();
}

class _OtheProfileScreenState extends State<OtheProfileScreen> {
  otherprofilecontroller con = Get.put(otherprofilecontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoryPage(
                          img_portada: 1,
                          user: con.userChat,
                        )),
              ),
              child: Container(
                height: 270,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: con.userChat.img_portada != null
                            ? NetworkImage(con.userChat.img_portada!)
                            : const AssetImage('assets/img/photo.png')
                                as ImageProvider,
                        fit: BoxFit.cover)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: CircleAvatar(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 18, 16, 16),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 170,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, bottom: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return StoryPage(
                                  img_portada: 2,
                                  user: con.userChat,
                                );
                              })),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    con.userChat.image ?? Enviroment.image_url),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white38,
                                  child: Text(
                                    con.userChat.name ?? 'Null name',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          letterSpacing: 0.6,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  color: Colors.white38,
                                  child: Text(
                                    "@${con.userChat.lastname ?? 'Null lastname'}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          letterSpacing: 0.6,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: _iconsSms(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Acerca de mí",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              letterSpacing: 0.6,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Soy un programador creativo, capaz de aprender rápidamente y de investigar soluciones innovadoras para resolver problemas complejos. Me comprometo y dedico a mi trabajo para ofrecer soluciones eficaces y eficientes, siempre buscando superar las expectativas y alcanzar los objetivos. Estoy dispuesto a colaborar con el equipo y asumir nuevos desafíos en un ambiente de constante cambio y mejora continua.",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              letterSpacing: 0.6,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _iconsSms() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => con.goToChatMessage(),
          child: Container(
            margin:
                EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 25),
            width: 50,
            height: 50,
            child: Image.asset('assets/img/chat.png'),
          ),
        ),
      ],
    );
  }
}
