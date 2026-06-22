import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../main.dart';
import '../../bloc/expression_list/expression_list_bloc.dart';
import '../../bloc/expression_list/expression_list_event.dart';
import '../../bloc/expression_list/expression_list_state.dart';
import 'expression_item_widget.dart';

class ExpressionPanel extends StatelessWidget {
  const ExpressionPanel({super.key, this.onCollapse});
  final VoidCallback? onCollapse;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Material is required as a direct ancestor of ExpansionTile/InkWell so
    // ink splashes paint correctly above our background color.
    return Material(
      color: isDark ? const Color(0xFF111118) : const Color(0xFFF8F8F8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: isDark
                  ? const Color(0xFF252530)
                  : const Color(0xFFE0E0E0),
            ),
          ),
        ),
        child: Column(
          children: [
            _PanelHeader(isDark: isDark, onCollapse: onCollapse),
            Expanded(
              child: BlocBuilder<ExpressionListBloc, ExpressionListState>(
                builder: (context, state) {
                  if (state.expressions.isEmpty) {
                    return _EmptyState(isDark: isDark);
                  }
                  return ListView.builder(
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
            _AddButton(isDark: isDark),
            _FunctionReference(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.isDark, this.onCollapse});
  final bool isDark;
  final VoidCallback? onCollapse;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpressionListBloc, ExpressionListState>(
      buildWhen: (a, b) => a.expressions.length != b.expressions.length,
      builder: (context, state) {
        return Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1A1A32), const Color(0xFF0F0F1E)]
                  : [const Color(0xFF1E5BAD), const Color(0xFF2D6ACC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0xFF7C6AF5).withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Logo + title
              const Icon(Icons.functions, color: Colors.white, size: 20),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Graphaite',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              // Expression count badge
              if (state.expressions.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${state.expressions.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 6),
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
                      color: Colors.white.withValues(alpha: 0.85),
                      size: 17,
                    ),
                  ),
                ),
              ),
              if (onCollapse != null) ...[
                const SizedBox(width: 2),
                Tooltip(
                  message: 'Hide panel',
                  child: InkWell(
                    onTap: onCollapse,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 17,
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
  const _EmptyState({required this.isDark});
  final bool isDark;

  static const _suggestions = [
    ('sin(x)', 'Sine wave'),
    ('x^2', 'Parabola'),
    ('cos(x)', 'Cosine'),
    ('sqrt(x)', 'Square root'),
    ('x^3 - x', 'Cubic'),
    ('1/x', 'Hyperbola'),
  ];

  @override
  Widget build(BuildContext context) {
    final dimColor = isDark
        ? const Color(0xFF55558A)
        : const Color(0xFFAAAAAA);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.show_chart_rounded,
            size: 44,
            color: isDark
                ? const Color(0xFF3A3A60)
                : const Color(0xFFCCCCCC),
          ),
          const SizedBox(height: 18),
          Text(
            'Start graphing',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? const Color(0xFFD0D0EE)
                  : const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Type any equation or tap a suggestion below.',
            style: TextStyle(fontSize: 12.5, color: dimColor, height: 1.5),
          ),
          const SizedBox(height: 22),
          Text(
            'QUICK START',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark
                  ? const Color(0xFF44446A)
                  : const Color(0xFFBBBBBB),
            ),
          ),
          const SizedBox(height: 10),
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
      ),
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
    final bgColor = isDark ? const Color(0xFF18182A) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF252530) : const Color(0xFFE8E8E8);
    return Material(
      color: bgColor,
      child: InkWell(
        onTap: () => context
            .read<ExpressionListBloc>()
            .add(const AddExpressionEvent()),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: borderColor),
              bottom: BorderSide(color: borderColor),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2A44)
                      : const Color(0xFFE8EEF8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF9090CC)
                      : const Color(0xFF2D6ACC),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Add expression',
                style: TextStyle(
                  fontSize: 13.5,
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

// ── Function reference ────────────────────────────────────────────────────────

class _FunctionReference extends StatelessWidget {
  const _FunctionReference({required this.isDark});
  final bool isDark;

  static const _functions = [
    ('sin(x)', 'Sine'),
    ('cos(x)', 'Cosine'),
    ('tan(x)', 'Tangent'),
    ('sqrt(x)', 'Square root'),
    ('abs(x)', 'Absolute value'),
    ('log(x)', 'Natural log (ln)'),
    ('x^n', 'Power'),
    ('pi', 'π constant'),
    ('e', 'Euler\'s number'),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          'Functions & constants',
          style: TextStyle(
            fontSize: 11.5,
            color: isDark
                ? const Color(0xFF55558A)
                : const Color(0xFFAAAAAA),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        iconColor:
            isDark ? const Color(0xFF55558A) : const Color(0xFFAAAAAA),
        collapsedIconColor:
            isDark ? const Color(0xFF55558A) : const Color(0xFFAAAAAA),
        children: _functions
            .map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      f.$1,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF7C9FFF)
                            : const Color(0xFF2D6ACC),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '— ${f.$2}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark
                            ? const Color(0xFF55558A)
                            : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
