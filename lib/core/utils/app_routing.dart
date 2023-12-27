


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

import '../../Categories/add.dart';
import '../../Categories/note.dart';
import '../../HomePage.dart';
import '../../auth/presentation/views/login_view.dart';
import '../../auth/presentation/views/register_view.dart';
import '../../filter/filtetFirebase.dart';

abstract class AppRouter
{

  static const KLogin = '/LoginView';
  static const KRegister = '/RegisterView';
  static const KHome = '/HomePAge';
  static const KAddCate = '/AddCate';
  static const KNote = '/NoteView';



  static final router = GoRouter(
    routes: [


      GoRoute(
        path: KLogin,
        builder: (context, state) => LoginView() ),

  //     GoRoute(
  //       path: '/',
  //       builder: (context, state) => (FirebaseAuth.instance.currentUser != null &&
  //                                       FirebaseAuth.instance.currentUser!.emailVerified)
  //                                      ? HomePAge()
  //                                      : LoginView(),
  // ),

      GoRoute(
        path: '/',
        builder: (context, state) => FilterFirebase(),
      ),

      GoRoute(
        path:KRegister ,
        builder: (context, state) => RegisterView(),
      ),

      GoRoute(
        path:KHome ,
        builder: (context, state) => HomePAge(),
      ),

      GoRoute(
        path:KAddCate ,
        builder: (context, state) => AddCate(),
      ),

      // GoRoute(
      //   path:KNote ,
      //   builder: (context, state) => NoteView(CateId: data[index].id,),
      // ),

    ],
  );
}
