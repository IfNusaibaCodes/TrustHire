import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/size.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/Utilities/Validation/validation.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_logo.dart';
import 'package:trust_hire_app/common/styles/spacing_styles.dart';

import 'Login/login_page.dart';


class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey         = GlobalKey<FormState>();
  bool  _isLoading       = false;
  bool  _emailSent       = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
        redirectTo: 'com.example.trust_hire_app://login-callback/',
      );
      if (mounted) {
        setState(() => _emailSent = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: TColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: _emailSent ? _SuccessView(
            email: _emailController.text.trim(),
            onBackToLogin: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
            ),
          ) : _RequestView(
            height:          height,
            formKey:         _formKey,
            emailController: _emailController,
            isLoading:       _isLoading,
            onSubmit:        _sendResetEmail,
          ),
        ),
      ),
    );
  }
}


class _RequestView extends StatelessWidget {
  final double                   height;
  final GlobalKey<FormState>     formKey;
  final TextEditingController    emailController;
  final bool                     isLoading;
  final VoidCallback             onSubmit;

  const _RequestView({
    required this.height,
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height * 0.03),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Text(
                    Ttexts.AppName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              const SizedBox(height: Tsize.sm),
              Center(
                child: Text(
                  Ttexts.forgetPasswordTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: height * 0.03),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            Ttexts.forgetPasswordSubTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TColors.textLightGrey,
            ),
          ),
        ),

        SizedBox(height: height * 0.04),

        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextFormField(
                  controller:  emailController,
                  validator:   (value) => TValidator.validateEmail(value),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                    labelText:  Ttexts.email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: Tsize.spaceBtwSections),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onSubmit,
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width:  20,
                      child:  CircularProgressIndicator(
                        strokeWidth:  2,
                        color:        Colors.white,
                      ),
                    )
                        : const Text('Send Reset Link'),
                  ),
                ),

                const SizedBox(height: Tsize.spaceBtwItems),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Back to Login',
                      style: GoogleFonts.inter(
                        color:      Colors.black,
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class _SuccessView extends StatelessWidget {
  final String       email;
  final VoidCallback onBackToLogin;

  const _SuccessView({
    required this.email,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: height * 0.03),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Text(
                    Ttexts.AppName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              const SizedBox(height: Tsize.sm),
              Center(
                child: Text(
                  Ttexts.changeYourPasswordTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: height * 0.05),

        Container(
          width:  80,
          height: 80,
          decoration: BoxDecoration(
            color:       TColors.success.withValues(alpha: 0.1),
            shape:       BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size:  42,
            color: TColors.success,
          ),
        ),

        SizedBox(height: height * 0.03),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Text(
                Ttexts.changeYourPasswordSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.textLightGrey,
                ),
              ),
              const SizedBox(height: Tsize.spaceBtwItems),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:   10,
                ),
                decoration: BoxDecoration(
                  color:        TColors.lightContainer,
                  borderRadius: BorderRadius.circular(20),
                  border:       Border.all(color: TColors.borderPrimary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mail_outline_rounded,
                        size: 16, color: TColors.textLightGrey),
                    const SizedBox(width: 8),
                    Text(
                      email,
                      style: GoogleFonts.inter(
                        fontSize:   13,
                        fontWeight: FontWeight.w600,
                        color:      TColors.textDarkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: height * 0.05),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBackToLogin,
              child: const Text('Back to Login'),
            ),
          ),
        ),

        const SizedBox(height: Tsize.spaceBtwItems),

        Text(
          'Didn\'t receive the email? Check your spam folder.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: TColors.textLightGrey,
          ),
        ),

        const SizedBox(height: Tsize.spaceBtwSections),
      ],
    );
  }
}