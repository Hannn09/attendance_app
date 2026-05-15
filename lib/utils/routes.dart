import 'package:attendance_cnn_app/features/admin/employee/employee_screen.dart';
import 'package:attendance_cnn_app/features/admin/employee/presentation/screen/add_employee_screen.dart';
import 'package:attendance_cnn_app/features/admin/home/presentation/screen/home_admin_screen.dart';
import 'package:attendance_cnn_app/features/admin/main/main_admin_screen.dart';
import 'package:attendance_cnn_app/features/admin/profile/presentation/screen/profile_admin_screen.dart';
import 'package:attendance_cnn_app/features/admin/report/presentation/screen/report_screen.dart';
import 'package:attendance_cnn_app/features/authentication/presentation/login_screen.dart';
import 'package:attendance_cnn_app/features/splash/splash_screen.dart';
import 'package:attendance_cnn_app/features/user/attendance/attendance_screen.dart';
import 'package:attendance_cnn_app/features/user/history/presentation/screen/history_screen.dart';
import 'package:attendance_cnn_app/features/user/home/presentation/screen/home_screen.dart';
import 'package:attendance_cnn_app/features/user/main/main_user_screen.dart';
import 'package:attendance_cnn_app/features/user/profile/presentation/screen/profile_screen.dart';
import 'package:attendance_cnn_app/features/user/profile/presentation/screen/setting_account_screen.dart';
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
    GoRoute(
      path: '/setting-account',
      builder: (context, state) => SettingAccountScreen(),
    ),
  ],
);
