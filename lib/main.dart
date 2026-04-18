import 'package:flutter/material.dart';

void main() {
  runApp(const BcbBankApp());
}

class BcbBankApp extends StatelessWidget {
  const BcbBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCB Mobile Banking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: BcbColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BcbColors.primary,
          brightness: Brightness.light,
        ),
      ),
      home: const BcbAuthGate(),
    );
  }
}

class BcbColors {
  static const primary = Color(0xFF008A2E);
  static const primaryDark = Color(0xFF006323);
  static const primaryDeep = Color(0xFF003F18);
  static const primarySoft = Color(0xFFE8F7ED);
  static const accent = Color(0xFFFFC83D);
  static const mint = Color(0xFFB8F2C8);
  static const danger = Color(0xFFDC2626);
  static const dark = Color(0xFF102018);
  static const muted = Color(0xFF65756B);
  static const border = Color(0xFFDDE8E0);
  static const canvas = Color(0xFFF5F8F3);
  static const card = Colors.white;
  static const field = Color(0xFFF8FBF7);
  static const appDark = Color(0xFF0D0F14);
  static const panelDark = Color(0xFF171A22);
  static const panelSoft = Color(0xFF1C202A);
  static const lineDark = Color(0xFF262B35);
  static const textSoft = Color(0xFF8E94A6);
  static const aqua = Color(0xFF2DD4CB);
  static const warning = Color(0xFF2C2718);
}

class DemoCustomerProfile {
  final String fullName;
  final String accountNumber;
  final String phoneNumber;
  final String accountType;
  final String transactionPin;

  const DemoCustomerProfile({
    required this.fullName,
    required this.accountNumber,
    required this.phoneNumber,
    required this.accountType,
    required this.transactionPin,
  });
}

class BcbAuthGate extends StatefulWidget {
  const BcbAuthGate({super.key});

  @override
  State<BcbAuthGate> createState() => _BcbAuthGateState();
}

class _BcbAuthGateState extends State<BcbAuthGate> {
  bool showSplash = true;
  bool isAuthenticated = false;
  DemoCustomerProfile? profile;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => showSplash = false);
    });
  }

  void enterDemo([DemoCustomerProfile? nextProfile]) {
    setState(() {
      profile =
          nextProfile ??
          profile ??
          const DemoCustomerProfile(
            fullName: 'Demo Customer',
            accountNumber: '00014821',
            phoneNumber: '0240000000',
            accountType: 'Savings Account',
            transactionPin: '1234',
          );
      isAuthenticated = true;
    });
  }

  void logout() {
    setState(() => isAuthenticated = false);
  }

  @override
  Widget build(BuildContext context) {
    if (showSplash) {
      return const BcbSplashScreen();
    }

    if (!isAuthenticated) {
      return AuthStartPage(
        onAuthenticated: enterDemo,
        existingProfile: profile,
      );
    }

    return BankingShell(
      onLogout: logout,
      profile: profile!,
    );
  }
}

class BcbSplashScreen extends StatelessWidget {
  const BcbSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: BcbColors.appDark,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BouncingLogo(size: 150),
            SizedBox(height: 24),
            Text(
              'Bawjiase Community Bank',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Secure mobile banking demo',
              style: TextStyle(
                color: BcbColors.textSoft,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BouncingLogo extends StatefulWidget {
  final double size;

  const BouncingLogo({
    super.key,
    this.size = 108,
  });

  @override
  State<BouncingLogo> createState() => _BouncingLogoState();
}

class _BouncingLogoState extends State<BouncingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> bounce;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
    bounce = Tween<double>(begin: 0, end: -16).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bounce,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, bounce.value),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.size / 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22008A2E),
              blurRadius: 28,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Image.asset('assets/images/bcb-logo.png', fit: BoxFit.contain),
      ),
    );
  }
}

class AuthStartPage extends StatefulWidget {
  final ValueChanged<DemoCustomerProfile> onAuthenticated;
  final DemoCustomerProfile? existingProfile;

  const AuthStartPage({
    super.key,
    required this.onAuthenticated,
    this.existingProfile,
  });

  @override
  State<AuthStartPage> createState() => _AuthStartPageState();
}

class _AuthStartPageState extends State<AuthStartPage> {
  bool isRegister = false;
  bool showForgotPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BcbColors.appDark,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        BouncingLogo(size: 108),
                        SizedBox(height: 24),
                        Text(
                          'Bawjiase Community Bank',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Secure mobile banking demo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: BcbColors.textSoft,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  AuthPanel(
                    isRegister: isRegister,
                    onToggle: () {
                      setState(() {
                        showForgotPassword = false;
                        isRegister = !isRegister;
                      });
                    },
                    onForgotPassword: () {
                      setState(() => showForgotPassword = true);
                    },
                    onBackToLogin: () {
                      setState(() {
                        showForgotPassword = false;
                        isRegister = false;
                      });
                    },
                    showForgotPassword: showForgotPassword,
                    existingProfile: widget.existingProfile,
                    onAuthenticated: widget.onAuthenticated,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBrandPanel extends StatelessWidget {
  const AuthBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Demo mode: authentication checks are disabled for testing. Any account number and password can continue.',
              style: TextStyle(
                color: Colors.white,
                height: 1.55,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPanel extends StatelessWidget {
  final bool isRegister;
  final VoidCallback onToggle;
  final VoidCallback onForgotPassword;
  final VoidCallback onBackToLogin;
  final bool showForgotPassword;
  final DemoCustomerProfile? existingProfile;
  final ValueChanged<DemoCustomerProfile> onAuthenticated;

  const AuthPanel({
    super.key,
    required this.isRegister,
    required this.onToggle,
    required this.onForgotPassword,
    required this.onBackToLogin,
    required this.showForgotPassword,
    required this.existingProfile,
    required this.onAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: BcbColors.panelDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: BcbColors.lineDark),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showForgotPassword)
            ForgotPasswordForm(onBackToLogin: onBackToLogin)
          else if (isRegister)
            RegisterForm(
              onAuthenticated: onAuthenticated,
              onSwitchToLogin: onToggle,
            )
          else
            DemoLoginForm(
              onAuthenticated: onAuthenticated,
              onSwitchToRegister: onToggle,
              onForgotPassword: onForgotPassword,
              existingProfile: existingProfile,
            ),
        ],
      ),
    );
  }
}

class AuthTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AuthTabButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? BcbColors.aqua : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? BcbColors.appDark : BcbColors.textSoft,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class DemoLoginForm extends StatefulWidget {
  final ValueChanged<DemoCustomerProfile> onAuthenticated;
  final VoidCallback onSwitchToRegister;
  final VoidCallback onForgotPassword;
  final DemoCustomerProfile? existingProfile;

  const DemoLoginForm({
    super.key,
    required this.onAuthenticated,
    required this.onSwitchToRegister,
    required this.onForgotPassword,
    required this.existingProfile,
  });

