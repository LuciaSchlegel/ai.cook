-- Migration: Update quantity fields from INT to DECIMAL
-- Date: 2024-01-15
-- Description: Change quantity fields in recipe_ingredients and user_ingredients tables to support decimal values like 0.5, 1.25, etc.

-- Update recipe_ingredients table
ALTER TABLE recipe_ingredients 
ALTER COLUMN quantity TYPE DECIMAL(8,3) USING quantity::DECIMAL(8,3);

-- Update user_ingredients table  
ALTER TABLE user_ingredients 
ALTER COLUMN quantity TYPE DECIMAL(8,3) USING quantity::DECIMAL(8,3);

-- Add comments for documentation
COMMENT ON COLUMN recipe_ingredients.quantity IS 'Ingredient quantity supporting decimal values (e.g., 0.5 for half cup)';
COMMENT ON COLUMN user_ingredients.quantity IS 'Ingredient quantity supporting decimal values (e.g., 0.5 for half cup)';