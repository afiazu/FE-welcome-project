import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:welcome_project_fe/model/user.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/api_service.dart';
import 'package:welcome_project_fe/util/MobileSideBar.dart';
import 'package:welcome_project_fe/util/DesktopSideBar.dart';
import 'package:welcome_project_fe/util/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isEditingProfile = false;
  bool isEditingPassword = false;
  bool isLoading = false;

  String? userId;
  UserModel? currentUser;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
  setState(() => isLoading = true);

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // DEBUG: Let's see what is actually there
    final int? storedId = prefs.getInt('user_id');
    debugPrint("DEBUG: Retrieved ID from Prefs: $storedId");

    if (storedId == null) {
      debugPrint("No user ID found. Check if Login saves 'user_id'");
      setState(() => isLoading = false);
      return; 
    }

    // Ensure the class variable is updated
    setState(() {
      userId = storedId.toString(); 
    });

    UserModel user = await ApiService.getUserById(storedId.toString());

    setState(() {
      currentUser = user;
      usernameController.text = user.username;
      emailController.text = user.userEmail;
      isLoading = false;
    });
  } catch (e) {
    debugPrint("API Error: $e");
    setState(() => isLoading = false);
  }
}

  Future<void> saveProfileChanges() async {
    try {
      await ApiService.updateUserInfo(
        userId!,
        usernameController.text.trim(),
        emailController.text.trim(),
      );
      await loadUserData();
      if (mounted) {
        showRightSnackbar(context, 'Profile updated successfully', isError: false);
      }
    } catch (e) {
      if (mounted) {
        showRightSnackbar(context, 'Failed to save profile: $e', isError: true);
      }
    }
  }

  Future<void> savePasswordChanges() async {
    final currentPass = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      if (mounted) {
        showRightSnackbar(context, 'Please fill in all password fields', isError: true);
      }
      return;
    }

    if (newPass != confirmPass) {
      if (mounted) {
        showRightSnackbar(context, 'New password and confirmation do not match', isError: true);  
      }
      return;
    }

    try {
      await ApiService.updateUserPassword(
        userId!,
        currentPass,
        newPass,
      );

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      if (mounted) {
        showRightSnackbar(context, 'Password updated successfully', isError: false);
      }
    } catch (e) {
      if (mounted) {
        showRightSnackbar(context, 'Failed to update password: $e', isError: true);
      }
    }
  }

@override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 500;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 232, 232),
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: ColorConstants.ubtsBlue,
        automaticallyImplyLeading: !isDesktop, 
      ),
      drawer: isDesktop ? null : const Mobilesidebar(),
      body: Stack(
        children: [
          // Main Content
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: isDesktop ? 70 : 0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(isDesktop ? 32 : 16),
                      child: _buildBodyLayout(isDesktop),
                    ),
            ),
          ),

          if (isDesktop)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Desktopsidebar(),
            ),
        ],
      ),
    );
  }

  Widget _buildBodyLayout(bool isDesktop) {
    if (!isDesktop) {
      return Column(
        children: [
          buildLeftCard(context),
          const SizedBox(height: 20),
          buildRightCard(context),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: buildLeftCard(context)),
          const SizedBox(width: 32),
          Expanded(flex: 2, child: buildRightCard(context)),
        ],
      );
    }
  }

  // --- UI COMPONENTS ---

  Widget buildLeftCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(ImageConstants.UBTSlogo),
            ),

            const SizedBox(height: 16),

            Text(
              currentUser?.username ?? usernameController.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            const Divider(),

            Text('Member Since: ${formatDate(currentUser?.createdAt)}'),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('user_id');
                  });
                  context.go('/login');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRightCard(BuildContext context) {
    return Column(
      children: [
        // Profile Info Section
        buildSectionCard(
          title: 'Profile Information',
          subtitle: const Text(
            'Manage your personal information and preferences.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          isEditing: isEditingProfile,
          onButtonPressed: () async {
            if (isEditingProfile) {
              await saveProfileChanges();
            }
            setState(() {
              isEditingProfile = !isEditingProfile;
            });
          },
          buttonText: isEditingProfile ? 'Save Changes' : 'Change Profile Info',
          child: isEditingProfile ? buildProfileForm() : buildProfileView(),
        ),

        const SizedBox(height: 20),

        // Security Section
        buildSectionCard(
          title: 'Password & Security',
          subtitle: const Text(
            'Keep your account secure by managing your password and recent activity.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          isEditing: isEditingPassword,
          onButtonPressed: () async {
            if (isEditingPassword) {
              await savePasswordChanges();
            }

            setState(() {
              isEditingPassword = !isEditingPassword;
            });
          },
          buttonText: isEditingPassword ? 'Save Changes' : 'Change Password',
          child: isEditingPassword ? buildPasswordForm() : buildPasswordView(),
        ),
      ],
    );
  }

  // --- PROFILE VIEW & EDIT FORMS ---
  Widget buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Username: ${currentUser?.username ?? usernameController.text}'),
        const SizedBox(height: 8),
        Text('Email: ${currentUser?.userEmail ?? emailController.text}'),
        const SizedBox(height: 8),
        Text('Last Updated: ${formatDate(currentUser?.updatedAt)}'),
      ],
    );
  }

  Widget buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Don't worry, we won't show your password here!"),
      ],
    );
  }

  Widget buildPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: currentPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Current Password',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New Password',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm New Password',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  // Helper to build section cards with optional edit buttons
  Widget buildSectionCard({
    required String title,
    required Widget child,
    required Widget subtitle,
    bool isEditing = false,
    VoidCallback? onButtonPressed,
    String? buttonText,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if we're on mobile or desktop based on available width
        bool isMobile = constraints.maxWidth < 600;

        Widget actionButton = onButtonPressed != null
            ? SizedBox(
                width: isMobile
                    ? double.infinity
                    : null, // Full width on mobile, auto on desktop
                child: TextButton(
                  onPressed: onButtonPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ColorConstants.ubtsBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(buttonText ?? ''),
                ),
              )
            : const SizedBox.shrink(); // Empty widget if no button

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          subtitle,
                        ],
                      ),
                    ),
                    if (!isMobile) actionButton,
                  ],
                ),
                const SizedBox(height: 24),
                child,

                if (isMobile && onButtonPressed != null) ...[
                  const SizedBox(height: 24),
                  actionButton,
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to build read-only data fields with icons
  Widget buildDataField(String label, String value, IconData icon) {
    return SizedBox(
      width: 300, // Fixed width for fields to allow wrapping
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date == 'N/A') return 'January 15, 2024';
    final dt = DateTime.tryParse(date) ?? DateTime.now();
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }
}
