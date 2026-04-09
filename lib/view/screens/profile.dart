import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:welcome_project_fe/model/user.dart';
import 'package:welcome_project_fe/model/activity.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/api_service.dart';
import 'package:welcome_project_fe/util/MobileSideBar.dart';
import 'package:welcome_project_fe/util/DesktopSideBar.dart';
import 'package:welcome_project_fe/util/snackbar.dart';
import 'package:welcome_project_fe/util/profileSectionCard.dart';
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
  List<ActivityModel> activities = [];

  Map<String, dynamic> _getActivityDetails(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'update profile':
        return {'icon': Icons.person, 'color': Colors.blue};
      case 'change password':
        return {'icon': Icons.lock, 'color': Colors.orange};
      default:
        return {'icon': Icons.info, 'color': Colors.grey};
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController userBioController = TextEditingController();

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
    imageUrlController.dispose();
    super.dispose();
  }

  void showImageUrlDialog(BuildContext context) {
    // We use the existing controller so it shows the current URL if there is one
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows keyboard to push it up
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom + 20, // Keyboard padding
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Update Profile Image",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: "Paste Image URL",
                hintText: "https://example.com/image.jpg",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the popup
                  await saveProfileChanges(); // Use your existing save logic!
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.ubtsBlue,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  "Save Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadUserData() async {
    setState(() => isLoading = true);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? storedId = prefs.getInt('user_id');

      if (storedId == null) {
        debugPrint("No user ID found. Check if Login saves 'user_id'");
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        userId = storedId.toString();
      });

      UserModel user = await ApiService.getUserById(storedId.toString());
      List<ActivityModel> activities = await ApiService.getActivitiesByUserId(
        storedId.toString(),
      );

      setState(() {
        currentUser = user;
        usernameController.text = user.username;
        emailController.text = user.userEmail;
        imageUrlController.text = user.profileImageUrl ?? '';
        userBioController.text = user.userBio ?? '';
        this.activities = activities;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("API Error: $e");
      setState(() => isLoading = false);
      if (mounted) {
        showRightSnackbar(
          context,
          'Failed to load profile data',
          isError: true,
        );
      }
    }
  }

  Future<void> saveProfileChanges() async {
    try {
      await ApiService.updateUserInfo(
        userId!,
        usernameController.text.trim(),
        emailController.text.trim(),
        imageUrlController.text.trim(),
        userBioController.text.trim(),
      );
      await loadUserData();
      if (mounted) {
        showRightSnackbar(
          context,
          'Profile updated successfully',
          isError: false,
        );
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
        showRightSnackbar(
          context,
          'Please fill in all password fields',
          isError: true,
        );
      }
      return;
    }

    if (newPass != confirmPass) {
      if (mounted) {
        showRightSnackbar(
          context,
          'New password and confirmation do not match',
          isError: true,
        );
      }
      return;
    }

    try {
      await ApiService.updateUserPassword(userId!, currentPass, newPass);

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      await loadUserData();

      if (mounted) {
        showRightSnackbar(
          context,
          'Password updated successfully',
          isError: false,
        );
      }
    } catch (e) {
      if (mounted) {
        showRightSnackbar(
          context,
          'Failed to update password: $e',
          isError: true,
        );
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
      // Mobile Layout
      return Column(
        children: [
          buildLeftCard(context),
          const SizedBox(height: 20),
          buildNoteCard(), // User Bio Card
          const SizedBox(height: 20),
          buildRightCard(context),
        ],
      );
    } else {
      // Desktop Layout
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT COLUMN (1/3 of the space)
          Expanded(
            flex: 1,
            child: Column(
              children: [
                buildLeftCard(context),
                const SizedBox(height: 20),
                buildNoteCard(),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // RIGHT COLUMN (2/3 of the space)
          Expanded(flex: 2, child: buildRightCard(context)),
        ],
      );
    }
  }

  // --- UI COMPONENTS ---

  Widget buildLeftCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
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
              backgroundImage: NetworkImage(
                (currentUser?.profileImageUrl != null &&
                        currentUser!.profileImageUrl!.isNotEmpty)
                    ? currentUser!.profileImageUrl!
                    : 'https://cdn.tourradar.com/s3/traveller/original/383701_3BCgWfah.jpg', // Default if empty
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () => showImageUrlDialog(context),
              icon: const Icon(Icons.add_a_photo, size: 18),
              label: const Text("Change Photo via URL"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              currentUser?.username ?? usernameController.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Divider(),

            Text('Member Since: ${formatDate(currentUser?.createdAt)}'),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildNoteCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "About Me",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.blue, size: 20),
                  onPressed: () =>
                      saveProfileChanges(), // Reusing your save function
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller:
                  userBioController, // Add this controller at the top of your class
              maxLines: 4,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tell us something about yourself...",
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
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

        const SizedBox(height: 20),

        buildSectionCard(
          title: "Recent Activity",
          subtitle: Text(
            "Showing ${activities.length} recent updates, scroll to see all updates",
          ), // Change subtitle to be clear
          child: activities.isEmpty
              ? const Text("No recent activity found.")
              : SizedBox(
                  height:
                      200, // Reduced height to FORCE scrolling even with fewer items
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      // PHYSICS: This helps with scrolling feel on different platforms
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: activities.asMap().entries.map((entry) {
                          // Removed .take(4)
                          int index = entry.key;
                          ActivityModel activity = entry.value;
                          var details = _getActivityDetails(
                            activity.activityType,
                          );

                          return Column(
                            children: [
                              buildActivityRow(
                                icon: details['icon'],
                                color: details['color'],
                                title: activity.activityType.toUpperCase(),
                                time: formatDate(activity.createdAt),
                              ),
                              // Only hide divider for the ABSOLUTE last item
                              if (index != activities.length - 1)
                                buildDivider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
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

        const SizedBox(height: 16),

        TextField(
          controller: imageUrlController,
          decoration: const InputDecoration(
            labelText: 'Profile Image URL',
            hintText: 'Paste a link to an image (https://...)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [Text("Don't worry, we won't show your password here!")],
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

  Widget buildActivityRow({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 44,
      ), // Aligns with the text, not the icon
      child: Divider(height: 24, thickness: 0.5, color: Colors.grey.shade200),
    );
  }

  String formatDate(String? date) {
    if (date == null || date == 'N/A') return 'N/A';

    // .toLocal() to convert UTC from DB to your device time
    final dt = DateTime.tryParse(date)?.toLocal() ?? DateTime.now();

    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
  }
}
