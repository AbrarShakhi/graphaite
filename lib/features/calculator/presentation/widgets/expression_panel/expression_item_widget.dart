import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/expression_list/expression_list_bloc.dart';
import '../../bloc/expression_list/expression_list_event.dart';
import '../../../domain/entities/expression_entity.dart';
import 'color_picker_widget.dart';

class ExpressionItemWidget extends StatefulWidget {
  const ExpressionItemWidget({
    super.key,
    required this.expression,
    required this.autoFocus,
    required this.isDark,
  });

  final ExpressionEntity expression;
  final bool autoFocus;
  final bool isDark;

  @override
  State<ExpressionItemWidget> createState() => _ExpressionItemWidgetState();
}

class _ExpressionItemWidgetState extends State<ExpressionItemWidget>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _enterAnim;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.expression.equation);
    _focusNode = FocusNode()..addListener(() => setState(() {}));

    // Entry animation
    _enterAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _opacity = CurvedAnimation(
      parent: _enterAnim,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(-0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterAnim, curve: Curves.easeOutCubic));

    _enterAnim.forward();

    if (widget.autoFocus) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void didUpdateWidget(ExpressionItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expression.id != widget.expression.id) {
      _controller.text = widget.expression.equation;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _enterAnim.dispose();
    super.dispose();
  }

  void _onChanged(String value) => context
      .read<ExpressionListBloc>()
      .add(UpdateExpressionEquationEvent(widget.expression.id, value));

  void _onDelete() => context
      .read<ExpressionListBloc>()
      .add(RemoveExpressionEvent(widget.expression.id));

  void _onToggleVisibility() => context
      .read<ExpressionListBloc>()
      .add(ToggleExpressionVisibilityEvent(widget.expression.id));

  void _onColorTap() => showColorPicker(
        context: context,
        current: widget.expression.color,
        isDark: widget.isDark,
        onSelected: (color) => context.read<ExpressionListBloc>().add(
              ChangeExpressionColorEvent(widget.expression.id, color),
            ),
      );

  @override
  Widget build(BuildContext context) {
    final expr = widget.expression;
    final mColor = Color(expr.color.toARGB32());
    final isDark = widget.isDark;
    final showActions = _hovered || _focusNode.hasFocus;

    // Theme-aware colors
    final bgColor = isDark ? const Color(0xFF18181F) : Colors.white;
    final hoverColor =
        isDark ? const Color(0xFF1E1E2A) : const Color(0xFFF5F7FF);
    final borderColor =
        isDark ? const Color(0xFF252530) : const Color(0xFFEEEEEE);
    final textColor = isDark ? const Color(0xFFE0E0EE) : const Color(0xFF1A1A1A);
    final hintColor = isDark ? const Color(0xFF44446A) : const Color(0xFFBBBBBB);
    final errorColor =
        isDark ? const Color(0xFFFF6B6B) : Colors.red.shade600;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: showActions ? hoverColor : bgColor,
              border: Border(
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Color bar
                  GestureDetector(
                    onTap: _onColorTap,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: showActions ? 6 : 4,
                        color: mColor,
                      ),
                    ),
                  ),
                  // Color swatch
                  GestureDetector(
                    onTap: _onColorTap,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: showActions ? 22 : 18,
                            height: showActions ? 22 : 18,
                            decoration: BoxDecoration(
                              color: expr.isVisible
                                  ? mColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: mColor,
                                width: 2.5,
                              ),
                              boxShadow: showActions && isDark
                                  ? [
                                      BoxShadow(
                                        color: mColor.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Equation input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: _onChanged,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: expr.hasError ? errorColor : textColor,
                        fontFamily: 'monospace',
                        letterSpacing: 0.4,
                      ),
                      decoration: InputDecoration(
                        hintText: 'y = ...',
                        hintStyle: TextStyle(
                          color: hintColor,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        suffixIcon: expr.hasError
                            ? Tooltip(
                                message: 'Invalid expression',
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.error_outline,
                                    color: errorColor.withValues(alpha: 0.8),
                                    size: 16,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  // Hover actions
                  if (showActions) ...[
                    _IconBtn(
                      icon: expr.isVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: expr.isVisible
                          ? (isDark
                              ? const Color(0xFF7070AA)
                              : Colors.grey.shade600)
                          : (isDark
                              ? const Color(0xFF404060)
                              : Colors.grey.shade400),
                      tooltip: expr.isVisible ? 'Hide' : 'Show',
                      onTap: _onToggleVisibility,
                    ),
                    _IconBtn(
                      icon: Icons.close,
                      color: isDark
                          ? const Color(0xFF6060A0)
                          : Colors.grey.shade500,
                      tooltip: 'Delete',
                      onTap: _onDelete,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }
}
