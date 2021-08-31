-- Drop all tables without removing SCHEMA
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;

-- READ functionality
SELECT * FROM unit;
SELECT * FROM author;
SELECT * FROM courseType;
SELECT * FROM cuisine;
SELECT * FROM recipe;
SELECT * FROM instruction;
SELECT * FROM ingredient;
SELECT * FROM nutrition;

-- example getRecipe by username
SELECT "recipe"."recipeID", "recipe"."recipeName", "author"."username", "recipe"."datePublished", "recipe"."description", "recipe"."prepTime", "recipe"."cookTime", "cuisine"."name" as "cuisine_name", "courseType"."name" as "course_name", "recipe"."servings"
FROM "recipe"
    INNER JOIN "author" ON "recipe"."authorID" = "author"."authorID"
    INNER JOIN "cuisine" ON "recipe"."cuisineID" = "cuisine"."cuisineID"
    INNER JOIN "courseType" ON "recipe"."courseID" = "courseType"."courseID"
WHERE "author"."username" = 'tp96';

-- get all ingredients by recipeID
SELECT "ingredient"."name" as "ingredient_name", "ingredient"."amount", "unit"."name" as "unit"
FROM "ingredient"
    INNER JOIN "unit" ON "ingredient"."unitID" = "unit"."unitID"
WHERE "ingredient"."recipeID" = 1;

-- get all instructions by recipeID and sort in ascending order of step numbers
SELECT "instruction"."step", "instruction"."instruction"
FROM "instruction"
WHERE "instruction"."recipeID" = 1
ORDER BY "instruction"."step" ASC;

/*
CREATE functionality
*/
-- author
INSERT INTO "author" ("firstName", "lastName") VALUES
    (:firstNameInput, :lastNameInput);

-- cuisine
INSERT INTO "cuisine" ("country", "name") VALUES
    (:countryInput, :nameInput);

-- recipe
INSERT INTO "recipe" ("recipeName", "authorID", "datePublished", "description", "prepTime", "cookTime", "cuisineID", "courseID", "servings") VALUES
    (:recipeNameInput, (SELECT "authorID" FROM "author" WHERE "authorID" = :authorIDInput), :descriptionInput, :prepTimeInput, :cookTimeInput, (SELECT "cuisineID" FROM "cuisine" WHERE "cuisineID" = :cuisineIDInput), (SELECT "courseID" FROM "courseType" WHERE "courseID" = :courseIDInput), :servingsInput);

/**
Example:
INSERT INTO "recipe" ("recipeName", "authorID", "description", "prepTime", "cookTime", "cuisineID", "courseID", "servings") VALUES
    ('Chicken & Sausage Gumbo', (SELECT "authorID" FROM "author" WHERE "authorID" = 1), 'Classic cajun stew dish best served with white rice!', NULL, NULL, (SELECT "cuisineID" FROM "cuisine" WHERE "cuisineID" = 1), (SELECT "courseID" FROM "courseType" WHERE "courseID" = 7), 4);
**/

-- instruction
INSERT INTO "instruction" ("recipeID", "step", "instruction") VALUES
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = :recipeID), :stepInput, :instructionInput);

-- ingredient
INSERT INTO "ingredient" ("recipeID", "name", "unitID", "amount") VALUES
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = :recipeIDInput), :nameInput, (SELECT "unitID" FROM "unit" WHERE "unitID" = :unitIDInput), :amountInput);

-- nutrition
INSERT INTO "nutrition" ("totalCalories", "recipeID") VALUES
    (:totalCaloriesInput, (SELECT "recipeID" FROM "recipe" WHERE "recipeID" = :recipeIDInput));


/*
UPDATE functionality
*/
-- author
UPDATE "author" SET :columnName = :newValue WHERE "authorID" = :authorIDInput;

-- cuisine
UPDATE "cuisine" SET :columnName = :newValue WHERE "cuisineID" = :cuisineIDInput;

-- recipe
UPDATE "recipe" SET :columnName = :newValue WHERE "recipeID" = :recipeIDInput;

-- instruction
UPDATE "instruction" SET :columnName = :newValue WHERE "instructionID" = :instructionIDInput;

-- ingredient
UPDATE "ingredient" SET :columnName = :newValue WHERE "ingredientID" = :ingredientIDInput;

-- nutrition
UPDATE "nutrition" SET :columnName = :newValue WHERE "nutritionID" = :nutritionIDInput;


/*
DELETE functionality
*/
-- author
DELETE FROM "author" WHERE "authorID" = :authorIDInput

-- cuisine
DELETE FROM "cuisine" WHERE "cuisineID" = :cuisineIDInput

-- recipe
DELETE FROM "recipe" WHERE "recipeID" = :recipeIDInput

-- instruction
DELETE FROM "instruction" WHERE "instructionID" = :instructionIDInput

-- ingredient
DELETE FROM "ingredient" WHERE "ingredientID" = :ingredientIDInput

-- nutrition
DELETE FROM "nutrition" WHERE "nutritionID" = :nutritionIDInput

