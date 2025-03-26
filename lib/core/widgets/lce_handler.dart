import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';

class LceHandler<T> extends StatelessWidget {
  final BaseState<T> state;
  final Widget Function(T data) contentBuilder;
  final Widget? loadingWidget;
  final Widget Function(String message)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final VoidCallback? onRetry;

  const LceHandler({
    Key? key,
    required this.state,
    required this.contentBuilder,
    this.loadingWidget,
    this.errorBuilder,
    this.emptyBuilder,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      LoadingState<T>() => loadingWidget ?? const Center(
          child: CircularProgressIndicator(),
        ),
      ContentState<T>(data: final data) => _buildContentOrEmpty(data),
      ErrorState<T>(failure: final failure) => errorBuilder != null
          ? errorBuilder!(failure.message)
          : Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      failure.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: FilledButton(
                          onPressed: onRetry,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'RETRY',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    };
  }

  Widget _buildContentOrEmpty(T data) {
    if (data is List && (data as List).isEmpty) {
      return emptyBuilder != null
          ? emptyBuilder!()
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      color: Colors.grey,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No items found',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
    }
    return contentBuilder(data);
  }
} 