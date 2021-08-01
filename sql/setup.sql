/*** Unit ***/
CREATE TABLE "unit" (
    "unitID" SERIAL PRIMARY KEY,
    "name" VARCHAR NOT NULL
);

INSERT INTO "unit" ("name") VALUES
    ('tsp'),
    ('tbsp'),
    ('oz'),
    ('cup'),
    ('pint'),
    ('quart'),
    ('gallon'),
    ('mL'),
    ('L'),
    ('lb'),
    ('g');

/*** Author ***/
CREATE TABLE "author" (
    "authorID" SERIAL PRIMARY KEY,
    "firstName" VARCHAR NOT NULL,
    "lastName" VARCHAR NOT NULL
);

/*** CourseType ***/
CREATE TABLE "courseType" (
    "courseID" SERIAL PRIMARY KEY,
    "name" VARCHAR NOT NULL
);

INSERT INTO "courseType" ("name") VALUES
    ('Appetizers'),
    ('Bread'),
    ('Breakfast & Brunch'),
    ('Condiments'),
    ('Dessert'),
    ('Lunch'),
    ('Main Dish'),
    ('Salad'),
    ('Side Dish'),
    ('Snacks'),
    ('Soups & Stews');

/*** Cuisine ***/
CREATE TABLE "cuisine" (
    "cuisineID" SERIAL PRIMARY KEY,
    "country" VARCHAR,
    "name" VARCHAR UNIQUE
);

/*** Recipe ***/
CREATE TABLE "recipe" (
    "recipeID" SERIAL PRIMARY KEY,
    "recipeName" VARCHAR NOT NULL,
    "authorID" INT REFERENCES "author"("authorID") ON DELETE SET NULL,
    "datePublished" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_DATE,
    "description" VARCHAR,
    "prepTime" VARCHAR,
    "cookTime" VARCHAR,
    "cuisineID" INT REFERENCES "cuisine"("cuisineID") ON DELETE SET NULL,
    "courseID" INT REFERENCES "courseType"("courseID") ON DELETE SET NULL,
    "servings" INT
);

/*** Nutrition ***/
CREATE TABLE "nutrition" (
    "nutritionID" SERIAL PRIMARY KEY,
    "recipeID" INT REFERENCES "recipe"("recipeID") ON DELETE CASCADE,
    "totalCalories" DECIMAL NOT NULL
);

/*** Ingredient ***/
CREATE TABLE "ingredient" (
    "ingredientID" SERIAL PRIMARY KEY,
    "recipeID" INT REFERENCES "recipe"("recipeID") ON DELETE CASCADE,
    "name" VARCHAR NOT NULL,
    "unitID" INT REFERENCES "unit"("unitID") ON DELETE SET NULL,
    "amount" VARCHAR
);

/*** Instruction ***/
CREATE TABLE "instruction" (
    "instructionID" SERIAL PRIMARY KEY,
    "recipeID" INT REFERENCES "recipe"("recipeID") ON DELETE CASCADE,
    "step" INT NOT NULL,
    "instruction" VARCHAR NOT NULL
);