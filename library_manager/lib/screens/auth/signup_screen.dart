import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      if (name.isEmpty) {
        _nameError = 'Full name is required';
        valid = false;
      } else if (name.length < 2) {
        _nameError = 'Name must be at least 2 characters';
        valid = false;
      } else {
        _nameError = null;
      }

      if (email.isEmpty) {
        _emailError = 'Email is required';
        valid = false;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _emailError = 'Enter a valid email address';
        valid = false;
      } else {
        _emailError = null;
      }

      if (password.isEmpty) {
        _passwordError = 'Password is required';
        valid = false;
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        valid = false;
      } else {
        _passwordError = null;
      }
    });

    return valid;
  }

  Future<void> _submit() async {
    context.read<AuthProvider>().clearError();
    if (!_validate()) return;

    await context.read<AuthProvider>().signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 52),

              // ── Branding ─────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        LucideIcons.bookOpen,
                        size: 28,
                        color: colorScheme.primaryForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Create account',
                      style: theme.textTheme.h2.copyWith(
                        color: colorScheme.foreground,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Join LibraryOS and start reading',
                      style: theme.textTheme.muted.copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ── Full Name ─────────────────────────────────────
              _FieldLabel(label: 'Full name', theme: theme, colorScheme: colorScheme),
              const SizedBox(height: 6),
              ShadInput(
                controller: _nameController,
                placeholder: const Text('Jane Doe'),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
              ),
              if (_nameError != null) _ErrorText(message: _nameError!),

              const SizedBox(height: 16),

              // ── Email ─────────────────────────────────────────
              _FieldLabel(label: 'Email address', theme: theme, colorScheme: colorScheme),
              const SizedBox(height: 6),
              ShadInput(
                controller: _emailController,
                placeholder: const Text('you@example.com'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              if (_emailError != null) _ErrorText(message: _emailError!),

              const SizedBox(height: 16),

              // ── Password ──────────────────────────────────────
              _FieldLabel(label: 'Password', theme: theme, colorScheme: colorScheme),
              const SizedBox(height: 6),
              ShadInput(
                controller: _passwordController,
                placeholder: const Text('Min. 6 characters'),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                trailing: GestureDetector(
                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                      size: 16,
                      color: colorScheme.mutedForeground,
                    ),
                  ),
                ),
              ),
              if (_passwordError != null) _ErrorText(message: _passwordError!),

              const SizedBox(height: 24),

              // ── Firebase error banner ─────────────────────────
              Consumer<AuthProvider>(
                builder: (ctx, auth, _) {
                  if (auth.errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.circleAlert,
                              size: 15,
                              color: Colors.red[700],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                auth.errorMessage!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // ── Create account button ─────────────────────────
              Consumer<AuthProvider>(
                builder: (ctx, auth, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ShadButton(
                      onPressed: auth.isLoading ? null : _submit,
                      child: auth.isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primaryForeground,
                              ),
                            )
                          : const Text('Create account'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ── Role info hint ────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 14,
                      color: colorScheme.mutedForeground,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'New accounts are created as Patron. Contact admin for role upgrades.',
                        style: theme.textTheme.muted.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Divider ───────────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: colorScheme.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: theme.textTheme.muted.copyWith(fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider(color: colorScheme.border)),
                ],
              ),

              const SizedBox(height: 24),

              // ── Link to login ─────────────────────────────────
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.muted.copyWith(fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<AuthProvider>().clearError();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign in',
                        style: theme.textTheme.small.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared form sub-widgets ───────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    required this.theme,
    required this.colorScheme,
  });

  final String label;
  final ShadThemeData theme;
  final ShadColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: theme.textTheme.small.copyWith(
        color: colorScheme.foreground,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: Colors.red),
      ),
    );
  }
}
