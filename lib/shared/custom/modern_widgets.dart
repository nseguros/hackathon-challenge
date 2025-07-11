import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModernTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final bool isEnabled;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final String? placeholder;
  final String? helperText;
  final IconData? icon;
  final String? suffix;
  final TextCapitalization textCapitalization;

  const ModernTextField({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.suffixIcon,
    this.placeholder,
    this.helperText,
    this.icon,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isFocused
                    ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                enabled: widget.isEnabled,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                textCapitalization: widget.textCapitalization,


                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                onTap: () {
                  setState(() => _isFocused = true);
                  _animationController.forward();
                },
                onEditingComplete: () {
                  setState(() => _isFocused = false);
                  _animationController.reverse();
                },
                onTapOutside: (_) {
                  setState(() => _isFocused = false);
                  _animationController.reverse();
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  prefixIcon: widget.icon != null
                      ? Container(
                    margin: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      widget.icon,
                      color: _isFocused
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                      size: 20,
                    ),
                  )
                      : null,
                  suffixIcon: widget.suffix != null
                      ? Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        widget.suffix!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                      : widget.suffixIcon,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? theme.colorScheme.error.withOpacity(0.5)
                          : theme.colorScheme.outline.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: widget.isEnabled
                      ? (_isFocused
                      ? theme.colorScheme.primary.withOpacity(0.02)
                      : theme.colorScheme.surface)
                      : theme.colorScheme.onSurface.withOpacity(0.05),
                  hintText: widget.placeholder,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.errorText!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.helperText != null && widget.errorText == null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                widget.helperText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ModernDropdown<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? errorText;
  final bool isEnabled;
  final IconData? icon;

  const ModernDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.isEnabled = true,
    this.icon,
  });

  @override
  State<ModernDropdown<T>> createState() => _ModernDropdownState<T>();
}

class _ModernDropdownState<T> extends State<ModernDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isFocused
                    ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.errorText != null
                        ? theme.colorScheme.error.withOpacity(0.5)
                        : (_isFocused
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.3)),
                    width: _isFocused ? 2 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: widget.isEnabled
                      ? (_isFocused
                      ? theme.colorScheme.primary.withOpacity(0.02)
                      : theme.colorScheme.surface)
                      : theme.colorScheme.onSurface.withOpacity(0.05),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    isExpanded: true,
                    value: widget.value,
                    items: widget.items,
                    onChanged: widget.isEnabled ? widget.onChanged : null,
                    onTap: () {
                      setState(() => _isFocused = true);
                      _animationController.forward();
                    },
                    icon: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _isFocused
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                        size: 24,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    dropdownColor: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    padding: EdgeInsets.only(
                      left: widget.icon != null ? 12 : 16,
                      right: 8,
                      top: 16,
                      bottom: 16,
                    ),
                    hint: widget.icon != null
                        ? Row(
                      children: [
                        Icon(
                          widget.icon,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Selecionar...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    )
                        : Text(
                      'Selecionar...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    selectedItemBuilder: (context) {
                      return widget.items.map((item) {
                        return Row(
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(child: item.child),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.errorText!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ModernDatePicker extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime) onDateSelected;
  final String? errorText;
  final IconData? icon;

  const ModernDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
    this.errorText,
    this.icon,
  });

  @override
  State<ModernDatePicker> createState() => _ModernDatePickerState();
}

class _ModernDatePickerState extends State<ModernDatePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayDate = widget.selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(widget.selectedDate!)
        : 'Selecionar data';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _animationController.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: widget.selectedDate ?? DateTime.now(),
                  firstDate: widget.firstDate ?? DateTime(1990),
                  lastDate: widget.lastDate ?? DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: theme.colorScheme.copyWith(
                          primary: theme.colorScheme.primary,
                          onPrimary: theme.colorScheme.onPrimary,
                          surface: theme.colorScheme.surface,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  widget.onDateSelected(picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.errorText != null
                        ? theme.colorScheme.error.withOpacity(0.5)
                        : (_isPressed
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.3)),
                    width: _isPressed ? 2 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _isPressed
                      ? theme.colorScheme.primary.withOpacity(0.02)
                      : theme.colorScheme.surface,
                  boxShadow: _isPressed
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: _isPressed
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        displayDate,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: widget.selectedDate != null
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: _isPressed
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.errorText!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isSelected;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? theme.colorScheme.surface,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              border: widget.isSelected
                  ? Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected
                      ? theme.colorScheme.primary.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _elevationAnimation.value,
                  offset: Offset(0, _elevationAnimation.value / 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: widget.onTap != null ? (_) {
                  setState(() => _isPressed = true);
                  _animationController.forward();
                } : null,
                onTapUp: widget.onTap != null ? (_) {
                  setState(() => _isPressed = false);
                  _animationController.reverse();
                } : null,
                onTapCancel: widget.onTap != null ? () {
                  setState(() => _isPressed = false);
                  _animationController.reverse();
                } : null,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ModernProgressIndicator extends StatelessWidget {
  final double progress;
  final String? label;
  final Color? color;
  final double height;

  const ModernProgressIndicator({
    super.key,
    required this.progress,
    this.label,
    this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color ?? theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: (color ?? theme.colorScheme.primary).withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.colorScheme.primary,
              ),
              minHeight: height,
            ),
          ),
        ),
      ],
    );
  }
}

class ModernChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? selectedColor;

  const ModernChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? theme.colorScheme.primary)
              : (backgroundColor ?? theme.colorScheme.surface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? theme.colorScheme.primary)
                : theme.colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: (selectedColor ?? theme.colorScheme.primary).withOpacity(
                  0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

