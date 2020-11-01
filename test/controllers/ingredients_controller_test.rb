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
    ingredients = ["Tomates", "Oignons", "Crème", "Lardons", "Mozarella", "Pâtes"]
    post matching_recipes_url, params: { ingredients: ingredients }, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal(
      ["Pâtes faciles aux poivrons, chorizo et parmesan", "Spaghettis aux crevettes de Manou",
        "Chicken pie ( tourte au poulet ) à l'oignon", "Pâtes safranées aux gambas", "Pâtes sauce fruitée aux trois fromages"],
      body.map {|e| e["recipe"]["name"]})
  end

  test "should return full matching recipes" do
    Ingredient.delete_all
    ingredients = ["Pâtes", "Chorizo", "Poivron", "Vin blanc", "Parmesan", "Oignons", "Herbes de Provence", "Origan", "Piment d’espelette",
      "Crème fraîche", "Tomates fraiches", "Coulis de tomate"]
    post full_match_recipes_url, params: { ingredients: ingredients }, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal(0, body.length)

    ingredients += ["Sel", "Poivre"]
    post full_match_recipes_url, params: { ingredients: ingredients }, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal(1, body.length)
    assert_equal("Pâtes faciles aux poivrons, chorizo et parmesan", body[0]["name"])
  end
end
