-- Migration to update recipe_ingredients.quantity from integer to decimal
-- This supports fractional quantities like 0.5, 0.25, etc.

-- Update the quantity column to support decimal values
ALTER TABLE recipe_ingredients 
ALTER COLUMN quantity TYPE DECIMAL(8,3) USING quantity::DECIMAL(8,3);

-- Set default value
ALTER TABLE recipe_ingredients 
ALTER COLUMN quantity SET DEFAULT 1;