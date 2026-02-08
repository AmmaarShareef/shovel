import 'package:go_router/go_router.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/signup_role_screen.dart';
import '../screens/customer/customer_home_screen.dart';
import '../screens/customer/create_job_screen.dart';
import '../screens/customer/select_shoveler_screen.dart';
import '../screens/customer/job_status_screen.dart';
import '../screens/customer/job_history_screen.dart';
import '../screens/customer/rate_shoveler_screen.dart';
import '../screens/shoveler/shoveler_home_screen.dart';
import '../screens/shoveler/set_boundary_screen.dart';
import '../screens/shoveler/available_jobs_screen.dart';
import '../screens/shoveler/job_details_screen.dart';
import '../screens/shoveler/complete_job_screen.dart';
import '../screens/shoveler/my_jobs_screen.dart';
import '../screens/shoveler/earnings_screen.dart';
import '../screens/shoveler/jobs_map_screen.dart';
import '../screens/shared/profile_screen.dart';
import '../screens/shared/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/role-selection',
  routes: [
    // Auth routes
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/signup-role',
      builder: (context, state) => const SignupRoleScreen(),
    ),
    // Customer routes
    GoRoute(
      path: '/customer/home',
      builder: (context, state) => const CustomerHomeScreen(),
    ),
    GoRoute(
      path: '/customer/create-job',
      builder: (context, state) => const CreateJobScreen(),
    ),
    GoRoute(
      path: '/customer/select-shoveler/:jobId',
      builder: (context, state) => SelectShovelerScreen(
        jobId: state.pathParameters['jobId']!,
      ),
    ),
    GoRoute(
      path: '/customer/job-status/:jobId',
      builder: (context, state) => JobStatusScreen(
        jobId: state.pathParameters['jobId']!,
      ),
    ),
    GoRoute(
      path: '/customer/job-history',
      builder: (context, state) => const JobHistoryScreen(),
    ),
    GoRoute(
      path: '/customer/rate-shoveler/:jobId',
      builder: (context, state) => RateShovelerScreen(
        jobId: state.pathParameters['jobId']!,
      ),
    ),
    // Shoveler routes
    GoRoute(
      path: '/shoveler/home',
      builder: (context, state) => const ShovelerHomeScreen(),
    ),
    GoRoute(
      path: '/shoveler/set-boundary',
      builder: (context, state) => const SetBoundaryScreen(),
    ),
    GoRoute(
      path: '/shoveler/available-jobs',
      builder: (context, state) => const AvailableJobsScreen(),
    ),
    GoRoute(
      path: '/shoveler/jobs-map',
      builder: (context, state) => const JobsMapScreen(),
    ),
    GoRoute(
      path: '/shoveler/job-details/:jobId',
      builder: (context, state) => JobDetailsScreen(
        jobId: state.pathParameters['jobId']!,
      ),
    ),
    GoRoute(
      path: '/shoveler/complete-job/:jobId',
      builder: (context, state) => CompleteJobScreen(
        jobId: state.pathParameters['jobId']!,
      ),
    ),
    GoRoute(
      path: '/shoveler/my-jobs',
      builder: (context, state) => const MyJobsScreen(),
    ),
    GoRoute(
      path: '/shoveler/earnings',
      builder: (context, state) => const EarningsScreen(),
    ),
    // Shared routes
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

