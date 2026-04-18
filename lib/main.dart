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
}

class BcbAuthGate extends StatefulWidget {
  const BcbAuthGate({super.key});

  @override
  State<BcbAuthGate> createState() => _BcbAuthGateState();
}

class _BcbAuthGateState extends State<BcbAuthGate> {
  bool showSplash = true;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => showSplash = false);
    });
  }

  void enterDemo() {
    setState(() => isAuthenticated = true);
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
      return AuthStartPage(onAuthenticated: enterDemo);
    }

    return BankingShell(onLogout: logout);
  }
}

class BcbSplashScreen extends StatelessWidget {
  const BcbSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BouncingLogo(size: 150),
            SizedBox(height: 24),
            Text(
              'BCB Mobile Banking',
              style: TextStyle(
                color: BcbColors.primaryDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Bawjiase Community Bank',
              style: TextStyle(
                color: BcbColors.muted,
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: BcbColors.border),
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
  final VoidCallback onAuthenticated;

  const AuthStartPage({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<AuthStartPage> createState() => _AuthStartPageState();
}

class _AuthStartPageState extends State<AuthStartPage> {
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 920;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 24,
                vertical: 26,
              ),
              child: isMobile
                  ? Column(
                      children: [
                        const AuthBrandPanel(),
                        const SizedBox(height: 22),
                        AuthPanel(
                          isRegister: isRegister,
                          onToggle: () {
                            setState(() => isRegister = !isRegister);
                          },
                          onAuthenticated: widget.onAuthenticated,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(flex: 5, child: AuthBrandPanel()),
                        const SizedBox(width: 26),
                        Expanded(
                          flex: 4,
                          child: AuthPanel(
                            isRegister: isRegister,
                            onToggle: () {
                              setState(() => isRegister = !isRegister);
                            },
                            onAuthenticated: widget.onAuthenticated,
                          ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [BcbColors.primaryDeep, BcbColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26008A2E),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: BouncingLogo(size: 142)),
          SizedBox(height: 32),
          Text(
            'Bank safely with BCB.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 44,
              height: 1.08,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Login or register first, then continue into the demo mobile banking dashboard.',
            style: TextStyle(
              color: Color(0xFFE9FFF0),
              fontSize: 16,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24),
          DemoNotice(),
        ],
      ),
    );
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
  final VoidCallback onAuthenticated;

  const AuthPanel({
    super.key,
    required this.isRegister,
    required this.onToggle,
    required this.onAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AuthTabButton(
                  label: 'Login',
                  selected: !isRegister,
                  onTap: isRegister ? onToggle : () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AuthTabButton(
                  label: 'Register',
                  selected: isRegister,
                  onTap: isRegister ? () {} : onToggle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isRegister)
            RegisterForm(onAuthenticated: onAuthenticated)
          else
            DemoLoginForm(onAuthenticated: onAuthenticated),
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? BcbColors.primary : BcbColors.primarySoft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : BcbColors.primaryDark,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class DemoLoginForm extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const DemoLoginForm({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<DemoLoginForm> createState() => _DemoLoginFormState();
}

class _DemoLoginFormState extends State<DemoLoginForm> {
  final accountController = TextEditingController(text: '0200001234');
  final passwordController = TextEditingController(text: 'password');

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer login',
          style: TextStyle(
            color: BcbColors.dark,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Use your account number and password to enter BCB Mobile.',
          style: TextStyle(color: BcbColors.muted, height: 1.6),
        ),
        const SizedBox(height: 22),
        const FieldLabel('Account Number'),
        const SizedBox(height: 8),
        BankingField(
          controller: accountController,
          icon: Icons.account_balance_wallet_rounded,
          hint: 'Enter account number',
        ),
        const SizedBox(height: 16),
        const FieldLabel('Password'),
        const SizedBox(height: 8),
        BankingField(
          controller: passwordController,
          icon: Icons.lock_rounded,
          hint: 'Enter password',
          obscure: true,
        ),
        const SizedBox(height: 22),
        FullWidthButton(
          label: 'Login to Demo',
          icon: Icons.lock_open_rounded,
          onPressed: widget.onAuthenticated,
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const RegisterForm({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final accountController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Register account',
          style: TextStyle(
            color: BcbColors.dark,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Create demo access for a BCB customer account.',
          style: TextStyle(color: BcbColors.muted, height: 1.6),
        ),
        const SizedBox(height: 22),
        const FieldLabel('Account Number'),
        const SizedBox(height: 8),
        BankingField(
          controller: accountController,
          icon: Icons.account_balance_rounded,
          hint: 'Enter BCB account number',
        ),
        const SizedBox(height: 16),
        const FieldLabel('Phone Number'),
        const SizedBox(height: 8),
        BankingField(
          controller: phoneController,
          icon: Icons.phone_rounded,
          hint: 'Enter phone number',
        ),
        const SizedBox(height: 16),
        const FieldLabel('Password'),
        const SizedBox(height: 8),
        BankingField(
          controller: passwordController,
          icon: Icons.lock_rounded,
          hint: 'Create password',
          obscure: true,
        ),
        const SizedBox(height: 22),
        FullWidthButton(
          label: 'Create Demo Account',
          icon: Icons.person_add_alt_1_rounded,
          onPressed: widget.onAuthenticated,
        ),
      ],
    );
  }
}

class BankingShell extends StatefulWidget {
  final VoidCallback onLogout;

  const BankingShell({
    super.key,
    required this.onLogout,
  });

  @override
  State<BankingShell> createState() => _BankingShellState();
}

class _BankingShellState extends State<BankingShell> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardPage(),
      const TransferPage(),
      const PaymentsPage(),
      const CardsPage(),
      const SavingsPage(),
      const SupportPage(),
    ];

    return Scaffold(
      body: Column(
        children: [
          BcbNavBar(
            selectedIndex: selectedPage,
            onItemTap: (index) => setState(() => selectedPage = index),
            onLogout: widget.onLogout,
          ),
          Expanded(child: pages[selectedPage]),
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
                        title: 'Transfer',
                        icon: Icons.swap_horiz_rounded,
                        selected: selectedIndex == 1,
                        onTap: () => onItemTap(1),
                      ),
                      NavItem(
                        title: 'Pay Bills',
                        icon: Icons.receipt_long_rounded,
                        selected: selectedIndex == 2,
                        onTap: () => onItemTap(2),
                      ),
                      NavItem(
                        title: 'Cards',
                        icon: Icons.credit_card_rounded,
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
                        title: 'Support',
                        icon: Icons.support_agent_rounded,
                        selected: selectedIndex == 5,
                        onTap: () => onItemTap(5),
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
                    if (value == 6) {
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
                      text: 'Transfer',
                    ),
                    _menuItem(
                      value: 2,
                      icon: Icons.receipt_long_rounded,
                      text: 'Pay Bills',
                    ),
                    _menuItem(
                      value: 3,
                      icon: Icons.credit_card_rounded,
                      text: 'Cards',
                    ),
                    _menuItem(
                      value: 4,
                      icon: Icons.savings_rounded,
                      text: 'Savings',
                    ),
                    _menuItem(
                      value: 5,
                      icon: Icons.support_agent_rounded,
                      text: 'Support',
                    ),
                    const PopupMenuDivider(),
                    _menuItem(
                      value: 6,
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
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 760;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 22,
              vertical: isMobile ? 10 : 18,
            ),
            child: isMobile
                ? const PhonePreview()
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
  const TransferPage({super.key});

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
          items: const [
            InfoItem(Icons.account_balance_rounded, 'BCB to BCB', 'Instant transfers within Bawjiase Community Bank.'),
            InfoItem(Icons.business_rounded, 'Other banks', 'Send to supported bank accounts across Ghana.'),
            InfoItem(Icons.phone_android_rounded, 'Mobile money', 'Move funds to wallet numbers with reference notes.'),
          ],
        ),
      ),
    );
  }
}

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Bills and Airtime',
      subtitle:
          'Handle everyday payments from one place and keep receipts neatly attached to your account history.',
      child: ResponsiveThree(
        children: const [
          BankingServiceCard(
            icon: Icons.lightbulb_rounded,
            title: 'Electricity',
            text: 'Pay ECG bills or buy prepaid power tokens.',
          ),
          BankingServiceCard(
            icon: Icons.water_drop_rounded,
            title: 'Water',
            text: 'Settle water bills using your customer reference.',
          ),
          BankingServiceCard(
            icon: Icons.phone_iphone_rounded,
            title: 'Airtime',
            text: 'Top up your phone or send airtime to someone else.',
          ),
          BankingServiceCard(
            icon: Icons.wifi_rounded,
            title: 'Data',
            text: 'Buy data bundles for supported mobile networks.',
          ),
          BankingServiceCard(
            icon: Icons.school_rounded,
            title: 'School fees',
            text: 'Pay fees with a clear narration for receipts.',
          ),
          BankingServiceCard(
            icon: Icons.qr_code_2_rounded,
            title: 'Merchant pay',
            text: 'Scan or enter a merchant code to complete checkout.',
          ),
        ],
      ),
    );
  }
}

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

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
          items: const [
            InfoItem(Icons.lock_rounded, 'Freeze card', 'Pause card use immediately if something feels wrong.'),
            InfoItem(Icons.key_rounded, 'Change PIN', 'Update card PIN through a guided secure flow.'),
            InfoItem(Icons.payments_rounded, 'Limits', 'Set daily ATM and purchase limits for safer spending.'),
          ],
        ),
      ),
    );
  }
}

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BankingPageScaffold(
      title: 'Savings Goals',
      subtitle:
          'Create targets for school fees, business stock, emergencies, or family plans and track progress at a glance.',
      child: ResponsiveThree(
        children: const [
          GoalCard(title: 'Emergency Fund', amount: 'GHS 3,800', percent: 0.76),
          GoalCard(title: 'School Fees', amount: 'GHS 2,450', percent: 0.49),
          GoalCard(title: 'Market Stock', amount: 'GHS 6,200', percent: 0.62),
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 22,
              vertical: 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(title: title, subtitle: subtitle),
                const SizedBox(height: 24),
                child,
              ],
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
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: BcbColors.dark,
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
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: BcbColors.dark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Enter your customer ID and PIN to continue.',
            style: TextStyle(color: BcbColors.muted, height: 1.6),
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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [BcbColors.primaryDeep, BcbColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22008A2E),
            blurRadius: 22,
            offset: Offset(0, 10),
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
              color: Color(0xFFE9FFF0),
              fontSize: 16,
              height: 1.7,
              fontWeight: FontWeight.w600,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: BcbColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
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

  const BankingServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
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
              color: BcbColors.dark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: BcbColors.muted,
              height: 1.7,
            ),
          ),
        ],
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
              color: BcbColors.dark,
              fontSize: 26,
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

  const InfoItem(this.icon, this.title, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    color: BcbColors.dark,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: BcbColors.muted,
                    height: 1.55,
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

class GoalCard extends StatelessWidget {
  final String title;
  final String amount;
  final double percent;

  const GoalCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
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
                  color: BcbColors.primaryDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: BcbColors.dark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: BcbColors.muted,
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
        color: BcbColors.dark,
        fontWeight: FontWeight.w900,
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
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: BcbColors.field,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BcbColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

class FullWidthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const FullWidthButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
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
          backgroundColor: BcbColors.primary,
          foregroundColor: Colors.white,
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
