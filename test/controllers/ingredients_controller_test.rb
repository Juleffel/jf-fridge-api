require 'test_helper'
require 'json'

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ingredient = ingredients(:one)
  end

  test "should get index" do
    get ingredients_url, as: :json
    assert_response :success
  end

  test "should create ingredient" do
    assert_difference('Ingredient.count') do
      post ingredients_url, params: { ingredient: { name: @ingredient.name } }, as: :json
    end

    assert_response 201
  end

  test "should show ingredient" do
    get ingredient_url(@ingredient), as: :json
    assert_response :success
  end

  test "should update ingredient" do
    patch ingredient_url(@ingredient), params: { ingredient: { name: @ingredient.name } }, as: :json
    assert_response 200
  end

  test "should destroy ingredient" do
    assert_difference('Ingredient.count', -1) do
      delete ingredient_url(@ingredient), as: :json
    end

    assert_response 204
  end

  ##########
  ## RECIPES METHODS
  ##########
  test "should return matching recipes" do
    Ingredient.delete_all
    Ingredient.create(name: "Tomates")
    Ingredient.create(name: "Oignons")
    Ingredient.create(name: "Crème")
    Ingredient.create(name: "Lardons")
    Ingredient.create(name: "Mozarella")
    Ingredient.create(name: "Pâtes")
    get matching_recipes_ingredients_url, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal(
      body.map {|e| e["recipe"]["name"]},
      ["Pâtes faciles aux poivrons, chorizo et parmesan", "Spaghettis aux crevettes de Manou",
        "Chicken pie ( tourte au poulet ) à l'oignon", "Pâtes sauce fruitée aux trois fromages", "Pâtes safranées aux gambas"])
  end

  test "should return full matching recipes" do
    Ingredient.delete_all
    Ingredient.create(name: "Pâtes")
    Ingredient.create(name: "Chorizo")
    Ingredient.create(name: "Poivron")
    Ingredient.create(name: "Vin blanc")
    Ingredient.create(name: "Parmesan")
    Ingredient.create(name: "Oignons")
    Ingredient.create(name: "Herbes de Provence")
    Ingredient.create(name: "Origan")
    Ingredient.create(name: "Piment d’espelette")
    Ingredient.create(name: "Crème fraîche")
    Ingredient.create(name: "Tomates fraiches")
    Ingredient.create(name: "Coulis de tomate")
    get full_match_recipes_ingredients_url, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal(body.length, 0)

    Ingredient.create(name: "Sel")
    Ingredient.create(name: "Poivre")
    get full_match_recipes_ingredients_url, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal(body.length, 1)
    assert_equal(body[0]["name"], "Pâtes faciles aux poivrons, chorizo et parmesan")
  end
end