  @override
  State<DemoLoginForm> createState() => _DemoLoginFormState();
}

class _DemoLoginFormState extends State<DemoLoginForm> {
  late final TextEditingController accountController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    accountController = TextEditingController(
      text: widget.existingProfile?.accountNumber ?? '0200001234',
    );
    passwordController = TextEditingController(text: 'password');
  }

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        widget.existingProfile ??
        DemoCustomerProfile(
          fullName: 'Demo Customer',
          accountNumber: accountController.text.trim().isEmpty
              ? '0200001234'
              : accountController.text.trim(),
          phoneNumber: '0240000000',
          accountType: 'Savings Account',
          transactionPin: '1234',
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Use any account number and password for demo testing.',
          style: TextStyle(color: BcbColors.textSoft, height: 1.6),
        ),
        const SizedBox(height: 22),
        const AuthFieldLabel('Account Number'),
        const SizedBox(height: 8),
        AuthField(
          controller: accountController,
          icon: Icons.person_outline_rounded,
          hint: '0012345678',
        ),
        const SizedBox(height: 16),
        const AuthFieldLabel('Password'),
        const SizedBox(height: 8),
        AuthField(
          controller: passwordController,
          icon: Icons.lock_outline_rounded,
          hint: 'Enter password',
          obscure: true,
        ),
        const SizedBox(height: 22),
        FullWidthButton(
          label: 'Login',
          icon: Icons.login_rounded,
          onPressed: () {
            widget.onAuthenticated(
              DemoCustomerProfile(
                fullName: profile.fullName,
                accountNumber: accountController.text.trim().isEmpty
                    ? profile.accountNumber
                    : accountController.text.trim(),
                phoneNumber: profile.phoneNumber,
                accountType: profile.accountType,
                transactionPin: profile.transactionPin,
              ),
            );
          },
          backgroundColor: BcbColors.aqua,
          foregroundColor: BcbColors.appDark,
        ),
        const SizedBox(height: 22),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'New customer? ',
                style: TextStyle(color: BcbColors.textSoft, fontSize: 15),
              ),
              GestureDetector(
                onTap: widget.onSwitchToRegister,
                child: const Text(
                  'Register for demo access',
                  style: TextStyle(
                    color: BcbColors.aqua,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: GestureDetector(
            onTap: widget.onForgotPassword,
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                color: BcbColors.aqua,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback onSwitchToLogin;

  const RegisterForm({
    super.key,
    required this.onAuthenticated,
    required this.onSwitchToLogin,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameController = TextEditingController();
  final accountController = TextEditingController();
  final phoneController = TextEditingController();
  final ghanaCardController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final occupationController = TextEditingController();
  final nextOfKinController = TextEditingController();
  final branchController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final pinController = TextEditingController();
  String selectedAccountType = 'Savings Account';
  int currentStep = 0;

  @override
  void dispose() {
    nameController.dispose();
    accountController.dispose();
    phoneController.dispose();
    ghanaCardController.dispose();
    dobController.dispose();
    addressController.dispose();
    occupationController.dispose();
    nextOfKinController.dispose();
    branchController.dispose();
    otpController.dispose();
    passwordController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepTitles = [
      'Customer Details',
      'KYC Details',
      'Verification',
      'Account Type',
      'OTP Verification',
      'Create PIN',
    ];
    final progress = (currentStep + 1) / stepTitles.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Open Your BCB Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Demo onboarding accepts any valid-looking details.',
          style: TextStyle(color: BcbColors.textSoft, height: 1.6),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: BcbColors.panelSoft,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: BcbColors.lineDark),
          ),
          child: const Column(
            children: [
              Row(
                children: [
                  Text(
                    'Step ${currentStep + 1} of 6',
                    style: TextStyle(color: BcbColors.textSoft, fontSize: 14),
                  ),
                  Spacer(),
                  Text(
                    '${(progress * 100).round()}%',
                    style: TextStyle(color: BcbColors.textSoft, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(999)),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: BcbColors.lineDark,
                  valueColor: AlwaysStoppedAnimation(BcbColors.aqua),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF123C3A),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF1D625D)),
              ),
              child: const Icon(Icons.person_outline_rounded, color: BcbColors.aqua),
            ),
            const SizedBox(width: 14),
            const Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          stepTitles[currentStep],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        ..._buildStepFields(),
        const SizedBox(height: 22),
        FullWidthButton(
          label: currentStep == 5 ? 'Create Account' : 'Continue',
          icon: currentStep == 5
              ? Icons.check_circle_rounded
              : Icons.arrow_forward_rounded,
          onPressed: () {
            if (currentStep < 5) {
              setState(() => currentStep += 1);
              return;
            }
            widget.onAuthenticated(
              DemoCustomerProfile(
                fullName: nameController.text.trim().isEmpty
                    ? 'Demo Customer'
                    : nameController.text.trim(),
                accountNumber: accountController.text.trim().isEmpty
                    ? '00014821'
                    : accountController.text.trim(),
                phoneNumber: phoneController.text.trim().isEmpty
                    ? '0240000000'
                    : phoneController.text.trim(),
                accountType: selectedAccountType,
                transactionPin: pinController.text.trim().isEmpty
                    ? '1234'
                    : pinController.text.trim(),
              ),
            );
          },
          backgroundColor: BcbColors.aqua,
          foregroundColor: BcbColors.appDark,
        ),
        if (currentStep > 0) ...[
          const SizedBox(height: 12),
          FullWidthButton(
            label: 'Back',
            icon: Icons.arrow_back_rounded,
            onPressed: () => setState(() => currentStep -= 1),
            backgroundColor: BcbColors.panelSoft,
            foregroundColor: Colors.white,
          ),
        ],
        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: widget.onSwitchToLogin,
            child: const Text(
              'Already registered? Login',
              style: TextStyle(
                color: BcbColors.textSoft,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStepFields() {
    switch (currentStep) {
      case 0:
        return [
          AuthField(controller: nameController, hint: 'Full legal name'),
          const SizedBox(height: 16),
          AuthField(controller: accountController, hint: 'Account number'),
          const SizedBox(height: 16),
          AuthField(
            controller: phoneController,
            hint: 'Phone number e.g. 0241234567',
          ),
          const SizedBox(height: 16),
          AuthField(controller: passwordController, hint: 'Create password', obscure: true),
        ];
      case 1:
        return [
          AuthField(controller: ghanaCardController, hint: 'Ghana Card number'),
          const SizedBox(height: 16),
          AuthField(controller: dobController, hint: 'Date of birth'),
          const SizedBox(height: 16),
          AuthField(controller: addressController, hint: 'Residential address'),
          const SizedBox(height: 16),
          AuthField(controller: occupationController, hint: 'Occupation'),
          const SizedBox(height: 16),
          AuthField(controller: nextOfKinController, hint: 'Next of kin'),
          const SizedBox(height: 16),
          AuthField(controller: branchController, hint: 'Preferred branch'),
        ];
      case 2:
        return const [
          UploadPlaceholder(label: 'Upload Ghana Card front'),
          SizedBox(height: 16),
          UploadPlaceholder(label: 'Upload Ghana Card back'),
          SizedBox(height: 16),
          UploadPlaceholder(label: 'Selfie verification'),
        ];
      case 3:
        return [
          AccountTypeChoice(
            selected: selectedAccountType,
            onSelect: (value) => setState(() => selectedAccountType = value),
          ),
        ];
      case 4:
        return [
          const Text(
            'A demo OTP has been sent. Any 6 digits will work.',
            style: TextStyle(color: BcbColors.textSoft),
          ),
          const SizedBox(height: 16),
          AuthField(controller: otpController, hint: 'Enter 6-digit OTP'),
        ];
      default:
        return [
          const Text(
            'Create a 4-digit transaction PIN for transfers and approvals.',
            style: TextStyle(color: BcbColors.textSoft),
          ),
          const SizedBox(height: 16),
          AuthField(controller: pinController, hint: 'Create 4-digit PIN', obscure: true),
        ];
    }
  }
}

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const ForgotPasswordForm({super.key, required this.onBackToLogin});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final accountController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    phoneController.dispose();
    otpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your account number, phone number, any 6-digit OTP, and a new password.',
          style: TextStyle(color: BcbColors.textSoft, height: 1.6),
        ),
        const SizedBox(height: 22),
        AuthField(controller: accountController, hint: 'Account number'),
        const SizedBox(height: 16),
        AuthField(controller: phoneController, hint: 'Phone number'),
        const SizedBox(height: 16),
        AuthField(controller: otpController, hint: 'Demo OTP code'),
        const SizedBox(height: 16),
        AuthField(controller: passwordController, hint: 'New password', obscure: true),
        const SizedBox(height: 22),
        FullWidthButton(
          label: 'Reset Password',
          icon: Icons.lock_reset_rounded,
          onPressed: widget.onBackToLogin,
          backgroundColor: BcbColors.aqua,
          foregroundColor: BcbColors.appDark,
        ),
        const SizedBox(height: 14),
        FullWidthButton(
          label: 'Back to Login',
          icon: Icons.arrow_back_rounded,
          onPressed: widget.onBackToLogin,
          backgroundColor: BcbColors.panelSoft,
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}

class UploadPlaceholder extends StatelessWidget {
  final String label;

  const UploadPlaceholder({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BcbColors.panelSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BcbColors.lineDark),
      ),
      child: Row(
        children: [
          const Icon(Icons.upload_file_rounded, color: BcbColors.aqua),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const Text('Placeholder', style: TextStyle(color: BcbColors.textSoft)),
        ],
      ),
    );
  }
}

class AccountTypeChoice extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const AccountTypeChoice({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const options = [
      'Savings Account',
      'Current Account',
      'Student Account',
      'Business Account',
      'Susu / Group Savings',
    ];

    return Column(
      children: options.map((option) {
        final active = option == selected;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => onSelect(option),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF123C3A) : BcbColors.panelSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? const Color(0xFF1D625D) : BcbColors.lineDark,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    active ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: active ? BcbColors.aqua : BcbColors.textSoft,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class BankingShell extends StatefulWidget {
  final VoidCallback onLogout;
  final DemoCustomerProfile profile;

  const BankingShell({
    super.key,
    required this.onLogout,
    required this.profile,
  });

  @override
  State<BankingShell> createState() => _BankingShellState();
}

class _BankingShellState extends State<BankingShell> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;
    final pages = [
      DashboardPage(profile: widget.profile),
      TransferPage(profile: widget.profile),
      MobileMoneyPage(profile: widget.profile),
      PaymentsPage(profile: widget.profile),
      SavingsPage(profile: widget.profile),
      CardsPage(profile: widget.profile),
      MorePage(profile: widget.profile),
    ];

    return Scaffold(
      backgroundColor: BcbColors.appDark,
      body: Column(
        children: [
          if (!isMobile)
            BcbNavBar(
              selectedIndex: selectedPage,
              onItemTap: (index) => setState(() => selectedPage = index),
              onLogout: widget.onLogout,
            ),
          Expanded(child: pages[selectedPage]),
          if (isMobile)
            MobileBottomNav(
              selectedIndex: selectedPage,
              onItemTap: (index) => setState(() => selectedPage = index),
            ),
        ],
      ),
    );
  }
}

class BcbNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTap;
  final VoidCallback onLogout;

  const BcbNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
    required this.onLogout,
  });

  PopupMenuItem<int> _menuItem({
    required int value,
    required IconData icon,
    required String text,
  }) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: BcbColors.primaryDark),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: BcbColors.dark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 1120;
    final compact = width < 420;

    return Container(
      color: BcbColors.canvas,
      padding: EdgeInsets.fromLTRB(compact ? 12 : 18, 18, compact ? 12 : 18, 10),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1320),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 14 : 16,
            vertical: compact ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.97),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: BcbColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 28,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              const BrandMark(),
              const SizedBox(width: 12),
              if (!isMobile) ...[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NavItem(
                        title: 'Home',
                        icon: Icons.dashboard_rounded,
                        selected: selectedIndex == 0,
                        onTap: () => onItemTap(0),
                      ),
                      NavItem(
                        title: 'Send Money',
                        icon: Icons.swap_horiz_rounded,
                        selected: selectedIndex == 1,
                        onTap: () => onItemTap(1),
                      ),
                      NavItem(
                        title: 'MoMo',
                        icon: Icons.phone_android_rounded,
                        selected: selectedIndex == 2,
                        onTap: () => onItemTap(2),
                      ),
                      NavItem(
                        title: 'Pay Bills',
                        icon: Icons.receipt_long_rounded,
                        selected: selectedIndex == 3,
                        onTap: () => onItemTap(3),
                      ),
                      NavItem(
                        title: 'Savings',
                        icon: Icons.savings_rounded,
                        selected: selectedIndex == 4,
                        onTap: () => onItemTap(4),
                      ),
                      NavItem(
                        title: 'Cards',
                        icon: Icons.credit_card_rounded,
                        selected: selectedIndex == 5,
                        onTap: () => onItemTap(5),
                      ),
                      NavItem(
                        title: 'More',
                        icon: Icons.dashboard_customize_rounded,
                        selected: selectedIndex == 6,
                        onTap: () => onItemTap(6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: onLogout,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    foregroundColor: BcbColors.primaryDark,
                    side: const BorderSide(color: BcbColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => onItemTap(1),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Send Money'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    backgroundColor: BcbColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              if (isMobile)
                PopupMenuButton<int>(
                  tooltip: 'Open menu',
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 30,
                    color: BcbColors.dark,
                  ),
                  color: Colors.white,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    if (value == 7) {
                      onLogout();
                    } else {
                      onItemTap(value);
                    }
                  },
                  itemBuilder: (context) => [
                    _menuItem(
                      value: 0,
                      icon: Icons.dashboard_rounded,
                      text: 'Home',
                    ),
                    _menuItem(
                      value: 1,
                      icon: Icons.swap_horiz_rounded,
                      text: 'Send Money',
                    ),
                    _menuItem(
                      value: 2,
                      icon: Icons.phone_android_rounded,
                      text: 'MoMo',
                    ),
                    _menuItem(
                      value: 3,
                      icon: Icons.receipt_long_rounded,
                      text: 'Pay Bills',
                    ),
                    _menuItem(
                      value: 4,
                      icon: Icons.savings_rounded,
                      text: 'Savings',
                    ),
                    _menuItem(
                      value: 5,
                      icon: Icons.credit_card_rounded,
                      text: 'Cards',
                    ),
                    _menuItem(
                      value: 6,
                      icon: Icons.dashboard_customize_rounded,
                      text: 'More',
                    ),
                    const PopupMenuDivider(),
                    _menuItem(
                      value: 7,
                      icon: Icons.logout_rounded,
                      text: 'Logout',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 420;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: compact ? 42 : 54,
          width: compact ? 42 : 54,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BcbColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10008A2E),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/bcb-logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: compact ? 10 : 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BCB MOBILE',
              style: TextStyle(
                fontSize: compact ? 16 : 20,
                fontWeight: FontWeight.w900,
                color: BcbColors.primaryDark,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Bawjiase Community Bank',
              style: TextStyle(
                fontSize: compact ? 9 : 11,
                color: BcbColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? BcbColors.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFFCBE9D3) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? BcbColors.primary : BcbColors.dark,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  color: selected ? BcbColors.primary : BcbColors.dark,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const DashboardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 760;

    return SingleChildScrollView(
      child: Container(
        color: BcbColors.appDark,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 0 : 22,
                vertical: isMobile ? 0 : 18,
              ),
              child: isMobile
                  ? MobileDashboard(profile: profile)
                  : const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: BankingHero(),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          flex: 4,
                          child: ActivityPanel(),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileDashboard extends StatelessWidget {
  final DemoCustomerProfile profile;

  const MobileDashboard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
          decoration: const BoxDecoration(
            color: BcbColors.warning,
            border: Border(
              top: BorderSide(color: BcbColors.primary, width: 2),
              bottom: BorderSide(color: Color(0x66483C1A)),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.warning_amber_rounded, color: Color(0xFFF0D072), size: 18),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Demo mode: login accepts any account number and password.\nTransactions are test data only.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF0D072),
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good morning,',
                          style: TextStyle(
                            color: BcbColors.textSoft,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const HomeIconButton(icon: Icons.history_rounded),
                  const SizedBox(width: 12),
                  const HomeIconButton(icon: Icons.notifications_none_rounded, badge: '2'),
                ],
              ),
              const SizedBox(height: 24),
              GlowingBalanceCard(profile: profile),
              const SizedBox(height: 22),
              const Row(
                children: [
                  Expanded(
                    child: OverviewMetricCard(
                      title: 'Income',
                      amount: 'GH¢ 5,745.20',
                      delta: 'Up +12%',
                      deltaColor: Color(0xFF4ADE80),
                      icon: Icons.trending_up_rounded,
                      iconBg: Color(0xFF103B37),
                      iconColor: BcbColors.aqua,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OverviewMetricCard(
                      title: 'Expenses',
                      amount: 'GH¢ 2,039.50',
                      delta: 'Down -8%',
                      deltaColor: Color(0xFFF87171),
                      icon: Icons.show_chart_rounded,
                      iconBg: Color(0xFF182A4B),
                      iconColor: Color(0xFF7AA2FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: OverviewMetricCard(
                      title: 'Balance',
                      amount: 'GH¢ 24,850.00',
                      delta: 'Up +5%',
                      deltaColor: Color(0xFF4ADE80),
                      icon: Icons.account_balance_wallet_outlined,
                      iconBg: Color(0xFF2B1C45),
                      iconColor: Color(0xFFC084FC),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OverviewMetricCard(
                      title: 'Invested',
                      amount: 'GH¢ 3,200',
                      delta: 'Up +18%',
                      deltaColor: Color(0xFF4ADE80),
                      icon: Icons.savings_outlined,
                      iconBg: Color(0xFF3C2613),
                      iconColor: Color(0xFFFB923C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: LargeActionCard(
                      icon: Icons.send_rounded,
                      label: 'Send',
                      onTap: () => _openTask(context, SendMoneyFlowPage(profile: profile)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: LargeActionCard(
                      icon: Icons.phone_android_rounded,
                      label: 'MoMo',
                      iconColor: Color(0xFF7AA2FF),
                      iconBg: Color(0xFF182A4B),
                      onTap: () => _openTask(context, MobileMoneyFlowPage(profile: profile)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: LargeActionCard(
                      icon: Icons.receipt_long_rounded,
                      label: 'Bills',
                      iconColor: Color(0xFFC084FC),
                      iconBg: Color(0xFF2B1C45),
                      onTap: () => _openTask(context, BillPaymentFlowPage(profile: profile)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LargeActionCard(
                      icon: Icons.savings_rounded,
                      label: 'Top-up',
                      iconColor: Color(0xFF4ADE80),
                      iconBg: Color(0xFF173817),
                      onTap: () => _openTask(context, SavingsTopUpPage(profile: profile)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: LargeActionCard(
                      icon: Icons.lock_rounded,
                      label: 'Freeze',
                      iconColor: Color(0xFFFB923C),
                      iconBg: Color(0xFF352216),
                      onTap: () => _openTask(context, FreezeCardPage(profile: profile)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: LargeActionCard(
                      icon: Icons.request_quote_rounded,
                      label: 'Loan',
                      onTap: () => _openTask(context, LoanApplicationPage(profile: profile)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openTask(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class HomeIconButton extends StatelessWidget {
  final IconData icon;
  final String? badge;

  const HomeIconButton({super.key, required this.icon, this.badge});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: BcbColors.panelDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: BcbColors.lineDark),
          ),
          child: Icon(icon, color: const Color(0xFFA2A8BA), size: 28),
        ),
        if (badge != null)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: BcbColors.aqua,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: BcbColors.appDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class GlowingBalanceCard extends StatelessWidget {
  final DemoCustomerProfile profile;

  const GlowingBalanceCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF10292B), Color(0xFF111722)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF155954)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4400C090),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL BALANCE',
                      style: TextStyle(
                        color: BcbColors.textSoft,
                        fontSize: 14,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '${profile.accountType} - ****${profile.accountNumber.length >= 4 ? profile.accountNumber.substring(profile.accountNumber.length - 4) : profile.accountNumber}',
                      style: const TextStyle(
                        color: BcbColors.textSoft,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const MiniSquareIcon(
                icon: Icons.remove_red_eye_outlined,
                iconColor: BcbColors.aqua,
                bg: Color(0xFF1A2431),
              ),
            ],
          ),
          SizedBox(height: 28),
          Text(
            'GH¢ 24,850.00',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 24),
          const Row(
            children: [
              TrendPill(),
              SizedBox(width: 12),
              Text(
                'vs last month',
                style: TextStyle(
                  color: BcbColors.textSoft,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrendPill extends StatelessWidget {
  const TrendPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF163C38),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1D625D)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up_rounded, color: BcbColors.aqua, size: 18),
          SizedBox(width: 6),
          Text(
            '+12.5%',
            style: TextStyle(
              color: BcbColors.aqua,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewMetricCard extends StatelessWidget {
  final String title;
  final String amount;
  final String delta;
  final Color deltaColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const OverviewMetricCard({
    super.key,
    required this.title,
    required this.amount,
    required this.delta,
    required this.deltaColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BcbColors.panelDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: BcbColors.lineDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiniSquareIcon(icon: icon, iconColor: iconColor, bg: iconBg),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(color: BcbColors.textSoft, fontSize: 15)),
          const SizedBox(height: 10),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            delta,
            style: TextStyle(
              color: deltaColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class LargeActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;

  const LargeActionCard({
    super.key,
    required this.icon,
    required this.label,
    this.iconBg = const Color(0xFF123C3A),
    this.iconColor = BcbColors.aqua,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: BcbColors.panelDark,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: BcbColors.lineDark),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MiniSquareIcon(icon: icon, iconColor: iconColor, bg: iconBg),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: BcbColors.textSoft,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniSquareIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bg;

  const MiniSquareIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bg.withOpacity(0.7)),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

class MobileBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTap;

  const MobileBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.grid_view_rounded, 'Home'),
      (Icons.swap_horiz_rounded, 'Transfer'),
      (Icons.phone_android_rounded, 'MoMo'),
      (Icons.credit_card_rounded, 'Cards'),
      (Icons.grid_on_rounded, 'More'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
      decoration: const BoxDecoration(
        color: Color(0xFF13161D),
        border: Border(top: BorderSide(color: BcbColors.lineDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final pageMap = [0, 1, 2, 5, 6];
          final targetIndex = pageMap[index];
          final selected = selectedIndex == targetIndex;
          final item = items[index];
          return InkWell(
            onTap: () => onItemTap(targetIndex),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF123C3A) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item.$1,
                      color: selected ? BcbColors.aqua : const Color(0xFF8F95A8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.$2,
                    style: TextStyle(
                      color: selected ? BcbColors.aqua : const Color(0xFF8F95A8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AlertStrip extends StatelessWidget {
  const AlertStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [BcbColors.primaryDeep, BcbColors.primary],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22008A2E),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Text(
        'Welcome to BCB Mobile Banking. Keep your PIN private and approve only transactions you started.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}

class BankingHero extends StatelessWidget {
  const BankingHero({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < 980;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 22 : 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: BcbColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: compact
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PhonePreview(),
                SizedBox(height: 22),
                HeroCopy(),
              ],
            )
          : const Row(
              children: [
                Expanded(flex: 6, child: HeroCopy()),
                SizedBox(width: 28),
                Expanded(flex: 5, child: PhonePreview()),
              ],
            ),
    );
  }
}

class HeroCopy extends StatelessWidget {
  const HeroCopy({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final headlineSize = width < 520 ? 34.0 : 48.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusPill(
          icon: Icons.verified_user_rounded,
          label: 'Secure BCB digital banking',
        ),
        const SizedBox(height: 18),
        Text(
          'Your bank, ready whenever you are.',
          style: TextStyle(
            fontSize: headlineSize,
            height: 1.08,
            fontWeight: FontWeight.w900,
            color: BcbColors.dark,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Check your balance, send money, pay bills, save towards goals, and reach Bawjiase Community Bank support from one clean mobile experience.',
          style: TextStyle(
            fontSize: 17,
            height: 1.7,
            color: BcbColors.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.lock_open_rounded),
              label: const Text('Open Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: BcbColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_circle_fill_rounded),
              label: const Text('View Demo'),
              style: OutlinedButton.styleFrom(
                foregroundColor: BcbColors.primaryDark,
                side: const BorderSide(color: BcbColors.border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            TrustChip(label: 'Mobile money ready'),
            TrustChip(label: 'Bill payments'),
            TrustChip(label: 'Mini statements'),
          ],
        ),
      ],
    );
  }
}

class PhonePreview extends StatelessWidget {
  const PhonePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final phoneWidth = width < 420 ? 235.0 : 330.0;
    final outerPadding = width < 420 ? 10.0 : 14.0;
    final innerPadding = width < 420 ? 14.0 : 18.0;
    final balanceFont = width < 420 ? 23.0 : 29.0;

    return Center(
      child: Container(
        width: phoneWidth,
        constraints: const BoxConstraints(maxWidth: 360),
        padding: EdgeInsets.all(outerPadding),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1F16),
          borderRadius: BorderRadius.circular(34),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 32,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(innerPadding),
          decoration: BoxDecoration(
            color: BcbColors.canvas,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: width < 420 ? 34 : 42,
                    height: width < 420 ? 34 : 42,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: BcbColors.border),
                    ),
                    child: Image.asset('assets/images/bcb-logo.png'),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning',
                          style: TextStyle(
                            color: BcbColors.muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Ama Mensah',
                          style: TextStyle(
                            color: BcbColors.dark,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none_rounded),
                ],
              ),
              SizedBox(height: width < 420 ? 14 : 18),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(width < 420 ? 14 : 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [BcbColors.primaryDeep, BcbColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Balance',
                      style: TextStyle(
                        color: Color(0xFFDDF7E6),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      width < 420 ? 'GHS\n12,480.75' : 'GHS 12,480.75',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: balanceFont,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Savings Account  **** 2048',
                      style: TextStyle(
                        color: Color(0xFFE9FFF0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width < 420 ? 12 : 16),
              const Row(
                children: [
                  Expanded(
                    child: QuickActionTile(
                      icon: Icons.send_rounded,
                      label: 'Send',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: QuickActionTile(
                      icon: Icons.call_received_rounded,
                      label: 'Receive',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: QuickActionTile(
                      icon: Icons.receipt_long_rounded,
                      label: 'Bills',
                    ),
                  ),
                ],
              ),
              SizedBox(height: width < 420 ? 12 : 16),
              const MiniTransaction(
                icon: Icons.shopping_bag_rounded,
                title: 'Market payment',
                amount: '-GHS 86.00',
              ),
              const MiniTransaction(
                icon: Icons.savings_rounded,
                title: 'Goal deposit',
                amount: '+GHS 200.00',
                positive: true,
              ),
              const MiniTransaction(
                icon: Icons.phone_android_rounded,
                title: 'Airtime top up',
                amount: '-GHS 20.00',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityPanel extends StatelessWidget {
  const ActivityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: BcbColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today at a glance',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: BcbColors.dark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your account activity stays clean, current, and easy to read.',
            style: TextStyle(color: BcbColors.muted, height: 1.6),
          ),
          const SizedBox(height: 22),
          const StatRow(
            label: 'Money In',
            value: 'GHS 2,460.00',
            icon: Icons.trending_up_rounded,
          ),
          const StatRow(
            label: 'Money Out',
            value: 'GHS 1,130.50',
            icon: Icons.trending_down_rounded,
          ),
          const StatRow(
            label: 'Pending Approval',
            value: '2 requests',
            icon: Icons.pending_actions_rounded,
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: BcbColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFCBE9D3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_rounded, color: BcbColors.primaryDark),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your last secure login was from this device.',
                    style: TextStyle(
                      color: BcbColors.primaryDeep,
                      fontWeight: FontWeight.w800,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransferPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const TransferPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Send Money',
      subtitle:
          'Transfer to BCB accounts, other banks, and mobile money wallets with clear confirmation before money moves.',
      child: ResponsiveTwo(
        left: const TransferFormCard(),
        right: InfoStack(
          title: 'Transfer options',
          items: [
            InfoItem(Icons.account_balance_rounded, 'BCB to BCB', 'Instant transfers within Bawjiase Community Bank.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SendMoneyFlowPage(profile: profile)))),
            InfoItem(Icons.business_rounded, 'Other banks', 'Send to supported bank accounts across Ghana.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SendMoneyFlowPage(profile: profile)))),
            InfoItem(Icons.phone_android_rounded, 'Mobile money', 'Move funds to wallet numbers with reference notes.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MobileMoneyFlowPage(profile: profile)))),
            const InfoItem(Icons.groups_rounded, 'Saved beneficiaries', 'Reuse trusted accounts and wallets without entering details again.'),
            const InfoItem(Icons.receipt_long_rounded, 'Transfer receipts', 'Download or share proof of payment after each transfer.'),
          ],
        ),
      ),
    );
  }
}

class MobileMoneyPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const MobileMoneyPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Mobile Money',
      subtitle: 'Send to MTN, Telecel, and AirtelTigo wallets with a simple guided flow.',
      child: ResponsiveTwo(
        left: const MobileMoneyFormCard(),
        right: InfoStack(
          title: 'MoMo services',
          items: [
            InfoItem(Icons.send_to_mobile_rounded, 'Wallet transfer', 'Move funds to a verified mobile money number.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MobileMoneyFlowPage(profile: profile)))),
            InfoItem(Icons.phone_callback_rounded, 'Cash out request', 'Prepare a cash out request from your bank balance.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MobileMoneyFlowPage(profile: profile)))),
            const InfoItem(Icons.people_alt_rounded, 'Saved wallets', 'Reuse trusted wallet numbers for faster transfers.'),
          ],
        ),
      ),
    );
  }
}

class PaymentsPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const PaymentsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Bills and Airtime',
      subtitle:
          'Handle everyday payments from one place and keep receipts neatly attached to your account history.',
      child: ResponsiveThree(
        children: [
          BankingServiceCard(
            icon: Icons.lightbulb_rounded,
            title: 'Electricity',
            text: 'Pay ECG bills or buy prepaid power tokens.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
          BankingServiceCard(
            icon: Icons.water_drop_rounded,
            title: 'Water',
            text: 'Settle water bills using your customer reference.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
          BankingServiceCard(
            icon: Icons.phone_iphone_rounded,
            title: 'Airtime',
            text: 'Top up your phone or send airtime to someone else.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
          BankingServiceCard(
            icon: Icons.wifi_rounded,
            title: 'Data',
            text: 'Buy data bundles for supported mobile networks.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
          BankingServiceCard(
            icon: Icons.school_rounded,
            title: 'School fees',
            text: 'Pay fees with a clear narration for receipts.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
          BankingServiceCard(
            icon: Icons.qr_code_2_rounded,
            title: 'Merchant pay',
            text: 'Scan or enter a merchant code to complete checkout.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
          BankingServiceCard(
            icon: Icons.home_work_rounded,
            title: 'Rent',
            text: 'Pay rent and property-related invoices directly from your account.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
          BankingServiceCard(
            icon: Icons.local_hospital_rounded,
            title: 'Hospital',
            text: 'Cover clinic and hospital bills using your patient reference.',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BillPaymentFlowPage(profile: profile))),
          ),
        ],
      ),
    );
  }
}

class CardsPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const CardsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Cards',
      subtitle:
          'Control card access, review spending, and keep card services close without visiting a branch.',
      child: ResponsiveTwo(
        left: const BankCardPreview(),
        right: InfoStack(
          title: 'Card controls',
          items: [
            InfoItem(Icons.lock_rounded, 'Freeze card', 'Pause card use immediately if something feels wrong.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FreezeCardPage(profile: profile)))),
            InfoItem(Icons.key_rounded, 'Change PIN', 'Update card PIN through a guided secure flow.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardSettingsPage(profile: profile)))),
            InfoItem(Icons.payments_rounded, 'Limits', 'Set daily ATM and purchase limits for safer spending.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardSettingsPage(profile: profile)))),
            InfoItem(Icons.public_rounded, 'Online payments', 'Switch online and international payments on or off.', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardSettingsPage(profile: profile)))),
            const InfoItem(Icons.report_gmailerrorred_rounded, 'Lost card', 'Report a missing card and request a replacement fast.'),
          ],
        ),
      ),
    );
  }
}

class SavingsPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const SavingsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Savings Goals',
      subtitle:
          'Create targets for school fees, business stock, emergencies, or family plans and track progress at a glance.',
      child: ResponsiveThree(
        children: [
          GoalCard(title: 'Emergency Fund', amount: 'GHS 3,800', percent: 0.76, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SavingsTopUpPage(profile: profile)))),
          GoalCard(title: 'School Fees', amount: 'GHS 2,450', percent: 0.49, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SavingsTopUpPage(profile: profile)))),
          GoalCard(title: 'Market Stock', amount: 'GHS 6,200', percent: 0.62, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SavingsTopUpPage(profile: profile)))),
          GoalCard(title: 'Home Project', amount: 'GHS 4,900', percent: 0.31, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SavingsTopUpPage(profile: profile)))),
        ],
      ),
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'BCB Support',
      subtitle:
          'Get help with account access, card issues, transfers, payments, and branch services.',
      child: ResponsiveThree(
        children: const [
          BankingServiceCard(
            icon: Icons.chat_rounded,
            title: 'Live chat',
            text: 'Start a secure conversation with customer support.',
          ),
          BankingServiceCard(
            icon: Icons.location_on_rounded,
            title: 'Branch locator',
            text: 'Find BCB service points and working hours.',
          ),
          BankingServiceCard(
            icon: Icons.report_problem_rounded,
            title: 'Report issue',
            text: 'Flag a failed transfer, card concern, or suspicious activity.',
          ),
          BankingServiceCard(
            icon: Icons.call_rounded,
            title: 'Call support',
            text: 'Reach the bank quickly for urgent account or card assistance.',
          ),
          BankingServiceCard(
            icon: Icons.document_scanner_rounded,
            title: 'Statements',
            text: 'Request mini statements or account documents from support.',
          ),
          BankingServiceCard(
            icon: Icons.schedule_rounded,
            title: 'Book visit',
            text: 'Schedule a branch appointment before you arrive.',
          ),
        ],
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const MorePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'More Services',
      subtitle: 'Open additional BCB tools, support services, and admin review placeholders.',
      child: Column(
        children: [
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                Text('Name: ${profile.fullName}', style: const TextStyle(color: BcbColors.textSoft)),
                const SizedBox(height: 8),
                Text('Account: ${profile.accountNumber}', style: const TextStyle(color: BcbColors.textSoft)),
                const SizedBox(height: 8),
                Text('Phone: ${profile.phoneNumber}', style: const TextStyle(color: BcbColors.textSoft)),
                const SizedBox(height: 8),
                Text('Account type: ${profile.accountType}', style: const TextStyle(color: BcbColors.textSoft)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ResponsiveThree(
            children: [
          BankingServiceCard(
            icon: Icons.request_quote_rounded,
            title: 'Loan Application',
            text: 'Submit a demo loan application with amount, purpose, and repayment plan.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => LoanApplicationPage(profile: profile)),
            ),
          ),
          BankingServiceCard(
            icon: Icons.lock_rounded,
            title: 'Freeze Card',
            text: 'Temporarily lock a card when you want stronger account control.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => FreezeCardPage(profile: profile)),
            ),
          ),
          BankingServiceCard(
            icon: Icons.tune_rounded,
            title: 'Card Settings',
            text: 'Adjust online payments, ATM access, and daily spending limits.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CardSettingsPage(profile: profile)),
            ),
          ),
          BankingServiceCard(
            icon: Icons.admin_panel_settings_rounded,
            title: 'Admin Panel',
            text: 'Preview the bank staff review dashboard for KYC, loans, tickets, and disputes.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdminBackOfficePage()),
            ),
          ),
          const BankingServiceCard(
            icon: Icons.verified_user_rounded,
            title: 'Real Backend Next',
            text: 'Firebase, Supabase, or a custom backend will replace demo-only local data.',
          ),
          const BankingServiceCard(
            icon: Icons.shield_moon_rounded,
            title: 'Public Launch Next',
            text: 'Real OTP, role security, integrations, audit logs, and fraud checks come after demo completion.',
          ),
            ],
          ),
        ],
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Secure Login',
      subtitle:
          'Access your BCB mobile banking profile with the same calm, direct interface across phone and desktop.',
      child: ResponsiveTwo(
        left: const LoginCard(),
        right: InfoStack(
          title: 'Before you continue',
          items: const [
            InfoItem(Icons.pin_rounded, 'Keep your PIN private', 'BCB will never ask for your full PIN by phone or message.'),
            InfoItem(Icons.phonelink_lock_rounded, 'Trust this device', 'Only approve device prompts that you personally started.'),
            InfoItem(Icons.history_rounded, 'Review activity', 'Check recent transactions after signing in.'),
          ],
        ),
      ),
    );
  }
}

class BankingPageScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const BankingPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 920;

    return SingleChildScrollView(
      child: Container(
        color: BcbColors.appDark,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 22,
                vertical: isMobile ? 16 : 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(title: title, subtitle: subtitle),
                  const SizedBox(height: 20),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransferFormCard extends StatelessWidget {
  const TransferFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'New transfer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 18),
          FieldLabel('Recipient'),
          SizedBox(height: 8),
          BankingField(icon: Icons.person_rounded, hint: 'Enter account or wallet number'),
          SizedBox(height: 16),
          FieldLabel('Amount'),
          SizedBox(height: 8),
          BankingField(icon: Icons.payments_rounded, hint: 'GHS 0.00'),
          SizedBox(height: 16),
          FieldLabel('Reference'),
          SizedBox(height: 8),
          BankingField(icon: Icons.note_alt_rounded, hint: 'What is this for?'),
          SizedBox(height: 22),
          FullWidthButton(label: 'Review Transfer', icon: Icons.check_circle_rounded),
        ],
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome back',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Enter your customer ID and PIN to continue.',
            style: TextStyle(color: BcbColors.textSoft, height: 1.6),
          ),
          SizedBox(height: 22),
          FieldLabel('Customer ID'),
          SizedBox(height: 8),
          BankingField(icon: Icons.badge_rounded, hint: 'BCB customer ID'),
          SizedBox(height: 16),
          FieldLabel('PIN'),
          SizedBox(height: 8),
          BankingField(icon: Icons.lock_rounded, hint: 'Enter secure PIN', obscure: true),
          SizedBox(height: 22),
          FullWidthButton(label: 'Login Securely', icon: Icons.lock_open_rounded),
        ],
      ),
    );
  }
}

class MobileMoneyFormCard extends StatelessWidget {
  const MobileMoneyFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Mobile money transfer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 18),
          FieldLabel('Wallet number'),
          SizedBox(height: 8),
          BankingField(icon: Icons.phone_android_rounded, hint: '0241234567'),
          SizedBox(height: 16),
          FieldLabel('Network'),
          SizedBox(height: 8),
          BankingField(icon: Icons.network_cell_rounded, hint: 'MTN / Telecel / AirtelTigo'),
          SizedBox(height: 16),
          FieldLabel('Amount'),
          SizedBox(height: 8),
          BankingField(icon: Icons.payments_rounded, hint: 'GHS 0.00'),
          SizedBox(height: 22),
          FullWidthButton(label: 'Review MoMo Transfer', icon: Icons.check_circle_rounded),
        ],
      ),
    );
  }
}

class TaskFlowPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final DemoCustomerProfile profile;
  final List<Widget> body;

  const TaskFlowPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.profile,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BcbColors.appDark,
      appBar: AppBar(
        backgroundColor: BcbColors.appDark,
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: BankingPageScaffold(
        title: title,
        subtitle: subtitle,
        child: Column(
          children: body
              .expand((widget) => [widget, const SizedBox(height: 18)])
              .toList()
            ..removeLast(),
        ),
      ),
    );
  }
}

class SendMoneyFlowPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const SendMoneyFlowPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return TaskFlowPage(
      title: 'Send Money',
      subtitle: 'Transfer funds from ${profile.accountNumber} with demo confirmation and receipt.',
      profile: profile,
      body: [
        const TransferFormCard(),
        DemoReceiptCard(
          title: 'Transfer receipt',
          lines: [
            'Customer: ${profile.fullName}',
            'From account: ${profile.accountNumber}',
            'PIN approval: ${profile.transactionPin}',
          ],
        ),
      ],
    );
  }
}

class MobileMoneyFlowPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const MobileMoneyFlowPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return TaskFlowPage(
      title: 'Mobile Money',
      subtitle: 'Demo transfer to a mobile wallet with the registered customer profile.',
      profile: profile,
      body: [
        const MobileMoneyFormCard(),
        DemoReceiptCard(
          title: 'Wallet receipt',
          lines: [
            'Customer: ${profile.fullName}',
            'Phone: ${profile.phoneNumber}',
            'Account type: ${profile.accountType}',
          ],
        ),
      ],
    );
  }
}

class BillPaymentFlowPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const BillPaymentFlowPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return TaskFlowPage(
      title: 'Pay Bills',
      subtitle: 'Select a bill category and complete a demo payment from your BCB account.',
      profile: profile,
      body: const [
        BillPaymentCard(),
      ],
    );
  }
}

class SavingsTopUpPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const SavingsTopUpPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return TaskFlowPage(
      title: 'Savings Top-up',
      subtitle: 'Top up your ${profile.accountType} with a quick transfer into your savings goal.',
      profile: profile,
      body: [
        const SavingsTopUpCard(),
        DemoReceiptCard(
          title: 'Savings confirmation',
          lines: [
            'Depositor: ${profile.fullName}',
            'Account: ${profile.accountNumber}',
            'PIN ready: ${profile.transactionPin}',
          ],
        ),
      ],
    );
  }
}

class FreezeCardPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const FreezeCardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return TaskFlowPage(
      title: 'Freeze Card',
      subtitle: 'Pause your card instantly in demo mode and keep account access active.',
      profile: profile,
      body: const [
        ToggleActionCard(
          title: 'Card safety switch',
          description: 'Disable card usage for ATM, POS, and online payments until you unfreeze it.',
          buttonLabel: 'Freeze Card',
          icon: Icons.lock_rounded,
        ),
      ],
    );
  }
}

class CardSettingsPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const CardSettingsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return TaskFlowPage(
      title: 'Card Settings',
      subtitle: 'Change spending controls and card permissions for demo testing.',
      profile: profile,
      body: const [
        ToggleActionCard(
          title: 'Online payments',
          description: 'Turn e-commerce transactions on or off.',
          buttonLabel: 'Update Online Access',
          icon: Icons.public_rounded,
        ),
        ToggleActionCard(
          title: 'ATM withdrawals',
          description: 'Adjust ATM withdrawals and spending limits.',
          buttonLabel: 'Change ATM Settings',
          icon: Icons.atm_rounded,
        ),
      ],
    );
  }
}

class LoanApplicationPage extends StatelessWidget {
  final DemoCustomerProfile profile;

  const LoanApplicationPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return TaskFlowPage(
      title: 'Loan Application',
      subtitle: 'Submit a loan request using your registered BCB customer details.',
      profile: profile,
      body: [
        const LoanApplicationCard(),
        DemoReceiptCard(
          title: 'Application submitted',
          lines: [
            'Applicant: ${profile.fullName}',
            'Account: ${profile.accountNumber}',
            'Review queue: Back-office demo panel',
          ],
        ),
      ],
    );
  }
}

class AdminBackOfficePage extends StatelessWidget {
  const AdminBackOfficePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: BcbColors.appDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin / Back-office',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 18),
              Expanded(
                child: ResponsiveThree(
                  children: [
                    BankingServiceCard(icon: Icons.badge_rounded, title: 'New Accounts', text: 'Review customer onboarding and KYC submissions.'),
                    BankingServiceCard(icon: Icons.request_quote_rounded, title: 'Loan Queue', text: 'Review submitted loan applications and statuses.'),
                    BankingServiceCard(icon: Icons.support_agent_rounded, title: 'Support Tickets', text: 'View and respond to support requests and disputes.'),
                    BankingServiceCard(icon: Icons.report_problem_rounded, title: 'Disputed Transactions', text: 'Track suspicious or disputed customer activity.'),
                    BankingServiceCard(icon: Icons.verified_user_rounded, title: 'KYC Status', text: 'Approve or reject uploaded verification details.'),
                    BankingServiceCard(icon: Icons.analytics_rounded, title: 'Export Reports', text: 'Generate internal reports and dashboard summaries.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BillPaymentCard extends StatelessWidget {
  const BillPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Bill payment', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          SizedBox(height: 18),
          FieldLabel('Bill type'),
          SizedBox(height: 8),
          BankingField(icon: Icons.receipt_long_rounded, hint: 'Electricity / Water / TV / School Fees'),
          SizedBox(height: 16),
          FieldLabel('Reference'),
          SizedBox(height: 8),
          BankingField(icon: Icons.confirmation_number_rounded, hint: 'Customer reference'),
          SizedBox(height: 16),
          FieldLabel('Amount'),
          SizedBox(height: 8),
          BankingField(icon: Icons.payments_rounded, hint: 'GHS 0.00'),
          SizedBox(height: 22),
          FullWidthButton(label: 'Pay Bill', icon: Icons.check_circle_rounded),
        ],
      ),
    );
  }
}

class SavingsTopUpCard extends StatelessWidget {
  const SavingsTopUpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Savings top-up', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          SizedBox(height: 18),
          FieldLabel('Savings goal'),
          SizedBox(height: 8),
          BankingField(icon: Icons.savings_rounded, hint: 'Emergency Fund / School Fees / Home Project'),
          SizedBox(height: 16),
          FieldLabel('Amount'),
          SizedBox(height: 8),
          BankingField(icon: Icons.payments_rounded, hint: 'GHS 0.00'),
          SizedBox(height: 16),
          FieldLabel('Narration'),
          SizedBox(height: 8),
          BankingField(icon: Icons.note_alt_rounded, hint: 'Savings top-up note'),
          SizedBox(height: 22),
          FullWidthButton(label: 'Top Up Savings', icon: Icons.arrow_circle_up_rounded),
        ],
      ),
    );
  }
}

class ToggleActionCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final IconData icon;

  const ToggleActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MiniSquareIcon(icon: icon, iconColor: BcbColors.aqua, bg: const Color(0xFF123C3A)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(description, style: const TextStyle(color: BcbColors.textSoft, height: 1.6)),
          const SizedBox(height: 20),
          FullWidthButton(label: buttonLabel, icon: Icons.check_circle_rounded),
        ],
      ),
    );
  }
}

class LoanApplicationCard extends StatelessWidget {
  const LoanApplicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Loan request', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          SizedBox(height: 18),
          FieldLabel('Loan amount'),
          SizedBox(height: 8),
          BankingField(icon: Icons.request_quote_rounded, hint: 'GHS 0.00'),
          SizedBox(height: 16),
          FieldLabel('Purpose'),
          SizedBox(height: 8),
          BankingField(icon: Icons.description_rounded, hint: 'Business stock / school fees / emergency'),
          SizedBox(height: 16),
          FieldLabel('Repayment period'),
          SizedBox(height: 8),
          BankingField(icon: Icons.schedule_rounded, hint: '6 months / 12 months'),
          SizedBox(height: 22),
          FullWidthButton(label: 'Submit Loan Application', icon: Icons.send_rounded),
        ],
      ),
    );
  }
}

