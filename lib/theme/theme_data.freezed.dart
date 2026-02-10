// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppThemeData {
  AppColorScheme get colors => throw _privateConstructorUsedError;
  AppTypographyScheme get typography => throw _privateConstructorUsedError;
  AppSpacingScheme get spacing => throw _privateConstructorUsedError;
  AppRadiusScheme get radius => throw _privateConstructorUsedError;
  AppSizeScheme get sizes => throw _privateConstructorUsedError;
  AppShadowScheme get shadows => throw _privateConstructorUsedError;

  /// Create a copy of AppThemeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppThemeDataCopyWith<AppThemeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeDataCopyWith<$Res> {
  factory $AppThemeDataCopyWith(
    AppThemeData value,
    $Res Function(AppThemeData) then,
  ) = _$AppThemeDataCopyWithImpl<$Res, AppThemeData>;
  @useResult
  $Res call({
    AppColorScheme colors,
    AppTypographyScheme typography,
    AppSpacingScheme spacing,
    AppRadiusScheme radius,
    AppSizeScheme sizes,
    AppShadowScheme shadows,
  });
}

/// @nodoc
class _$AppThemeDataCopyWithImpl<$Res, $Val extends AppThemeData>
    implements $AppThemeDataCopyWith<$Res> {
  _$AppThemeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppThemeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? typography = null,
    Object? spacing = null,
    Object? radius = null,
    Object? sizes = null,
    Object? shadows = null,
  }) {
    return _then(
      _value.copyWith(
            colors: null == colors
                ? _value.colors
                : colors // ignore: cast_nullable_to_non_nullable
                      as AppColorScheme,
            typography: null == typography
                ? _value.typography
                : typography // ignore: cast_nullable_to_non_nullable
                      as AppTypographyScheme,
            spacing: null == spacing
                ? _value.spacing
                : spacing // ignore: cast_nullable_to_non_nullable
                      as AppSpacingScheme,
            radius: null == radius
                ? _value.radius
                : radius // ignore: cast_nullable_to_non_nullable
                      as AppRadiusScheme,
            sizes: null == sizes
                ? _value.sizes
                : sizes // ignore: cast_nullable_to_non_nullable
                      as AppSizeScheme,
            shadows: null == shadows
                ? _value.shadows
                : shadows // ignore: cast_nullable_to_non_nullable
                      as AppShadowScheme,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppThemeDataImplCopyWith<$Res>
    implements $AppThemeDataCopyWith<$Res> {
  factory _$$AppThemeDataImplCopyWith(
    _$AppThemeDataImpl value,
    $Res Function(_$AppThemeDataImpl) then,
  ) = __$$AppThemeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AppColorScheme colors,
    AppTypographyScheme typography,
    AppSpacingScheme spacing,
    AppRadiusScheme radius,
    AppSizeScheme sizes,
    AppShadowScheme shadows,
  });
}

/// @nodoc
class __$$AppThemeDataImplCopyWithImpl<$Res>
    extends _$AppThemeDataCopyWithImpl<$Res, _$AppThemeDataImpl>
    implements _$$AppThemeDataImplCopyWith<$Res> {
  __$$AppThemeDataImplCopyWithImpl(
    _$AppThemeDataImpl _value,
    $Res Function(_$AppThemeDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppThemeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? typography = null,
    Object? spacing = null,
    Object? radius = null,
    Object? sizes = null,
    Object? shadows = null,
  }) {
    return _then(
      _$AppThemeDataImpl(
        colors: null == colors
            ? _value.colors
            : colors // ignore: cast_nullable_to_non_nullable
                  as AppColorScheme,
        typography: null == typography
            ? _value.typography
            : typography // ignore: cast_nullable_to_non_nullable
                  as AppTypographyScheme,
        spacing: null == spacing
            ? _value.spacing
            : spacing // ignore: cast_nullable_to_non_nullable
                  as AppSpacingScheme,
        radius: null == radius
            ? _value.radius
            : radius // ignore: cast_nullable_to_non_nullable
                  as AppRadiusScheme,
        sizes: null == sizes
            ? _value.sizes
            : sizes // ignore: cast_nullable_to_non_nullable
                  as AppSizeScheme,
        shadows: null == shadows
            ? _value.shadows
            : shadows // ignore: cast_nullable_to_non_nullable
                  as AppShadowScheme,
      ),
    );
  }
}

/// @nodoc

class _$AppThemeDataImpl extends _AppThemeData {
  const _$AppThemeDataImpl({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.sizes,
    required this.shadows,
  }) : super._();

  @override
  final AppColorScheme colors;
  @override
  final AppTypographyScheme typography;
  @override
  final AppSpacingScheme spacing;
  @override
  final AppRadiusScheme radius;
  @override
  final AppSizeScheme sizes;
  @override
  final AppShadowScheme shadows;

  @override
  String toString() {
    return 'AppThemeData(colors: $colors, typography: $typography, spacing: $spacing, radius: $radius, sizes: $sizes, shadows: $shadows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppThemeDataImpl &&
            (identical(other.colors, colors) || other.colors == colors) &&
            (identical(other.typography, typography) ||
                other.typography == typography) &&
            (identical(other.spacing, spacing) || other.spacing == spacing) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.sizes, sizes) || other.sizes == sizes) &&
            (identical(other.shadows, shadows) || other.shadows == shadows));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    colors,
    typography,
    spacing,
    radius,
    sizes,
    shadows,
  );

  /// Create a copy of AppThemeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppThemeDataImplCopyWith<_$AppThemeDataImpl> get copyWith =>
      __$$AppThemeDataImplCopyWithImpl<_$AppThemeDataImpl>(this, _$identity);
}

abstract class _AppThemeData extends AppThemeData {
  const factory _AppThemeData({
    required final AppColorScheme colors,
    required final AppTypographyScheme typography,
    required final AppSpacingScheme spacing,
    required final AppRadiusScheme radius,
    required final AppSizeScheme sizes,
    required final AppShadowScheme shadows,
  }) = _$AppThemeDataImpl;
  const _AppThemeData._() : super._();

  @override
  AppColorScheme get colors;
  @override
  AppTypographyScheme get typography;
  @override
  AppSpacingScheme get spacing;
  @override
  AppRadiusScheme get radius;
  @override
  AppSizeScheme get sizes;
  @override
  AppShadowScheme get shadows;

  /// Create a copy of AppThemeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppThemeDataImplCopyWith<_$AppThemeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
