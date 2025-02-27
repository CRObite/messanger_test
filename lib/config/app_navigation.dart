import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/user.dart';
import '../presentation/home_page.dart';
import '../presentation/message_page.dart';

class AppNavigation{

  static String initR =  '/home';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _rootNavigatorMessage = GlobalKey<NavigatorState>(debugLabel: 'shellMessage');

  BuildContext? navigationContext;

  static final GoRouter router = GoRouter(
      initialLocation: initR,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
            builder: (context,state,navigationShell){
              return navigationShell;
            },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(
                navigatorKey: _rootNavigatorHome,
                routes: [
                  GoRoute(
                      path: '/home',
                      name: 'home',
                      builder: (context,state){
                        return HomePage(
                          key: state.pageKey,
                        );
                      }
                  )
                ],
              ),
              StatefulShellBranch(
                navigatorKey: _rootNavigatorMessage,
                routes: [
                  GoRoute(
                    path: '/message',
                    name: 'message',
                    builder: (context,state){

                      User? currentUser;
                      User? targetUser;

                      if (state.extra != null) {
                        final extras = state.extra as Map<String, dynamic>;
                        if (extras.containsKey('currentUser')) {
                          currentUser = extras['currentUser'] as User;
                        }
                        if (extras.containsKey('targetUser')) {
                          targetUser = extras['targetUser'] as User;
                        }
                      }

                      if(currentUser!= null && targetUser!= null){
                        return MessagePage(
                          key: state.pageKey,
                          currentUser: currentUser,
                          targetUser: targetUser,
                        );
                      }else{
                        return SizedBox();
                      }

                    },
                  )
                ],
              ),
            ]
        )
      ]
  );
}

