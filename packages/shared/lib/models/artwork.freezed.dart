// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artwork.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Artwork _$ArtworkFromJson(Map<String, dynamic> json) {
  return _Artwork.fromJson(json);
}

/// @nodoc
mixin _$Artwork {
  String? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get blurHash => throw _privateConstructorUsedError;
  String? get artistId => throw _privateConstructorUsedError;
  List<String> get collectionIds => throw _privateConstructorUsedError;
  List<String> get techniqueIds => throw _privateConstructorUsedError;
  double get aspectRatio => throw _privateConstructorUsedError;
  bool get featured => throw _privateConstructorUsedError;
  int get featuredOrder => throw _privateConstructorUsedError;
  bool get published => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Artwork to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Artwork
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArtworkCopyWith<Artwork> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtworkCopyWith<$Res> {
  factory $ArtworkCopyWith(Artwork value, $Res Function(Artwork) then) =
      _$ArtworkCopyWithImpl<$Res, Artwork>;
  @useResult
  $Res call({
    String? id,
    String title,
    String? description,
    String? imageUrl,
    String? thumbnailUrl,
    String? blurHash,
    String? artistId,
    List<String> collectionIds,
    List<String> techniqueIds,
    double aspectRatio,
    bool featured,
    int featuredOrder,
    bool published,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$ArtworkCopyWithImpl<$Res, $Val extends Artwork>
    implements $ArtworkCopyWith<$Res> {
  _$ArtworkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Artwork
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? blurHash = freezed,
    Object? artistId = freezed,
    Object? collectionIds = null,
    Object? techniqueIds = null,
    Object? aspectRatio = null,
    Object? featured = null,
    Object? featuredOrder = null,
    Object? published = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            blurHash: freezed == blurHash
                ? _value.blurHash
                : blurHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            artistId: freezed == artistId
                ? _value.artistId
                : artistId // ignore: cast_nullable_to_non_nullable
                      as String?,
            collectionIds: null == collectionIds
                ? _value.collectionIds
                : collectionIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            techniqueIds: null == techniqueIds
                ? _value.techniqueIds
                : techniqueIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            aspectRatio: null == aspectRatio
                ? _value.aspectRatio
                : aspectRatio // ignore: cast_nullable_to_non_nullable
                      as double,
            featured: null == featured
                ? _value.featured
                : featured // ignore: cast_nullable_to_non_nullable
                      as bool,
            featuredOrder: null == featuredOrder
                ? _value.featuredOrder
                : featuredOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            published: null == published
                ? _value.published
                : published // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArtworkImplCopyWith<$Res> implements $ArtworkCopyWith<$Res> {
  factory _$$ArtworkImplCopyWith(
    _$ArtworkImpl value,
    $Res Function(_$ArtworkImpl) then,
  ) = __$$ArtworkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String title,
    String? description,
    String? imageUrl,
    String? thumbnailUrl,
    String? blurHash,
    String? artistId,
    List<String> collectionIds,
    List<String> techniqueIds,
    double aspectRatio,
    bool featured,
    int featuredOrder,
    bool published,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ArtworkImplCopyWithImpl<$Res>
    extends _$ArtworkCopyWithImpl<$Res, _$ArtworkImpl>
    implements _$$ArtworkImplCopyWith<$Res> {
  __$$ArtworkImplCopyWithImpl(
    _$ArtworkImpl _value,
    $Res Function(_$ArtworkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Artwork
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? blurHash = freezed,
    Object? artistId = freezed,
    Object? collectionIds = null,
    Object? techniqueIds = null,
    Object? aspectRatio = null,
    Object? featured = null,
    Object? featuredOrder = null,
    Object? published = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ArtworkImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        blurHash: freezed == blurHash
            ? _value.blurHash
            : blurHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        artistId: freezed == artistId
            ? _value.artistId
            : artistId // ignore: cast_nullable_to_non_nullable
                  as String?,
        collectionIds: null == collectionIds
            ? _value._collectionIds
            : collectionIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        techniqueIds: null == techniqueIds
            ? _value._techniqueIds
            : techniqueIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        aspectRatio: null == aspectRatio
            ? _value.aspectRatio
            : aspectRatio // ignore: cast_nullable_to_non_nullable
                  as double,
        featured: null == featured
            ? _value.featured
            : featured // ignore: cast_nullable_to_non_nullable
                  as bool,
        featuredOrder: null == featuredOrder
            ? _value.featuredOrder
            : featuredOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        published: null == published
            ? _value.published
            : published // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArtworkImpl implements _Artwork {
  const _$ArtworkImpl({
    this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.thumbnailUrl,
    this.blurHash,
    this.artistId,
    final List<String> collectionIds = const [],
    final List<String> techniqueIds = const [],
    this.aspectRatio = 1.0,
    this.featured = false,
    this.featuredOrder = 0,
    this.published = false,
    @TimestampConverter() this.createdAt,
    @TimestampConverter() this.updatedAt,
  }) : _collectionIds = collectionIds,
       _techniqueIds = techniqueIds;

  factory _$ArtworkImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArtworkImplFromJson(json);

  @override
  final String? id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? blurHash;
  @override
  final String? artistId;
  final List<String> _collectionIds;
  @override
  @JsonKey()
  List<String> get collectionIds {
    if (_collectionIds is EqualUnmodifiableListView) return _collectionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collectionIds);
  }

  final List<String> _techniqueIds;
  @override
  @JsonKey()
  List<String> get techniqueIds {
    if (_techniqueIds is EqualUnmodifiableListView) return _techniqueIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_techniqueIds);
  }

  @override
  @JsonKey()
  final double aspectRatio;
  @override
  @JsonKey()
  final bool featured;
  @override
  @JsonKey()
  final int featuredOrder;
  @override
  @JsonKey()
  final bool published;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Artwork(id: $id, title: $title, description: $description, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, blurHash: $blurHash, artistId: $artistId, collectionIds: $collectionIds, techniqueIds: $techniqueIds, aspectRatio: $aspectRatio, featured: $featured, featuredOrder: $featuredOrder, published: $published, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArtworkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.blurHash, blurHash) ||
                other.blurHash == blurHash) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            const DeepCollectionEquality().equals(
              other._collectionIds,
              _collectionIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._techniqueIds,
              _techniqueIds,
            ) &&
            (identical(other.aspectRatio, aspectRatio) ||
                other.aspectRatio == aspectRatio) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.featuredOrder, featuredOrder) ||
                other.featuredOrder == featuredOrder) &&
            (identical(other.published, published) ||
                other.published == published) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    imageUrl,
    thumbnailUrl,
    blurHash,
    artistId,
    const DeepCollectionEquality().hash(_collectionIds),
    const DeepCollectionEquality().hash(_techniqueIds),
    aspectRatio,
    featured,
    featuredOrder,
    published,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Artwork
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArtworkImplCopyWith<_$ArtworkImpl> get copyWith =>
      __$$ArtworkImplCopyWithImpl<_$ArtworkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArtworkImplToJson(this);
  }
}

abstract class _Artwork implements Artwork {
  const factory _Artwork({
    final String? id,
    required final String title,
    final String? description,
    final String? imageUrl,
    final String? thumbnailUrl,
    final String? blurHash,
    final String? artistId,
    final List<String> collectionIds,
    final List<String> techniqueIds,
    final double aspectRatio,
    final bool featured,
    final int featuredOrder,
    final bool published,
    @TimestampConverter() final DateTime? createdAt,
    @TimestampConverter() final DateTime? updatedAt,
  }) = _$ArtworkImpl;

  factory _Artwork.fromJson(Map<String, dynamic> json) = _$ArtworkImpl.fromJson;

  @override
  String? get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get blurHash;
  @override
  String? get artistId;
  @override
  List<String> get collectionIds;
  @override
  List<String> get techniqueIds;
  @override
  double get aspectRatio;
  @override
  bool get featured;
  @override
  int get featuredOrder;
  @override
  bool get published;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Artwork
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArtworkImplCopyWith<_$ArtworkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
