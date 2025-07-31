#!/usr/bin/env node

/**
 * Script to run the quantity column migration
 * This updates the recipe_ingredients.quantity column from integer to decimal
 */

import { AppDataSource } from '../config/data_source';
import * as fs from 'fs';
import * as path from 'path';

async function runMigration() {
    try {
        console.log('🚀 Initializing database connection...');
        await AppDataSource.initialize();
        console.log('✅ Database connection established');

        // Read the migration SQL file
        const migrationPath = path.join(__dirname, '../migrations/002_update_quantity_to_decimal.sql');
        if (!fs.existsSync(migrationPath)) {
            throw new Error(`Migration file not found at: ${migrationPath}`);
        }

        console.log('📖 Reading migration file...');
        const migrationSQL = fs.readFileSync(migrationPath, 'utf-8');

        console.log('🔄 Running migration to update quantity column to decimal...');
        
        // Split by semicolon and run each statement
        const statements = migrationSQL
            .split(';')
            .map(s => s.trim())
            .filter(s => s.length > 0 && !s.startsWith('--'));

        for (const statement of statements) {
            console.log(`   Executing: ${statement.substring(0, 50)}...`);
            await AppDataSource.query(statement);
        }

        console.log('✅ Migration completed successfully!');
        console.log('\n📊 Column Details:');
        console.log('   • Type: DECIMAL(8,3)');
        console.log('   • Precision: 8 total digits');
        console.log('   • Scale: 3 decimal places');
        console.log('   • Range: -99999.999 to 99999.999');
        console.log('   • Default: 1');
        
        console.log('\n🎉 Ready to seed recipes with fractional quantities!');
        console.log('   Run: npm run seed:recipes');

    } catch (error: any) {
        console.error('❌ Error during migration:', error.message);
        if (error.stack) {
            console.error('Stack trace:', error.stack);
        }
        process.exit(1);
    } finally {
        if (AppDataSource.isInitialized) {
            await AppDataSource.destroy();
            console.log('🔌 Database connection closed');
        }
    }
}

// Run the migration
runMigration();