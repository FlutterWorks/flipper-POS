import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'units'),
)
class IUnit extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  int? branchId;
  String? name;
  String? value;
  @Sqlite(defaultValue: "false")
  @Supabase(defaultValue: "false")
  bool? active;
  String? code;
  String? description;

  DateTime? lastTouched;

  String? createdAt;
  IUnit({
    String? id,
    this.branchId,
    this.name,
    this.value,
    this.active,
    this.code,
    this.description,
    this.lastTouched,
    this.createdAt,
  }) : id = id ?? const Uuid().v4();
}
