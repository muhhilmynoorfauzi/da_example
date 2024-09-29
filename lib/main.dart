import 'package:da_example/firebase_options.dart';
import 'package:da_example/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => CounterProvider())], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return loginPage(context);
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            // return const Text('belum login');
            return loginPage(context);
          }
        });
  }

  Widget loginPage(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    bool isLogin = user?.email != null;
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(strokeAlign: 10)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? 'Anda sudah Login\n Selamat datang ${user?.displayName}' : 'Anda belum Login\nSilahkan login terlebih dahulu',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (!isLogin)
                    OutlinedButton(
                      onPressed: () async {
                        setState(() => isLoading = !isLoading);
                        try {
                          final provider = Provider.of<CounterProvider>(context, listen: false);
                          await provider.googleLogin();

                          setState(() => isLoading = !isLoading);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text('Login with Google'),
                    ),
                  if (isLogin)
                    OutlinedButton(
                      onPressed: () async {
                        setState(() => isLoading = !isLoading);
                        final provider = Provider.of<CounterProvider>(context, listen: false);
                        provider.logout();
                        setState(() => isLoading = !isLoading);
                      },
                      child: const Text('Logout'),
                    )
                ],
              ),
      ),
    );
  }
}
