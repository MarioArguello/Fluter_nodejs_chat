import 'package:chat_flutter/src/pages/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../../api/environment.dart';
import '../../models/user.dart';
import 'image_page.dart';

class ProfilePage extends StatelessWidget {
  ProfileController con = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => con.singOut(),
              child: Icon(Icons.power_settings_new),
              backgroundColor: Colors.green,
              heroTag: null,
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Center(
            child: Text(
              'Perfil',
              style: TextStyle(color: Colors.black),
            ),
          ),
          leading: BackButton(
            color: Colors.black,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
              tooltip: 'Editar perfil',
              onPressed: () {
                Get.snackbar('Pagina', 'No existe');
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Obx(
              () => SafeArea(
                  child: Stack(
                children: [
                  Positioned(child: _imagenPortada(context)),
                  Container(
                    margin: EdgeInsets.only(top: 65),
                    child: Column(
                      children: [
                        circleImageUser(context),
                        SizedBox(
                          height: 20,
                        ),
                        UserInfo(
                            'Nombre del Usuario',
                            '${con.user.value.name ?? ''} ${con.user.value.lastname ?? ''}',
                            Icons.person),
                        UserInfo(
                            'Email', con.user.value.email ?? '', Icons.email),
                        UserInfo(
                            'Phone', con.user.value.phone ?? '', Icons.phone),
                      ],
                    ),
                  )
                ],
              )),
            ),
          ],
        ));
  }

  Widget _imagenPortada(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryPage(
                  img_portada: 1,
                  user: con.userimg,
                )),
      ),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: con.user.value.img_portada != null
                    ? NetworkImage(con.user.value.img_portada!)
                    : const AssetImage('assets/img/photo.png') as ImageProvider,
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget UserInfo(String title, String subtitulo, IconData iconData) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitulo),
        leading: Icon(iconData),
      ),
    );
  }

  Widget circleImageUser(BuildContext context) {
    return GestureDetector(
      onTap: (() => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoryPage(
                        img_portada: 2,
                        user: con.userimg,
                      )),
            ),
          }),
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          width: 175,
          height: 175,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
                child: Material(
              color: Colors.white,
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: 'assets/img/man.png',
                  image: con.user.value.image ??
                      'https://firebasestorage.googleapis.com/v0/b/flutter-chatmaac.appspot.com/o/man.png?alt=media&token=3f63d880-6e6a-40ea-b504-2e24d42a6cdc'),
            )),
          ),
        ),
      ),
    );
  }

  Widget circleImageUserview() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: 175,
        height: 175,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.white),
          enableRotation: true,
          // disableGestures: true,
          //  tightMode: true,

          maxScale: 200.0,
          imageProvider: NetworkImage(con.user.value.image!),
        ),
      ),
    );
  }
}
