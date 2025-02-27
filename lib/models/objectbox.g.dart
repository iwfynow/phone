// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'contact_entity.dart';
import 'message_entity.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 7041394942857454717),
      name: 'ContactEntity',
      lastPropertyId: const obx_int.IdUid(10, 6635470688216195687),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 6251784131705333827),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3618004373572515634),
            name: 'displayName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 829030640557614942),
            name: 'photo',
            type: 23,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7447130822474039510),
            name: 'firstName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 4620923138307538890),
            name: 'lastName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 7597455749622593426),
            name: 'phone',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 5765099593504459804),
            name: 'emails',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 4664640134120265741),
            name: 'address',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 6631316763131012346),
            name: 'company',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 6635470688216195687),
            name: 'notes',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 4510840507936955744),
      name: 'MessageEntity',
      lastPropertyId: const obx_int.IdUid(5, 5394076315366721047),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4599516841687195659),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 746432801236103227),
            name: 'content',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7367938197617418395),
            name: 'senderNumber',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 4629430098433442732),
            name: 'timeStamp',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 5394076315366721047),
            name: 'image',
            type: 23,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(2, 4510840507936955744),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    ContactEntity: obx_int.EntityDefinition<ContactEntity>(
        model: _entities[0],
        toOneRelations: (ContactEntity object) => [],
        toManyRelations: (ContactEntity object) => {},
        getId: (ContactEntity object) => object.id,
        setId: (ContactEntity object, int id) {
          object.id = id;
        },
        objectToFB: (ContactEntity object, fb.Builder fbb) {
          final displayNameOffset = object.displayName == null
              ? null
              : fbb.writeString(object.displayName!);
          final photoOffset =
              object.photo == null ? null : fbb.writeListInt8(object.photo!);
          final firstNameOffset = object.firstName == null
              ? null
              : fbb.writeString(object.firstName!);
          final lastNameOffset = object.lastName == null
              ? null
              : fbb.writeString(object.lastName!);
          final phoneOffset =
              object.phone == null ? null : fbb.writeString(object.phone!);
          final emailsOffset =
              object.emails == null ? null : fbb.writeString(object.emails!);
          final addressOffset =
              object.address == null ? null : fbb.writeString(object.address!);
          final companyOffset =
              object.company == null ? null : fbb.writeString(object.company!);
          final notesOffset =
              object.notes == null ? null : fbb.writeString(object.notes!);
          fbb.startTable(11);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, displayNameOffset);
          fbb.addOffset(2, photoOffset);
          fbb.addOffset(3, firstNameOffset);
          fbb.addOffset(4, lastNameOffset);
          fbb.addOffset(5, phoneOffset);
          fbb.addOffset(6, emailsOffset);
          fbb.addOffset(7, addressOffset);
          fbb.addOffset(8, companyOffset);
          fbb.addOffset(9, notesOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ContactEntity()
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4)
            ..displayName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 6)
            ..photo = const fb.Uint8ListReader(lazy: false)
                .vTableGetNullable(buffer, rootOffset, 8) as Uint8List?
            ..firstName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10)
            ..lastName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 12)
            ..phone = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 14)
            ..emails = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 16)
            ..address = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 18)
            ..company = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 20)
            ..notes = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 22);

          return object;
        }),
    MessageEntity: obx_int.EntityDefinition<MessageEntity>(
        model: _entities[1],
        toOneRelations: (MessageEntity object) => [],
        toManyRelations: (MessageEntity object) => {},
        getId: (MessageEntity object) => object.id,
        setId: (MessageEntity object, int id) {
          object.id = id;
        },
        objectToFB: (MessageEntity object, fb.Builder fbb) {
          final contentOffset = fbb.writeString(object.content);
          final senderNumberOffset = fbb.writeString(object.senderNumber);
          final imageOffset =
              object.image == null ? null : fbb.writeListInt8(object.image!);
          fbb.startTable(6);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, contentOffset);
          fbb.addOffset(2, senderNumberOffset);
          fbb.addInt64(3, object.timeStamp.millisecondsSinceEpoch);
          fbb.addOffset(4, imageOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final contentParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final senderNumberParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, '');
          final timeStampParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));
          final object = MessageEntity(
              content: contentParam,
              senderNumber: senderNumberParam,
              timeStamp: timeStampParam,
              image: null)
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4)
            ..image = const fb.Uint8ListReader(lazy: false)
                .vTableGetNullable(buffer, rootOffset, 12) as Uint8List?;

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [ContactEntity] entity fields to define ObjectBox queries.
class ContactEntity_ {
  /// See [ContactEntity.id].
  static final id =
      obx.QueryIntegerProperty<ContactEntity>(_entities[0].properties[0]);

  /// See [ContactEntity.displayName].
  static final displayName =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[1]);

  /// See [ContactEntity.photo].
  static final photo =
      obx.QueryByteVectorProperty<ContactEntity>(_entities[0].properties[2]);

  /// See [ContactEntity.firstName].
  static final firstName =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[3]);

  /// See [ContactEntity.lastName].
  static final lastName =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[4]);

  /// See [ContactEntity.phone].
  static final phone =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[5]);

  /// See [ContactEntity.emails].
  static final emails =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[6]);

  /// See [ContactEntity.address].
  static final address =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[7]);

  /// See [ContactEntity.company].
  static final company =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[8]);

  /// See [ContactEntity.notes].
  static final notes =
      obx.QueryStringProperty<ContactEntity>(_entities[0].properties[9]);
}

/// [MessageEntity] entity fields to define ObjectBox queries.
class MessageEntity_ {
  /// See [MessageEntity.id].
  static final id =
      obx.QueryIntegerProperty<MessageEntity>(_entities[1].properties[0]);

  /// See [MessageEntity.content].
  static final content =
      obx.QueryStringProperty<MessageEntity>(_entities[1].properties[1]);

  /// See [MessageEntity.senderNumber].
  static final senderNumber =
      obx.QueryStringProperty<MessageEntity>(_entities[1].properties[2]);

  /// See [MessageEntity.timeStamp].
  static final timeStamp =
      obx.QueryDateProperty<MessageEntity>(_entities[1].properties[3]);

  /// See [MessageEntity.image].
  static final image =
      obx.QueryByteVectorProperty<MessageEntity>(_entities[1].properties[4]);
}
