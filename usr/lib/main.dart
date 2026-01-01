import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PeopleHRApp());
}

class PeopleHRApp extends StatelessWidget {
  const PeopleHRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeopleHR Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7CB342)), // A nice green like BambooHR
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DomainLookupScreen(),
      },
    );
  }
}

class DomainLookupScreen extends StatefulWidget {
  const DomainLookupScreen({super.key});

  @override
  State<DomainLookupScreen> createState() => _DomainLookupScreenState();
}

class _DomainLookupScreenState extends State<DomainLookupScreen> {
  final TextEditingController _domainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _redirectToDomain() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final companyName = _domainController.text.trim().toLowerCase();
    final urlString = 'https://$companyName.peopleshr.com';
    final Uri url = Uri.parse(urlString);

    try {
      // Launch the URL. 
      // mode: LaunchMode.externalApplication ensures it opens in the browser 
      // (or redirects the current tab if configured correctly for web).
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $urlString')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Placeholder
              const Icon(
                Icons.people_alt_rounded,
                size: 64,
                color: Color(0xFF7CB342),
              ),
              const SizedBox(height: 16),
              const Text(
                'PeopleHR',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 40),
              
              // Main Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400), // Responsive width
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'What\'s your PeopleHR domain?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'We\'ll send you to your organization\'s login page.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Domain Input
                        TextFormField(
                          controller: _domainController,
                          decoration: const InputDecoration(
                            labelText: 'Company Name',
                            hintText: 'companyname',
                            suffixText: '.peopleshr.com',
                            suffixStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (_) => _redirectToDomain(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your company name';
                            }
                            // Basic regex to check for valid subdomain characters (alphanumeric and hyphens)
                            final validCharacters = RegExp(r'^[a-zA-Z0-9-]+$');
                            if (!validCharacters.hasMatch(value.trim())) {
                              return 'Please enter a valid company name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Continue Button
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _redirectToDomain,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7CB342),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  // Placeholder for help action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact support at support@peopleshr.com')),
                  );
                },
                child: const Text(
                  'Don\'t know your domain?',
                  style: TextStyle(color: Color(0xFF7CB342)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
