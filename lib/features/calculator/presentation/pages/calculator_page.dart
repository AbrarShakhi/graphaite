import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expression_list/expression_list_bloc.dart';
import '../bloc/expression_list/expression_list_state.dart';
import '../bloc/graph/graph_bloc.dart';
import '../bloc/graph/graph_event.dart';
import '../widgets/expression_panel/expression_panel.dart';
import '../widgets/expression_panel/mobile_expression_sheet.dart';
import '../widgets/graph_panel/graph_panel.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpressionListBloc, ExpressionListState>(
      listener: (context, state) {
        context
            .read<GraphBloc>()
            .add(UpdateExpressionsEvent(state.expressions));
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth > 640
                ? const _DesktopLayout()
                : const _MobileLayout();
          },
        ),
      ),
    );
  }
}

// ── Desktop layout ────────────────────────────────────────────────────────────

class _DesktopLayout extends StatefulWidget {
  const _DesktopLayout();

  @override
  State<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<_DesktopLayout> {
  double _panelWidth = 340;
  bool _panelVisible = true;
  static const _minWidth = 220.0;
  static const _maxWidth = 540.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        if (_panelVisible) ...[
          SizedBox(
            width: _panelWidth,
            child: ExpressionPanel(
              onCollapse: () => setState(() => _panelVisible = false),
            ),
          ),
          _ResizeDivider(
            isDark: isDark,
            onDragUpdate: (delta) => setState(() {
              _panelWidth = (_panelWidth + delta).clamp(_minWidth, _maxWidth);
            }),
          ),
        ] else
          _CollapsedStrip(
            isDark: isDark,
            onExpand: () => setState(() => _panelVisible = true),
          ),
        const Expanded(child: GraphPanel()),
      ],
    );
  }
}

class _ResizeDivider extends StatefulWidget {
  const _ResizeDivider({required this.isDark, required this.onDragUpdate});
  final bool isDark;
  final ValueChanged<double> onDragUpdate;

  @override
  State<_ResizeDivider> createState() => _ResizeDividerState();
}

class _ResizeDividerState extends State<_ResizeDivider> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final lineColor = _hovered
        ? (widget.isDark ? const Color(0xFF7C6AF5) : const Color(0xFF2D6ACC))
        : (widget.isDark ? const Color(0xFF252530) : const Color(0xFFE0E0E0));
    final dotColor = _hovered
        ? Colors.white.withValues(alpha: 0.7)
        : (widget.isDark ? const Color(0xFF3A3A5C) : const Color(0xFFCCCCCC));

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onHorizontalDragUpdate: (d) => widget.onDragUpdate(d.delta.dx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 6,
          color: lineColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (_) => Container(
                  width: 2,
                  height: 2,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedStrip extends StatelessWidget {
  const _CollapsedStrip({required this.isDark, required this.onExpand});
  final bool isDark;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF111118) : const Color(0xFFF8F8F8);
    final border =
        isDark ? const Color(0xFF252530) : const Color(0xFFE0E0E0);
    final iconColor =
        isDark ? const Color(0xFF55558A) : const Color(0xFFAAAAAA);

    return Material(
      color: bg,
      child: Tooltip(
        message: 'Show expressions',
        child: InkWell(
          onTap: onExpand,
          child: SizedBox(
            width: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: border)),
              ),
              child: Center(
                child: Icon(Icons.chevron_right, size: 20, color: iconColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatefulWidget {
  const _MobileLayout();

  @override
  State<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<_MobileLayout> {
  late final DraggableScrollableController _sheetController;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _minimize() => _sheetController.animateTo(
        0.08,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: GraphPanel()),
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.35,
          minChildSize: 0.08,
          maxChildSize: 0.88,
          snap: true,
          snapSizes: const [0.08, 0.35, 0.88],
          builder: (context, scrollController) => MobileExpressionSheet(
            scrollController: scrollController,
            onMinimize: _minimize,
          ),
        ),
      ],
    );
  }
}
