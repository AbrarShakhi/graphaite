import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../main.dart';
import '../../bloc/expression_list/expression_list_bloc.dart';
import '../../bloc/expression_list/expression_list_event.dart';
import '../../bloc/expression_list/expression_list_state.dart';
import 'expression_item_widget.dart';

/// Bottom-sheet version of the expression panel for narrow/mobile screens.
/// Must be placed inside a [DraggableScrollableSheet] builder so it receives
/// the sheet's [scrollController].
class MobileExpressionSheet extends StatelessWidget {
  const MobileExpressionSheet({
    super.key,
    required this.scrollController,
    this.onMinimize,
  });

  final ScrollController scrollController;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF111118) : Colors.white;
    final dividerColor =
        isDark ? const Color(0xFF252530) : const Color(0xFFEEEEEE);

    return Material(
      color: bgColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      elevation: 24,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.8 : 0.25),
      child: Column(
        children: [
          // ── Drag handle ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF3A3A5A)
                    : const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ──────────────────────────────────────────────────────
          _SheetHeader(isDark: isDark, onMinimize: onMinimize),

          Container(height: 1, color: dividerColor),

          // ── Expression list (scrollable) ────────────────────────────────
          Expanded(
            child: BlocBuilder<ExpressionListBloc, ExpressionListState>(
              builder: (context, state) {
                if (state.expressions.isEmpty) {
                  return _EmptyState(
                    scrollController: scrollController,
                    isDark: isDark,
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: state.expressions.length,
                  itemBuilder: (context, index) {
                    final expr = state.expressions[index];
                    return ExpressionItemWidget(
                      key: ValueKey(expr.id),
                      expression: expr,
                      autoFocus: expr.id == state.focusedId,
                      isDark: isDark,
                    );
                  },
                );
              },
            ),
          ),

          // ── Add button (always visible at bottom) ───────────────────────
          _AddButton(isDark: isDark),

          // Safe area bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// ── Sheet header ──────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.isDark, this.onMinimize});
  final bool isDark;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpressionListBloc, ExpressionListState>(
      buildWhen: (a, b) => a.expressions.length != b.expressions.length,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.functions,
                size: 18,
                color: isDark
                    ? const Color(0xFF7C6AF5)
                    : const Color(0xFF2D6ACC),
              ),
              const SizedBox(width: 8),
              Text(
                'Expressions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFD0D0EE)
                      : const Color(0xFF1A1A1A),
                  letterSpacing: 0.3,
                ),
              ),
              if (state.expressions.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2A2A44)
                        : const Color(0xFFE8EEF8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${state.expressions.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF9090CC)
                          : const Color(0xFF2D6ACC),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Theme toggle
              Tooltip(
                message: isDark ? 'Light mode' : 'Dark mode',
                child: InkWell(
                  onTap: () => GraphaiteApp.of(context).toggleTheme(),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: 18,
                      color: isDark
                          ? const Color(0xFF7070AA)
                          : const Color(0xFF888888),
                    ),
                  ),
                ),
              ),
              if (onMinimize != null) ...[
                const SizedBox(width: 2),
                Tooltip(
                  message: 'Hide',
                  child: InkWell(
                    onTap: onMinimize,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: isDark
                            ? const Color(0xFF7070AA)
                            : const Color(0xFF888888),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.scrollController,
    required this.isDark,
  });

  final ScrollController scrollController;
  final bool isDark;

  static const _suggestions = [
    ('sin(x)', 'Sine'),
    ('x^2', 'Parabola'),
    ('cos(x)', 'Cosine'),
    ('sqrt(x)', '√x'),
    ('x^3 - x', 'Cubic'),
    ('1/x', 'Hyperbola'),
  ];

  @override
  Widget build(BuildContext context) {
    final dimColor =
        isDark ? const Color(0xFF55558A) : const Color(0xFFAAAAAA);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      children: [
        Text(
          'Start graphing',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark
                ? const Color(0xFFD0D0EE)
                : const Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap a suggestion or type below.',
          style: TextStyle(fontSize: 12, color: dimColor),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions
              .map((s) => _SuggestionChip(
                    equation: s.$1,
                    label: s.$2,
                    isDark: isDark,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.equation,
    required this.label,
    required this.isDark,
  });

  final String equation;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            equation,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? const Color(0xFF7C9FFF)
                  : const Color(0xFF2D6ACC),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark
                  ? const Color(0xFF55558A)
                  : const Color(0xFF999999),
            ),
          ),
        ],
      ),
      backgroundColor:
          isDark ? const Color(0xFF18182A) : const Color(0xFFF0F4FF),
      side: BorderSide(
        color: isDark
            ? const Color(0xFF2A2A44)
            : const Color(0xFFCCDAF5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      onPressed: () => context
          .read<ExpressionListBloc>()
          .add(AddExpressionWithEquationEvent(equation)),
    );
  }
}

// ── Add button ────────────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  const _AddButton({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF18182A) : const Color(0xFFFAFAFA);
    final borderColor =
        isDark ? const Color(0xFF252530) : const Color(0xFFEEEEEE);

    return Material(
      color: bgColor,
      child: InkWell(
        onTap: () => context
            .read<ExpressionListBloc>()
            .add(const AddExpressionEvent()),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor)),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2A44)
                      : const Color(0xFFE8EEF8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 15,
                  color: isDark
                      ? const Color(0xFF9090CC)
                      : const Color(0xFF2D6ACC),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Add expression',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFF7070AA)
                      : const Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
