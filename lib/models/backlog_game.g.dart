// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backlog_game.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBacklogGameCollection on Isar {
  IsarCollection<BacklogGame> get backlogGames => this.collection();
}

const BacklogGameSchema = CollectionSchema(
  name: r'BacklogGame',
  id: -7566227327644713608,
  properties: {
    r'costPerHour': PropertySchema(
      id: 0,
      name: r'costPerHour',
      type: IsarType.double,
    ),
    r'coverPath': PropertySchema(
      id: 1,
      name: r'coverPath',
      type: IsarType.string,
    ),
    r'dateAdded': PropertySchema(
      id: 2,
      name: r'dateAdded',
      type: IsarType.dateTime,
    ),
    r'dateCompleted': PropertySchema(
      id: 3,
      name: r'dateCompleted',
      type: IsarType.dateTime,
    ),
    r'dateStarted': PropertySchema(
      id: 4,
      name: r'dateStarted',
      type: IsarType.dateTime,
    ),
    r'genres': PropertySchema(
      id: 5,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'hoursPlayed': PropertySchema(
      id: 6,
      name: r'hoursPlayed',
      type: IsarType.double,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'platform': PropertySchema(
      id: 8,
      name: r'platform',
      type: IsarType.byte,
      enumMap: _BacklogGameplatformEnumValueMap,
    ),
    r'priority': PropertySchema(
      id: 9,
      name: r'priority',
      type: IsarType.long,
    ),
    r'purchasePrice': PropertySchema(
      id: 10,
      name: r'purchasePrice',
      type: IsarType.double,
    ),
    r'rating': PropertySchema(
      id: 11,
      name: r'rating',
      type: IsarType.double,
    ),
    r'status': PropertySchema(
      id: 12,
      name: r'status',
      type: IsarType.byte,
      enumMap: _BacklogGamestatusEnumValueMap,
    ),
    r'title': PropertySchema(
      id: 13,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _backlogGameEstimateSize,
  serialize: _backlogGameSerialize,
  deserialize: _backlogGameDeserialize,
  deserializeProp: _backlogGameDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _backlogGameGetId,
  getLinks: _backlogGameGetLinks,
  attach: _backlogGameAttach,
  version: '3.1.0+1',
);

int _backlogGameEstimateSize(
  BacklogGame object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.coverPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.genres.length * 3;
  {
    for (var i = 0; i < object.genres.length; i++) {
      final value = object.genres[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _backlogGameSerialize(
  BacklogGame object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.costPerHour);
  writer.writeString(offsets[1], object.coverPath);
  writer.writeDateTime(offsets[2], object.dateAdded);
  writer.writeDateTime(offsets[3], object.dateCompleted);
  writer.writeDateTime(offsets[4], object.dateStarted);
  writer.writeStringList(offsets[5], object.genres);
  writer.writeDouble(offsets[6], object.hoursPlayed);
  writer.writeString(offsets[7], object.notes);
  writer.writeByte(offsets[8], object.platform.index);
  writer.writeLong(offsets[9], object.priority);
  writer.writeDouble(offsets[10], object.purchasePrice);
  writer.writeDouble(offsets[11], object.rating);
  writer.writeByte(offsets[12], object.status.index);
  writer.writeString(offsets[13], object.title);
}

BacklogGame _backlogGameDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BacklogGame();
  object.coverPath = reader.readStringOrNull(offsets[1]);
  object.dateAdded = reader.readDateTime(offsets[2]);
  object.dateCompleted = reader.readDateTimeOrNull(offsets[3]);
  object.dateStarted = reader.readDateTimeOrNull(offsets[4]);
  object.genres = reader.readStringList(offsets[5]) ?? [];
  object.hoursPlayed = reader.readDouble(offsets[6]);
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[7]);
  object.platform =
      _BacklogGameplatformValueEnumMap[reader.readByteOrNull(offsets[8])] ??
          GamePlatform.pc;
  object.priority = reader.readLong(offsets[9]);
  object.purchasePrice = reader.readDoubleOrNull(offsets[10]);
  object.rating = reader.readDoubleOrNull(offsets[11]);
  object.status =
      _BacklogGamestatusValueEnumMap[reader.readByteOrNull(offsets[12])] ??
          GameStatus.backlog;
  object.title = reader.readString(offsets[13]);
  return object;
}

P _backlogGameDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (_BacklogGameplatformValueEnumMap[reader.readByteOrNull(offset)] ??
          GamePlatform.pc) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (_BacklogGamestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          GameStatus.backlog) as P;
    case 13:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BacklogGameplatformEnumValueMap = {
  'pc': 0,
  'ps5': 1,
  'ps4': 2,
  'switch_': 3,
  'xbox': 4,
  'mobile': 5,
  'other': 6,
};
const _BacklogGameplatformValueEnumMap = {
  0: GamePlatform.pc,
  1: GamePlatform.ps5,
  2: GamePlatform.ps4,
  3: GamePlatform.switch_,
  4: GamePlatform.xbox,
  5: GamePlatform.mobile,
  6: GamePlatform.other,
};
const _BacklogGamestatusEnumValueMap = {
  'backlog': 0,
  'playing': 1,
  'completed': 2,
  'dropped': 3,
};
const _BacklogGamestatusValueEnumMap = {
  0: GameStatus.backlog,
  1: GameStatus.playing,
  2: GameStatus.completed,
  3: GameStatus.dropped,
};

Id _backlogGameGetId(BacklogGame object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _backlogGameGetLinks(BacklogGame object) {
  return [];
}

void _backlogGameAttach(
    IsarCollection<dynamic> col, Id id, BacklogGame object) {
  object.id = id;
}

extension BacklogGameQueryWhereSort
    on QueryBuilder<BacklogGame, BacklogGame, QWhere> {
  QueryBuilder<BacklogGame, BacklogGame, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BacklogGameQueryWhere
    on QueryBuilder<BacklogGame, BacklogGame, QWhereClause> {
  QueryBuilder<BacklogGame, BacklogGame, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BacklogGameQueryFilter
    on QueryBuilder<BacklogGame, BacklogGame, QFilterCondition> {
  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      costPerHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'costPerHour',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      costPerHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'costPerHour',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      costPerHourEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'costPerHour',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      costPerHourGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'costPerHour',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      costPerHourLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'costPerHour',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      costPerHourBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'costPerHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'coverPath',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'coverPath',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coverPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coverPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coverPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coverPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coverPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      coverPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateAddedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateAddedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateAddedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateAddedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateAdded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateCompletedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateCompleted',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateCompletedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateCompleted',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateCompletedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateCompletedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateCompletedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateCompletedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateStartedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateStarted',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateStartedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateStarted',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateStartedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateStarted',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateStartedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateStarted',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateStartedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateStarted',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      dateStartedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateStarted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genres',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genres',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      genresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      hoursPlayedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hoursPlayed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      hoursPlayedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hoursPlayed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      hoursPlayedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hoursPlayed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      hoursPlayedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hoursPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> platformEqualTo(
      GamePlatform value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platform',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      platformGreaterThan(
    GamePlatform value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'platform',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      platformLessThan(
    GamePlatform value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'platform',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> platformBetween(
    GamePlatform lower,
    GamePlatform upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'platform',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> priorityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      purchasePriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchasePrice',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      purchasePriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchasePrice',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      purchasePriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      purchasePriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      purchasePriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      purchasePriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchasePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> ratingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      ratingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> ratingEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      ratingGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> ratingLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> ratingBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> statusEqualTo(
      GameStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      statusGreaterThan(
    GameStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> statusLessThan(
    GameStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> statusBetween(
    GameStatus lower,
    GameStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension BacklogGameQueryObject
    on QueryBuilder<BacklogGame, BacklogGame, QFilterCondition> {}

extension BacklogGameQueryLinks
    on QueryBuilder<BacklogGame, BacklogGame, QFilterCondition> {}

extension BacklogGameQuerySortBy
    on QueryBuilder<BacklogGame, BacklogGame, QSortBy> {
  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByCostPerHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPerHour', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByCostPerHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPerHour', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByCoverPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverPath', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByCoverPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverPath', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByDateCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy>
      sortByDateCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByDateStartedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByHoursPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByHoursPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy>
      sortByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension BacklogGameQuerySortThenBy
    on QueryBuilder<BacklogGame, BacklogGame, QSortThenBy> {
  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByCostPerHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPerHour', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByCostPerHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPerHour', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByCoverPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverPath', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByCoverPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverPath', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByDateCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy>
      thenByDateCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCompleted', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByDateStartedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByHoursPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByHoursPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursPlayed', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy>
      thenByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension BacklogGameQueryWhereDistinct
    on QueryBuilder<BacklogGame, BacklogGame, QDistinct> {
  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByCostPerHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'costPerHour');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByCoverPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAdded');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByDateCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCompleted');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateStarted');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByHoursPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursPlayed');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platform');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchasePrice');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<BacklogGame, BacklogGame, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension BacklogGameQueryProperty
    on QueryBuilder<BacklogGame, BacklogGame, QQueryProperty> {
  QueryBuilder<BacklogGame, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BacklogGame, double?, QQueryOperations> costPerHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'costPerHour');
    });
  }

  QueryBuilder<BacklogGame, String?, QQueryOperations> coverPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverPath');
    });
  }

  QueryBuilder<BacklogGame, DateTime, QQueryOperations> dateAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAdded');
    });
  }

  QueryBuilder<BacklogGame, DateTime?, QQueryOperations>
      dateCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCompleted');
    });
  }

  QueryBuilder<BacklogGame, DateTime?, QQueryOperations> dateStartedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateStarted');
    });
  }

  QueryBuilder<BacklogGame, List<String>, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<BacklogGame, double, QQueryOperations> hoursPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursPlayed');
    });
  }

  QueryBuilder<BacklogGame, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<BacklogGame, GamePlatform, QQueryOperations> platformProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platform');
    });
  }

  QueryBuilder<BacklogGame, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<BacklogGame, double?, QQueryOperations> purchasePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchasePrice');
    });
  }

  QueryBuilder<BacklogGame, double?, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<BacklogGame, GameStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<BacklogGame, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