class DemoReceiptCard extends StatelessWidget {
  final String title;
  final List<String> lines;

  const DemoReceiptCard({super.key, required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(line, style: const TextStyle(color: BcbColors.textSoft)),
            ),
          ),
        ],
      ),
    );
  }
}

class BankCardPreview extends StatelessWidget {
  const BankCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [BcbColors.primaryDeep, BcbColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset('assets/images/bcb-logo.png'),
                ),
                const Spacer(),
                const Icon(Icons.contactless_rounded, color: Colors.white, size: 34),
              ],
            ),
            const SizedBox(height: 52),
            const Text(
              '****  ****  ****  2048',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'AMA MENSAH',
                    style: TextStyle(
                      color: Color(0xFFE9FFF0),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '09/29',
                  style: TextStyle(
                    color: Color(0xFFE9FFF0),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductBand extends StatelessWidget {
  const ProductBand({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: BcbColors.primaryDeep,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22006323),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 22,
        spacing: 22,
        children: [
          ProductMetric(value: '24/7', label: 'Account access'),
          ProductMetric(value: '3 min', label: 'Guided transfer'),
          ProductMetric(value: 'GHS', label: 'Local banking'),
          ProductMetric(value: 'BCB', label: 'Community focused'),
        ],
      ),
    );
  }
}

class ProductMetric extends StatelessWidget {
  final String value;
  final String label;

  const ProductMetric({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFDDF7E6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: BcbColors.dark,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            color: BcbColors.muted,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final titleSize = width < 520 ? 30.0 : 38.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: BcbColors.panelDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: BcbColors.lineDark),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: BcbColors.textSoft,
              fontSize: 15,
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(26),
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: BcbColors.panelDark,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: BcbColors.lineDark),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: BcbColors.primarySoft,
            child: Icon(icon, color: BcbColors.primary, size: 28),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: BcbColors.dark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: BcbColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class BankingServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback? onTap;

  const BankingServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: BcbColors.primarySoft,
              child: Icon(icon, color: BcbColors.primary, size: 27),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                color: BcbColors.textSoft,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoStack extends StatelessWidget {
  final String title;
  final List<InfoItem> items;

  const InfoStack({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          ...items.map((item) => item),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback? onTap;

  const InfoItem(this.icon, this.title, this.text, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: BcbColors.primarySoft,
            child: Icon(icon, color: BcbColors.primaryDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: BcbColors.textSoft,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return onTap == null
        ? content
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: content,
          );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final String amount;
  final double percent;
  final VoidCallback? onTap;

  const GoalCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 27,
                backgroundColor: BcbColors.primarySoft,
                child: Icon(Icons.savings_rounded, color: BcbColors.primary),
              ),
              const Spacer(),
              Text(
                '${(percent * 100).round()}%',
                style: const TextStyle(
                  color: BcbColors.aqua,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: BcbColors.textSoft,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: BcbColors.primarySoft,
              valueColor: const AlwaysStoppedAnimation(BcbColors.primary),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class ResponsiveTwo extends StatelessWidget {
  final Widget left;
  final Widget right;

  const ResponsiveTwo({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 920;

    if (isMobile) {
      return Column(
        children: [
          left,
          const SizedBox(height: 22),
          right,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: left),
        const SizedBox(width: 22),
        Expanded(flex: 4, child: right),
      ],
    );
  }
}

class ResponsiveThree extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveThree({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 920;
    final contentWidth = screenWidth > 1320 ? 1320.0 : screenWidth;

    if (isMobile) {
      return Column(
        children: [
          for (final child in children) ...[
            child,
            if (child != children.last) const SizedBox(height: 18),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 22,
      runSpacing: 22,
      children: children
          .map(
            (child) => SizedBox(
              width: (contentWidth - 88) / 3,
              child: child,
            ),
          )
          .toList(),
    );
  }
}

class HoverLift extends StatefulWidget {
  final Widget child;
  final double translateY;

  const HoverLift({
    super.key,
    required this.child,
    this.translateY = -6,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.identity()
          ..translate(0.0, isHovered ? widget.translateY : 0.0),
        child: widget.child,
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const StatusPill({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: BcbColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCBE9D3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: BcbColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: BcbColors.primaryDark,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class TrustChip extends StatelessWidget {
  final String label;

  const TrustChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: BcbColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: BcbColors.primaryDark,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BcbColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: BcbColors.primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: BcbColors.dark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class MiniTransaction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final bool positive;

  const MiniTransaction({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    this.positive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: Colors.white,
            child: Icon(icon, color: BcbColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: BcbColors.dark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: positive ? BcbColors.primaryDark : BcbColors.dark,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BcbColors.field,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BcbColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: BcbColors.primarySoft,
            child: Icon(icon, color: BcbColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: BcbColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: BcbColors.dark,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  final String label;

  const AuthFieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: BcbColors.textSoft,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? icon;
  final String hint;
  final bool obscure;

  const AuthField({
    super.key,
    this.controller,
    this.icon,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: BcbColors.textSoft,
          fontSize: 16,
        ),
        filled: true,
        fillColor: BcbColors.panelSoft,
        prefixIcon: icon == null ? null : Icon(icon, color: BcbColors.textSoft),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.lineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.lineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.aqua),
        ),
      ),
    );
  }
}

class BankingField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData icon;
  final String hint;
  final bool obscure;

  const BankingField({
    super.key,
    this.controller,
    required this.icon,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: BcbColors.textSoft),
        filled: true,
        fillColor: BcbColors.panelSoft,
        prefixIcon: Icon(icon, color: BcbColors.textSoft),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.lineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.lineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.aqua, width: 1.4),
        ),
      ),
    );
  }
}

class FullWidthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const FullWidthButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () {},
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? BcbColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
