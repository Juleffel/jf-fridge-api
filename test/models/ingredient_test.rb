require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  test_recipe = {
    "author"=>"jules_13877489",
    "rate"=>"5",
    "difficulty"=>"facile",
    "budget"=>"bon marché",
    "prep_time"=>"30 min",
    "total_time"=>"50 min",
    "people_quantity"=>"6",
    "author_tip"=>"",
    "ingredients"=> [
      "1kg de penne ou tout autres pâtes en forme de tubes",
      "1 chorizo fort",
      "3 poivrons (1rouge, 1jaune et 1 vert pour la couleur)",
      "115cl de vin blanc sec",
      "30g de parmesan râpé",
      "2 oignons",
      "3pincées de herbes de Provence",
      "2pincées d'origan",
      "2pincées de piment d’Espelette",
      "10cl de crème fraîche",
      "6 tomates fraiches",
      "30cl de coulis de tomate",
      "Sel",
      "Poivre",
    ],
    "name"=>"Pâtes faciles aux poivrons, chorizo et parmesan",
    "tags"=>["Pâtes, riz, semoule", "Plat principal", "Autres pâtes"],
    "image"=>"",
    "nb_comments"=>"3",
    "cook_time"=>"20 min",
  }
  test "load recipes" do
    assert(Ingredient::RECIPES.count >= 1)
  end
  test "find_best_matches" do
    assert(Ingredient::RECIPES.count >= 1)
    assert_equal(
      Ingredient.find_best_matches(["Tomates", "Oignons", "Crème", "Lardons", "Mozarella", "Pâtes"]).map {|e| e[:recipe]["name"]},
      ["Pâtes faciles aux poivrons, chorizo et parmesan", "Spaghettis aux crevettes de Manou",
        "Chicken pie ( tourte au poulet ) à l'oignon", "Pâtes sauce fruitée aux trois fromages", "Pâtes safranées aux gambas"])
  end

  test "find_ingredients_in_recipe" do
    # "Lapin" and "chêvre" are not in the original recipe
    assert_equal(Ingredient.find_ingredients_in_recipe(
      [
        "pâtes",
        "chorizo",
        "lapin",
        "poivron",
        "chêvre",
      ],
      test_recipe,
    ), [
      "pâtes",
      "chorizo",
      "poivron",
    ])
    # "Tomate" is mentionned twice in original recipe but should be counted only once
    assert_equal(Ingredient.find_ingredients_in_recipe(
      [
        "tomate",
      ],
      test_recipe,
    ), [
      "tomate",
    ])
  end

  test "find_recipe_ingredients" do
    # "Lapin" and "chêvre" are not in the original recipe
    assert_equal(Ingredient.find_recipe_ingredients(
      [
        "pâtes",
        "chorizo",
        "lapin",
        "poivron",
        "chêvre",
      ],
      test_recipe,
    ), [
      "1kg de penne ou tout autres pates en forme de tubes",
      "1 chorizo fort",
      "3 poivrons (1rouge, 1jaune et 1 vert pour la couleur)",
    ])
    # "Tomate" is mentionned twice in original recipe and this method should return them both
    assert_equal(Ingredient.find_recipe_ingredients(
      [
        "tomate",
      ],
      test_recipe,
    ), [
      "6 tomates fraiches",
      "30cl de coulis de tomate",
    ])
  end

  test "recipe_has_all_ingredients?" do
    # All ingredients should be there
    assert(Ingredient.recipe_has_all_ingredients?(
      [
        "pâtes",
        "chorizo",
        "poivron",
        "vin blanc",
        "parmesan",
        "oignons",
        "herbes de Provence",
        "origan",
        "piment d’espelette",
        "crème fraîche",
        "tomates fraiches",
        "coulis de tomate",
        "Sel",
        "Poivre",
      ],
      test_recipe,
    ))
    # "Poivre" is absent
    assert(!Ingredient.recipe_has_all_ingredients?(
      [
        "pâtes",
        "chorizo",
        "poivron",
        "vin blanc",
        "parmesan",
        "oignons",
        "herbes de Provence",
        "origan",
        "piment d’espelette",
        "crème fraîche",
        "tomates fraiches",
        "coulis de tomate",
        "Sel",
      ],
      test_recipe,
    ))
  end


  test "find_recipes_with_all_ingredients" do
    # All ingredients of test_recipe are here and it should be found
    assert_equal(
      Ingredient.find_recipes_with_all_ingredients([
        "pâtes",
        "chorizo",
        "poivron",
        "vin blanc",
        "parmesan",
        "oignons",
        "herbes de Provence",
        "origan",
        "piment d’espelette",
        "crème fraîche",
        "tomates fraiches",
        "coulis de tomate",
        "Sel",
        "Poivre",
      ])[0],
      test_recipe,
    )
    # Even with one more ingredient, it should be found
    assert_equal(
      Ingredient.find_recipes_with_all_ingredients([
        "pâtes",
        "chorizo",
        "poivron",
        "vin blanc",
        "parmesan",
        "oignons",
        "herbes de Provence",
        "origan",
        "piment d’espelette",
        "crème fraîche",
        "tomates fraiches",
        "coulis de tomate",
        "Sel",
        "Poivre",
        "Chêvre"
      ])[0],
      test_recipe,
    )
    # "Sel" and "Poivre" are absent
    assert_equal(
      Ingredient.find_recipes_with_all_ingredients([
        "pâtes",
        "chorizo",
        "poivron",
        "vin blanc",
        "parmesan",
        "oignons",
        "herbes de Provence",
        "origan",
        "piment d’espelette",
        "crème fraîche",
        "tomates fraiches",
        "coulis de tomate",
      ]).length,
      0,
    )
  end
end
