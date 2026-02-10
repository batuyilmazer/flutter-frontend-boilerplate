/// Spacing scheme containing all spacing tokens used in the app.
///
/// Provides consistent spacing values for padding, margins, and gaps.
/// Built on a 4px base-unit grid with useful intermediate stops.
class AppSpacingScheme {
  const AppSpacingScheme({
    // Primitive spacing tokens
    required this.s0,
    required this.s2,
    required this.s4,
    required this.s6,
    required this.s8,
    required this.s12,
    required this.s16,
    required this.s20,
    required this.s24,
    required this.s32,
    required this.s40,
    required this.s48,
    required this.s64,

    // Semantic / component-level spacing tokens
    required this.buttonPaddingX,
    required this.buttonPaddingY,
    required this.buttonIconGap,
    required this.inputPaddingX,
    required this.inputPaddingY,
    required this.inputLabelGap,
    required this.cardPadding,
    required this.cardGap,
    required this.dialogPadding,
    required this.dialogActionsGap,
    required this.sheetPadding,
    required this.toastMargin,
    required this.toastPaddingX,
    required this.toastPaddingY,
    required this.badgePaddingX,
    required this.badgePaddingY,
    required this.chipPaddingX,
    required this.chipPaddingY,
    required this.sectionGapSm,
    required this.sectionGapMd,
    required this.sectionGapLg,
  });

  /// No spacing (0px)
  final double s0;

  /// Tiny spacing (2px)
  final double s2;

  /// Extra small spacing (4px)
  final double s4;

  /// Small-extra spacing (6px)
  final double s6;

  /// Small spacing (8px)
  final double s8;

  /// Medium-small spacing (12px)
  final double s12;

  /// Medium spacing (16px)
  final double s16;

  /// Medium-large spacing (20px)
  final double s20;

  /// Large spacing (24px)
  final double s24;

  /// Extra large spacing (32px)
  final double s32;

  /// 2x large spacing (40px)
  final double s40;

  /// 3x large spacing (48px)
  final double s48;

  /// 4x large spacing (64px)
  final double s64;

  // --- Semantic / component-level spacing tokens ---

  /// Default button horizontal padding.
  final double buttonPaddingX;

  /// Default button vertical padding.
  final double buttonPaddingY;

  /// Default spacing between a button icon and label.
  final double buttonIconGap;

  /// Default input horizontal padding.
  final double inputPaddingX;

  /// Default input vertical padding.
  final double inputPaddingY;

  /// Default vertical gap between input label and field.
  final double inputLabelGap;

  /// Default card content padding (when the component supports it).
  final double cardPadding;

  /// Default vertical gap used inside cards.
  final double cardGap;

  /// Default dialog padding.
  final double dialogPadding;

  /// Default gap between dialog action buttons.
  final double dialogActionsGap;

  /// Default bottom sheet padding.
  final double sheetPadding;

  /// Default toast/snackbar outer margin.
  final double toastMargin;

  /// Default toast/snackbar horizontal padding.
  final double toastPaddingX;

  /// Default toast/snackbar vertical padding.
  final double toastPaddingY;

  /// Default badge horizontal padding.
  final double badgePaddingX;

  /// Default badge vertical padding.
  final double badgePaddingY;

  /// Default chip horizontal padding.
  final double chipPaddingX;

  /// Default chip vertical padding.
  final double chipPaddingY;

  /// Small section/layout gap.
  final double sectionGapSm;

  /// Medium section/layout gap.
  final double sectionGapMd;

  /// Large section/layout gap.
  final double sectionGapLg;
}

/// Default spacing scheme implementation.
///
/// Uses standard 4px base unit spacing scale with useful intermediate stops.
class DefaultSpacingScheme extends AppSpacingScheme {
  const DefaultSpacingScheme()
    : super(
        // Primitive spacing tokens
        s0: 0,
        s2: 2,
        s4: 4,
        s6: 6,
        s8: 8,
        s12: 12,
        s16: 16,
        s20: 20,
        s24: 24,
        s32: 32,
        s40: 40,
        s48: 48,
        s64: 64,

        // Semantic / component-level spacing tokens
        buttonPaddingX: 24,
        buttonPaddingY: 12,
        buttonIconGap: 8,
        inputPaddingX: 16,
        inputPaddingY: 12,
        inputLabelGap: 6,
        cardPadding: 16,
        cardGap: 8,
        dialogPadding: 24,
        dialogActionsGap: 8,
        sheetPadding: 16,
        toastMargin: 16,
        toastPaddingX: 16,
        toastPaddingY: 12,
        badgePaddingX: 6,
        badgePaddingY: 2,
        chipPaddingX: 12,
        chipPaddingY: 8,
        sectionGapSm: 8,
        sectionGapMd: 16,
        sectionGapLg: 24,
      );
}
