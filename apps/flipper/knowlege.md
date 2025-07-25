# When editing code, remember to avoid regression as much as you can do this:
- Look at the old feature implementation improve it but do not ever break it
- Document change in knowlege.md

## 2025-04-15: Login Dialog & Navigation Improvement
- Improved the login flow loading dialog in `login.dart`:
  - The loading dialog now remains open until after navigation is triggered, preventing flicker or premature dismissal.
  - Used `WidgetsBinding.instance.addPostFrameCallback` to ensure the dialog closes only after navigation starts.
  - The dialog is also closed on error to prevent it from lingering.
- This change follows the regression-avoidance rule: it preserves the old working behavior and only improves reliability and UX.
- No old code was deleted; only improved for timing and robustness.

## 2025-04-15: Offline PIN Login Restoration & Safeguard
- **Restored and hardened offline PIN login:**
  - Ensured that PIN login works even when offline by always retrieving the PIN and user data from local storage if available.
  - Updated `_getPin` and `_authenticateUser` logic to allow forced offline login, regardless of network status or debug mode, if a valid local PIN exists.
  - Patched business/tenant conversion and boot logic to handle missing/null fields gracefully, using safe defaults for all required fields.
  - Explicitly mapped only the fields present in the API and model, using correct types to prevent type errors and regressions.
- **Regression prevention:**
  - Offline login logic and business mapping must never be broken by future changes. Always test offline PIN login when modifying login or boot flows.
  - If you update business or user models, ensure that all required fields are populated for both online and offline scenarios.
- **How to avoid breaking offline login in the future:**
  - When changing login or boot logic, always run integration tests for offline PIN login.
  - If you add fields to business/user models, provide safe defaults in both online and offline construction.
  - Document all changes related to login and offline flows here.

## 2025-04-16: Repository Performance Optimization
- **Optimized Repository initialization in `packages/supabase_models/lib/brick/repository.dart`:**
  - Removed automatic database backup during initialization to improve startup performance
  - Added `configureDatabase` parameter to `initializeSupabaseAndConfigure` to control database configuration timing
  - Removed unused `ConnectionManager` to reduce overhead
  - Reduced delay in `performPeriodicBackup` from 500ms to 100ms
  - Improved error handling and recovery logic
  
- **How to maintain performance in future edits:**
  - **DO NOT** re-enable automatic backups during initialization - backups should be explicitly called later
  - **DO NOT** add long delays in initialization methods
  - If you need to add new initialization steps, consider making them configurable with parameters
  - Keep database configuration separate from essential initialization steps
  - Use `PlatformHelpers` consistently for platform-specific code

- **For maximum startup performance:**
  - Consider passing `configureDatabase: false` to `initializeSupabaseAndConfigure` and calling `Repository().configureDatabase()` later
  - Use `Future.microtask` for non-critical initialization as done in `_initializeSupabase()`
  - Consider moving database operations to background isolates for heavy operations

  - Create a view for singular table names
  ```sql
  -- First drop the view if it exists
  DROP VIEW IF EXISTS branch;
  
  -- Create a view with the singular name that points to the plural table
  CREATE OR REPLACE VIEW branch AS 
  SELECT * FROM branches;
  
  -- If you have multiple foreign key constraints and get a PGRST201 error, use this approach:
  -- 1. Drop the conflicting constraint (be careful!)
  ALTER TABLE stock_requests DROP CONSTRAINT IF EXISTS fk_stock_requests_branch_id;
  
  -- 2. Or rename one of the constraints to make it clear which one to use
  -- ALTER TABLE stock_requests RENAME CONSTRAINT fk_stock_requests_branch_id TO fk_branch_id_old;
  ```
  
  - This is important when you have a model in singular form (like `Branch`) nested into another model (like `InventoryRequest`)
  - The view allows PostgREST to find the relationship between tables with singular/plural naming differences
  - If you get a PGRST201 error about multiple relationships, you need to either drop one constraint or use the specific relationship name in your query
  - Know this https://github.com/GetDutchie/brick/blob/main/packages/brick_offline_first/lib/src/offline_first_repository.dart#L246-L283 is available so leverage it in future.