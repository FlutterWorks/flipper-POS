// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250402132301_up = [
  DropColumn('updatable_stock_qty', onTable: 'Stock'),
  // DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  // DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  // DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  // DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  // InsertForeignKey('Financing', 'FinanceProvider', foreignKeyColumn: 'provider_FinanceProvider_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('TransactionItem', 'InventoryRequest', foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('Variant', 'Stock', foreignKeyColumn: 'stock_Stock_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('InventoryRequest', 'Branch', foreignKeyColumn: 'branch_Branch_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('InventoryRequest', 'Financing', foreignKeyColumn: 'financing_Financing_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // CreateIndex(columns: ['branch_id'], onTable: 'BranchSmsConfig', unique: true)
];

const List<MigrationCommand> _migration_20250402132301_down = [
  // DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  // DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  // DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  // DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  // DropIndex('index_BranchSmsConfig_on_branch_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250402132301',
  up: _migration_20250402132301_up,
  down: _migration_20250402132301_down,
)
class Migration20250402132301 extends Migration {
  const Migration20250402132301()
      : super(
          version: 20250402132301,
          up: _migration_20250402132301_up,
          down: _migration_20250402132301_down,
        );
}
