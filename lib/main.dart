import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // FlutterFire se generate hoga
import 'core/app_theme.dart';
import 'core/routes.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/booking_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/report_viewmodel.dart';
import 'viewmodels/feedback_viewmodel.dart';
import 'viewmodels/find_parking_viewmodel.dart';
import 'viewmodels/manager_viewmodel.dart';
import 'viewmodels/manager_parking_viewmodel.dart';
import 'services/notification_service.dart';
import 'viewmodels/manager_reports_viewmodel.dart';
import 'viewmodels/manager_drivers_viewmodel.dart';
import 'viewmodels/manager_parking_lots_viewmodel.dart';
import 'viewmodels/manager_analytics_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Local notifications
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => BookingViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => ReportViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
        ChangeNotifierProvider(create: (_) => FindParkingViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerParkingViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerBookingsViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerReportsViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerDriversViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerParkingLotsViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerAnalyticsViewModel()),
      ],
      child: MaterialApp(
        title: 'SmartParkify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
