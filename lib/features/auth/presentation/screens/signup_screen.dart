import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:playerpath/app/theme/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  String _userType = 'player';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/login'),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Create your account', style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text("Join the UK's #1 grassroots football recruitment platform", style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 32),

                  // User type
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _userType = 'player'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _userType == 'player' ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: _userType == 'player' ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                              ),
                              child: Center(
                                child: Text('Player', style: TextStyle(fontWeight: FontWeight.w700, color: _userType == 'player' ? Colors.white : AppColors.textSecondary)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _userType = 'club'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _userType == 'club' ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: _userType == 'club' ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                              ),
                              child: Center(
                                child: Text('Club', style: TextStyle(fontWeight: FontWeight.w700, color: _userType == 'club' ? Colors.white : AppColors.textSecondary)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => v == null || v.isEmpty ? 'Name is required' : (v.length < 2 ? 'Minimum 2 characters' : null),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (v) => v == null || v.isEmpty ? 'Email is required' : (!v.contains('@') ? 'Enter a valid email' : null),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Password is required' : (v.length < 8 ? 'Minimum 8 characters' : null),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordCtrl,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outlined)),
                    validator: (v) => v != _passwordCtrl.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 32),

                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthAuthenticated) context.go('/home');
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
                      }
                    },
                    builder: (context, state) {
                      return PrimaryButton(
                        label: 'Create Account',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signup(_emailCtrl.text.trim(), _passwordCtrl.text, _userType, _nameCtrl.text.trim());
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('By signing up, you agree to our Terms of Service and Privacy Policy.', textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ', style: theme.textTheme.bodyMedium),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text('Sign In', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
