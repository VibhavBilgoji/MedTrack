import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Family Account')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Household info card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.home_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text('My Household', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('You are the Owner', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showInviteDialog(context),
                  icon: const Icon(Icons.person_add_rounded, size: 18),
                  label: const Text('Invite a Member'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          Text('Members', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ..._mockMembers.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MemberCard(member: entry.value, isDark: isDark)
                .animate().fadeIn(delay: (entry.key * 80).ms),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Role Permissions', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                const _RoleRow(role: 'Owner', permissions: 'Full access: add, edit, delete, invite', color: AppColors.primary),
                const Divider(height: 16),
                const _RoleRow(role: 'Member', permissions: 'Add & edit medicines, view reports', color: AppColors.safe),
                const Divider(height: 16),
                const _RoleRow(role: 'Viewer', permissions: 'Read-only access to medicine list', color: AppColors.warning),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invite Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the email address of the person you want to invite.'),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email address', prefixIcon: Icon(Icons.email_outlined)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ctx.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invite sent to ${ctrl.text}'), backgroundColor: AppColors.safe),
              );
            },
            child: const Text('Send Invite'),
          ),
        ],
      ),
    );
  }

  static const _mockMembers = [
    _Member(name: 'You (Owner)', email: 'you@example.com', role: 'Owner', avatarLetter: 'Y', color: AppColors.primary),
    _Member(name: 'Mom', email: 'mom@example.com', role: 'Member', avatarLetter: 'M', color: AppColors.safe),
    _Member(name: 'Dad', email: 'dad@example.com', role: 'Viewer', avatarLetter: 'D', color: AppColors.warning),
  ];
}

class _Member {
  final String name, email, role, avatarLetter;
  final Color color;
  const _Member({required this.name, required this.email, required this.role, required this.avatarLetter, required this.color});
}

class _MemberCard extends StatelessWidget {
  final _Member member;
  final bool isDark;
  const _MemberCard({required this.member, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: member.color.withValues(alpha: 0.15),
          child: Text(member.avatarLetter, style: TextStyle(color: member.color, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(member.email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: member.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Text(member.role, style: TextStyle(color: member.color, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

class _RoleRow extends StatelessWidget {
  final String role, permissions;
  final Color color;
  const _RoleRow({required this.role, required this.permissions, required this.color});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 64,
        child: Text(role, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(permissions, style: const TextStyle(fontSize: 13, height: 1.4))),
    ],
  );
}
