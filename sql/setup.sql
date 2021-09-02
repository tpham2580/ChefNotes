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
    "username" VARCHAR NOT NULL UNIQUE,
    "firstName" VARCHAR NOT NULL,
    "lastName" VARCHAR NOT NULL,
    "about" VARCHAR
);

INSERT INTO "author" ("username", "firstName", "lastName", "about") VALUES
    ('tp96', 'Timothy', 'Pham', 'Love of food comes from eating Vietnamese dishes growing up');


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

INSERT INTO "cuisine" ("country", "name") VALUES
    ('United States', 'Cajun/Creole'),
    ('Italy', 'Italian');

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
    "servings" INT,
    "private" BOOLEAN DEFAULT FALSE NOT NULL
);

INSERT INTO "recipe" ("recipeName", "authorID", "description", "prepTime", "cookTime", "cuisineID", "courseID", "servings") VALUES
    ('Chicken & Sausage Gumbo', (SELECT "authorID" FROM "author" WHERE "username" = 'tp96'), 'Classic cajun stew dish best served with white rice!', NULL, NULL, (SELECT "cuisineID" FROM "cuisine" WHERE "name" = 'Cajun/Creole'), (SELECT "courseID" FROM "courseType" WHERE "courseID" = 7), 4),
    ('Pasta Carbonara', (SELECT "authorID" FROM "author" WHERE "username" = 'tp96'), 'Classic italian dish made with egg, pork, cheese, and pasta!', NULL, NULL, (SELECT "cuisineID" FROM "cuisine" WHERE "name" = 'Italian'), (SELECT "courseID" FROM "courseType" WHERE "courseID" = 1), 4);

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

INSERT INTO "ingredient" ("recipeID", "name", "unitID", "amount") VALUES
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'skinless chicken thighs', (SELECT "unitID" FROM "unit" WHERE "name" = 'lb'), '2'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'kosher salt', NULL, 'to taste'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'all purpose flour', (SELECT "unitID" FROM "unit" WHERE "name" = 'g'), '74'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'ground black pepper', (SELECT "unitID" FROM "unit" WHERE "name" = 'tsp'), '1'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'grapeseed oil', (SELECT "unitID" FROM "unit" WHERE "name" = 'mL'), '130'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'garlic, minced', NULL, '6 cloves'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'celery', NULL, '2 ribs'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'jalapeno, seeded and minced', NULL, '1'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'small green bell pepper', NULL, '1'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'small yellow onion', NULL, '1'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'amber-style beer', (SELECT "unitID" FROM "unit" WHERE "name" = 'mL'), '250'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'chicken stock', (SELECT "unitID" FROM "unit" WHERE "name" = 'mL'), '946'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'fresh thyme', (SELECT "unitID" FROM "unit" WHERE "name" = 'tsp'), '1'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'bay leaves', NULL, '4'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'andouille sausage, cut into ¼-inch coins', (SELECT "unitID" FROM "unit" WHERE "name" = 'g'), '453'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'cayenne pepper', NULL, 'to taste'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'cooked white rice', NULL, 'for serving'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 'sliced scallions', NULL, 'for serving'),
    -- Pasta carbonara
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 'Pecorino Romano, grated', (SELECT "unitID" FROM "unit" WHERE "name" = 'g'), '20'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 'Parmigiano Reggiano', (SELECT "unitID" FROM "unit" WHERE "name" = 'g'), '30'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 'Black Pepper', (SELECT "unitID" FROM "unit" WHERE "name" = 'g'), '20'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 'Egg Yolk', NULL, '4'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 'Guanciale', (SELECT "unitID" FROM "unit" WHERE "name" = 'g'), '200'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 'Pasta of your choice', (SELECT "unitID" FROM "unit" WHERE "name" = 'g'), '280');

/*** Instruction ***/
CREATE TABLE "instruction" (
    "instructionID" SERIAL PRIMARY KEY,
    "recipeID" INT REFERENCES "recipe"("recipeID") ON DELETE CASCADE,
    "step" INT NOT NULL,
    "instruction" VARCHAR NOT NULL
);

INSERT INTO "instruction" ("recipeID", "step", "instruction") VALUES
    -- Chicken & Sausage Gumbo
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 1, 'Season the chicken with salt, black pepper, and one tablespoon of grapeseed oil. Broil it until slightly charred and golden, about 10 minutes, and set aside.'), 
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 2, 'Heat a thick bottomed 4-quart Dutch oven over medium. Add the remaining oil and flour and, using a whisk, stir constantly, taking care not to allow any to splash and burn you, until the roux has turned dark brown (the color of a bar of Hershey''s chocolate is about right), about 25 minutes.'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 1), 3, 'Add the garlic, celery, jalapeño, bell pepper, and onion and cook for one minute. Add the beer to deglaze, then add the stock, thyme, bay leaves, and 1 teaspoon black pepper. Stir slowly and continuously until the gumbo is back to a simmer, then add the chicken thighs and the sausage. Bring to a simmer and cover. Cook, stirring occasionally, for 3 hours. Gumbo should thick but not like gravy. Season with cayenne and serve with cooked rice. Top with scallions and enjoy.'),
    -- Pasta Carbonara
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 1, 'Add pecorino, parmigiano, egg yolks, and black pepper to bowl. Mix until until consistent.'), 
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 2, 'Cook guanciale on medium heat until most of the fat has rendered and the guanciale is sufficiently browned. Be sure to save the fat from the guanciale. Also, cook the pasta until al dente in salted water.'),
    ((SELECT "recipeID" FROM "recipe" WHERE "recipeID" = 2), 3, 'Once pasta is done, add to sauce bowl, along with the cooked guanciale and some of the rendered fat. Stir over the pot that you used to cook the pasta in a double boiler fashion until the sauce has thickened up. Once the sauce is thickened up without scrambling, serve.');
