import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/bloc/base_state.dart';

class LceHandler<T> extends StatelessWidget {
  final BaseState<T> state;
  final Widget Function(T data) contentBuilder;
  final Widget? loadingWidget;
  final Widget Function(String message)? errorBuilder;
  final Widget Function()? emptyBuilder;

  const LceHandler({
    Key? key,
    required this.state,
    required this.contentBuilder,
    this.loadingWidget,
    this.errorBuilder,
    this.emptyBuilder,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${failure.message}',
                      textAlign: TextAlign.center,
                    ),
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