import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../reports/my_reports_view.dart';
import '../feedback/feedback_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final _editFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final vm = context.read<ProfileViewModel>();
    _nameController = TextEditingController(text: vm.driverName);
    _phoneController = TextEditingController(text: vm.driverPhone);

    // Load real data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadProfile().then((_) {
        if (mounted) {
          _nameController.text = vm.driverName;
          _phoneController.text = vm.driverPhone;
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: vm.bgColor,
          appBar: _buildAppBar(context, vm),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildDriverHeader(vm),
                  const SizedBox(height: 8),
                  _buildSectionCard(
                    vm,
                    title: 'Account',
                    children: [
                      _buildOptionTile(
                        vm,
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: vm.driverName,
                        onTap: () => _showEditProfile(context, vm),
                      ),
                      _buildDivider(vm),
                      _buildOptionTile(
                        vm,
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        subtitle: 'Visa **** 4567',
                        onTap: () => _showPaymentMethods(context, vm),
                      ),
                      _buildDivider(vm),
                      _buildSwitchTile(
                        vm,
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: vm.notificationsOn ? 'Enabled' : 'Disabled',
                        value: vm.notificationsOn,
                        onChanged: vm.toggleNotifications,
                      ),
                    ],
                  ),
                  _buildSectionCard(
                    vm,
                    title: 'Support',
                    children: [
                      _buildOptionTile(
                        vm,
                        icon: Icons.feedback_outlined,
                        title: 'Give Feedback',
                        subtitle: 'Tell us what you think',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FeedbackView(),
                          ),
                        ),
                      ),
                      _buildDivider(vm),
                      _buildOptionTile(
                        vm,
                        icon: Icons.assignment_outlined,
                        title: 'My Reports',
                        subtitle: 'Check approval status',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyReportsView(),
                          ),
                        ),
                      ),
                      _buildDivider(vm),
                      _buildOptionTile(
                        vm,
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        subtitle: 'FAQs, Chat, Email',
                        onTap: () => _showHelpSupport(context, vm),
                      ),
                      _buildDivider(vm),
                      _buildOptionTile(
                        vm,
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions',
                        subtitle: 'Read our policies',
                        onTap: () => _showTerms(context, vm),
                      ),
                      _buildDivider(vm),
                      _buildOptionTile(
                        vm,
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'How we use your data',
                        onTap: () => _showPrivacyPolicy(context, vm),
                      ),
                    ],
                  ),
                  _buildSectionCard(
                    vm,
                    title: 'App Info',
                    children: [
                      _buildInfoTile(
                        vm,
                        icon: Icons.info_outline_rounded,
                        title: 'App Version',
                        subtitle: '1.0.0 (Build 2026)',
                      ),
                      _buildDivider(vm),
                      _buildOptionTile(
                        vm,
                        icon: Icons.star_rate_outlined,
                        title: 'Rate the App',
                        subtitle: 'Love SmartParkify? Let us know!',
                        onTap: () => _showRateApp(context, vm),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildLogoutButton(context, vm),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── AppBar ─────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context, ProfileViewModel vm) {
    return AppBar(
      backgroundColor: ProfileViewModel.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'My Profile',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          tooltip: vm.isDarkMode ? 'Light Mode' : 'Dark Mode',
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              vm.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              key: ValueKey(vm.isDarkMode),
            ),
          ),
          onPressed: vm.toggleDarkMode,
        ),
      ],
    );
  }

  // ── Driver Header ────────────────────────────────────────────
  Widget _buildDriverHeader(ProfileViewModel vm) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ProfileViewModel.primary, ProfileViewModel.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ProfileViewModel.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    size: 56,
                    color: ProfileViewModel.primary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ProfileViewModel.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            vm.driverName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            vm.driverEmail,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            vm.driverPhone,
            style: const TextStyle(fontSize: 13, color: Colors.white60),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('24', 'Bookings'),
                _buildVerticalDivider(),
                _buildStatItem('186', 'Hours'),
                _buildVerticalDivider(),
                _buildStatItem('2025', 'Joined'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() =>
      Container(height: 36, width: 1, color: Colors.white24);

  // ── Section Card ───────────────────────────────────────────
  Widget _buildSectionCard(
    ProfileViewModel vm, {
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: vm.subTextColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: vm.cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: vm.isDarkMode ? 0.3 : 0.06,
                  ),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(children: children),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    ProfileViewModel vm, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ProfileViewModel.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: ProfileViewModel.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: vm.textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: vm.subTextColor),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
        size: 22,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    ProfileViewModel vm, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ProfileViewModel.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: ProfileViewModel.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: vm.textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: vm.subTextColor),
      ),
      trailing: Switch(
        value: value,
        activeThumbColor: ProfileViewModel.accent,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInfoTile(
    ProfileViewModel vm, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ProfileViewModel.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: ProfileViewModel.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: vm.textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: vm.subTextColor),
      ),
    );
  }

  Widget _buildDivider(ProfileViewModel vm) =>
      Divider(height: 1, indent: 60, endIndent: 20, color: vm.dividerColor);

  // ── Logout Button ──────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context, ProfileViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton.icon(
          onPressed: () => _confirmLogout(context, vm),
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          label: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent, width: 1.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  // ── Dialogs & Sheets ───────────────────────────────────────
  void _showEditProfile(BuildContext context, ProfileViewModel vm) {
    _nameController.text = vm.driverName;
    _phoneController.text = vm.driverPhone;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: vm.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: _editFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: vm.textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: vm.textColor),
                      decoration: _inputDecoration(
                        vm,
                        'Full Name',
                        Icons.person_outline,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Name cannot be empty';
                        }
                        if (val.trim().length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(color: vm.textColor),
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        vm,
                        'Phone Number',
                        Icons.phone_outlined,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Phone cannot be empty';
                        }
                        final digits = val.replaceAll(RegExp(r'\D'), '');
                        if (digits.length < 10) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ProfileViewModel.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          if (_editFormKey.currentState!.validate()) {
                            vm.updateProfile(
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                            );
                            Navigator.pop(sheetContext);
                            _showSnackBar(
                              context,
                              vm,
                              'Profile updated successfully ✓',
                              isSuccess: true,
                            );
                          }
                        },
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(
    ProfileViewModel vm,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: vm.subTextColor),
      prefixIcon: Icon(icon, color: ProfileViewModel.primary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: vm.dividerColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ProfileViewModel.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      filled: true,
      fillColor: vm.isDarkMode
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.grey.shade50,
    );
  }

  void _showPaymentMethods(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: vm.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Payment Methods',
          style: TextStyle(color: vm.textColor, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _paymentTile(
              vm,
              Icons.credit_card_rounded,
              'Visa **** 4567',
              'Default',
            ),
            _paymentTile(
              vm,
              Icons.account_balance_wallet_rounded,
              'Cash on Arrival',
              '',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar(context, vm, 'Add payment feature coming soon!');
            },
            child: const Text(
              '+ Add New',
              style: TextStyle(color: ProfileViewModel.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(
    ProfileViewModel vm,
    IconData icon,
    String title,
    String badge,
  ) {
    return ListTile(
      leading: Icon(icon, color: ProfileViewModel.primary),
      title: Text(title, style: TextStyle(color: vm.textColor)),
      trailing: badge.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: ProfileViewModel.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Default',
                style: TextStyle(
                  fontSize: 11,
                  color: ProfileViewModel.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  void _showHelpSupport(BuildContext context, ProfileViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: vm.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: vm.textColor,
              ),
            ),
            const SizedBox(height: 16),
            _helpTile(
              context,
              ctx,
              vm,
              Icons.email_outlined,
              'Email Us',
              'support@smartpark.com',
            ),
            _helpTile(
              context,
              ctx,
              vm,
              Icons.phone_outlined,
              'Call Us',
              '+92 300 1234567',
            ),
            _helpTile(
              context,
              ctx,
              vm,
              Icons.chat_bubble_outline_rounded,
              'Live Chat',
              'Available 9AM – 6PM PKT',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _helpTile(
    BuildContext context,
    BuildContext ctx,
    ProfileViewModel vm,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ProfileViewModel.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: ProfileViewModel.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(color: vm.textColor, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: vm.subTextColor, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: () {
        Navigator.pop(ctx);
        _showSnackBar(context, vm, 'Opening $title...');
      },
    );
  }

  void _showTerms(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: vm.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(color: vm.textColor, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _termItem(
                vm,
                '1',
                'SmartParkify is not liable for any vehicle loss or damage while parked.',
              ),
              _termItem(
                vm,
                '2',
                'Drivers must follow all parking rules and regulations.',
              ),
              _termItem(
                vm,
                '3',
                'Booking fees are non-refundable once confirmed.',
              ),
              _termItem(
                vm,
                '4',
                'Accounts found misusing the platform will be suspended.',
              ),
              _termItem(
                vm,
                '5',
                'SmartParkify reserves the right to update terms at any time.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'I Agree',
              style: TextStyle(color: ProfileViewModel.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: vm.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: vm.textColor, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _termItem(
                vm,
                '1',
                'We collect only the data necessary to provide parking services.',
              ),
              _termItem(vm, '2', 'Your data is never sold to third parties.'),
              _termItem(
                vm,
                '3',
                'You may request deletion of your account at any time.',
              ),
              _termItem(
                vm,
                '4',
                'Location data is used only during active sessions.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Close',
              style: TextStyle(color: ProfileViewModel.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _termItem(ProfileViewModel vm, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: ProfileViewModel.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                color: ProfileViewModel.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: vm.textColor, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showRateApp(BuildContext context, ProfileViewModel vm) {
    int selectedStars = 0;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: vm.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Rate SmartParkify',
                style: TextStyle(
                  color: vm.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tap a star to rate:',
                    style: TextStyle(color: vm.subTextColor),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return GestureDetector(
                        onTap: () =>
                            setDialogState(() => selectedStars = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            i < selectedStars
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: vm.subTextColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProfileViewModel.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (selectedStars > 0) {
                      _showSnackBar(
                        context,
                        vm,
                        'Thanks for rating us $selectedStars star${selectedStars > 1 ? 's' : ''}! ⭐',
                        isSuccess: true,
                      );
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: vm.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: TextStyle(color: vm.textColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout from SmartParkify?',
          style: TextStyle(color: vm.subTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: vm.subTextColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx); // dialog band karo

              // Poora navigation stack saaf karke Login page pe le jao
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    ProfileViewModel vm,
    String message, {
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess
            ? ProfileViewModel.primary
            : Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
