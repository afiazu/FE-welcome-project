import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditingProfile = false;
  bool isEditingPassword = false;

  final TextEditingController usernameController = TextEditingController(
    text: 'john.anderson',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'john.anderson@example.com',
  );
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 232, 232),
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorConstants.ubtsBlue,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            // MOBILE VIEW: Stack everything vertically
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildLeftCard(context),
                  const SizedBox(height: 20),
                  buildRightCard(context),
                ],
              ),
            );
          } else {
            // DESKTOP VIEW: Side-by-side layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: buildLeftCard(context)),

                  const SizedBox(width: 32),

                  Expanded(
                    flex: 2, // Right side gets more space
                    child: buildRightCard(context),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
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

          const Text(
            'John Anderson',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          const Divider(),

          buildInfoRow('Member Since:', 'January 15, 2024'),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
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
          onButtonPressed: () {
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
          onButtonPressed: () {
            setState(() {
              isEditingPassword = !isEditingPassword;
            });
          },
          buttonText: isEditingPassword ? 'Save Changes' : 'Change Password',
          child: isEditingPassword ? buildPasswordForm() : buildPasswordView(),
        ),

        const SizedBox(height: 20),

        buildSectionCard(
          title: 'Recent Activity',
          subtitle: const Text(
            'Your recent account activities and changes.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Updated profile information'),
                subtitle: const Text('Today at 9:45 AM'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.lock_outline),
                title: const Text('Changed password'),
                subtitle: const Text('Yesterday at 6:30 PM'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- PROFILE VIEW & EDIT FORMS ---
  Widget buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Username: john.anderson'),
        SizedBox(height: 8),
        Text('Email: john.a@warehouse.com'),
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
        Text('Last changed: January 10, 2024'),
        SizedBox(height: 8),
        Text('Password strength: Strong'),
      ],
    );
  }

  Widget buildPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Current Password',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New Password',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
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

  // Helper to build simple label-value rows for profile info
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
