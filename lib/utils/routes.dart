import 'package:attendance_cnn_app/features/admin/employee/employee_screen.dart';
import 'package:attendance_cnn_app/features/admin/employee/widgets/add_employee_screen.dart';
import 'package:attendance_cnn_app/features/admin/home/home_admin_screen.dart';
import 'package:attendance_cnn_app/features/admin/main/main_admin_screen.dart';
import 'package:attendance_cnn_app/features/admin/profile/profile_admin_screen.dart';
import 'package:attendance_cnn_app/features/admin/report/report_screen.dart';
import 'package:attendance_cnn_app/features/authentication/presentation/login_screen.dart';
import 'package:attendance_cnn_app/features/splash/splash_screen.dart';
import 'package:attendance_cnn_app/features/user/attendance/attendance_screen.dart';
import 'package:attendance_cnn_app/features/user/history/history_screen.dart';
import 'package:attendance_cnn_app/features/user/home/home_screen.dart';
import 'package:attendance_cnn_app/features/user/main/main_user_screen.dart';
import 'package:attendance_cnn_app/features/user/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => AttendanceScreen(),
    ),
    GoRoute(
      path: '/add-employee',
      builder: (context, state) => AddEmployeeScreen(),
    ),
    GoRoute(
      path: '/edit-employee/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AddEmployeeScreen(employeeId: id);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainUserScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainAdminScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/admin',
              builder: (context, state) => HomeAdminScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/employee',
              builder: (context, state) => EmployeeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/report',
              builder: (context, state) => ReportScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile/admin',
              builder: (context, state) => ProfileAdminScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
