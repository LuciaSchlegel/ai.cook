import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateQuantityToDecimal1703000000000 implements MigrationInterface {
    name = 'UpdateQuantityToDecimal1703000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Update the quantity column to support decimal values with precision 8, scale 3
        await queryRunner.query(`
            ALTER TABLE recipe_ingredients 
            ALTER COLUMN quantity TYPE DECIMAL(8,3) USING quantity::DECIMAL(8,3)
        `);
        
        // Set default value
        await queryRunner.query(`
            ALTER TABLE recipe_ingredients 
            ALTER COLUMN quantity SET DEFAULT 1
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Revert back to integer (this will truncate decimal values)
        await queryRunner.query(`
            ALTER TABLE recipe_ingredients 
            ALTER COLUMN quantity TYPE INTEGER USING ROUND(quantity)
        `);
        
        // Remove default
        await queryRunner.query(`
            ALTER TABLE recipe_ingredients 
            ALTER COLUMN quantity DROP DEFAULT
        `);
    }
}