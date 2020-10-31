require 'json'
require 'i18n'

class Ingredient < ApplicationRecord
    #######
    # Load recipes.json
    #######
    RECIPES = File.readlines('app/data/recipes.json').map(&:chomp).map do |line|
        begin
            JSON.parse(line)
        rescue => e
            p "JSON parse error!: #{line} => #{e}"
            nil
        end
    end

    #######
    # Returns the recipes which have the best match with `ingredients`,
    # Having the maximum of ingredients from their recipes found in the list
    #######
    def self.find_best_matches ingredients, limit = 5
        noted_recipes = RECIPES.map do |recipe|
            if !recipe then return nil end
            found_ingredients_in_recipe = self.find_ingredients_in_recipe(ingredients, recipe)
            found_recipe_ingredients = self.find_recipe_ingredients(ingredients, recipe)
            rate = recipe["rate"].to_f
            match_note = found_ingredients_in_recipe.count * rate
            {
                recipe: recipe,
                found_ingredients_in_recipe: found_ingredients_in_recipe,
                found_recipe_ingredients: found_recipe_ingredients,
                rate: rate,
                match_note: match_note
            }
        end.sort_by {|e| e[:match_note]}
        return noted_recipes.last(limit).reverse
    end

    #######
    # Returns the ingredients of `recipe` found in `ingredients`
    # An ingredient is found if its downcased version in found in the recipe ingredient
    #######
    def self.find_recipe_ingredients ingredients, recipe
        recipe_ingredients = recipe["ingredients"].map {|s| self.normalize(s)}
        recipe_ingredients.inject([]) do |found_ingredients, recipe_ingredient|
            found = ingredients.find do |ingredient|
                recipe_ingredient.include? self.normalize(ingredient)
            end
            found ? found_ingredients + [recipe_ingredient] : found_ingredients
        end
    end

    #######
    # Returns the `ingredients` found in ingredients of `recipe`
    # An ingredient is found if its downcased version in found in the recipe ingredient
    #######
    def self.find_ingredients_in_recipe ingredients, recipe
        recipe_ingredients = recipe["ingredients"].map {|s| self.normalize(s)}
        ingredients.inject([]) do |found_ingredients, ingredient|
            found = recipe_ingredients.find do |recipe_ingredient|
                recipe_ingredient.include? self.normalize(ingredient)
            end
            found ? found_ingredients + [ingredient] : found_ingredients
        end
    end

    #######
    # Returns the recipes which have all their ingredients into `ingredients`
    #######
    def self.find_recipes_with_all_ingredients ingredients, limit = 5
        noted_recipes = RECIPES.select do |recipe|
            self.recipe_has_all_ingredients? ingredients, recipe
        end.sort_by {|e| e["rate"].to_f}
        return noted_recipes.last(limit).reverse
    end

    #######
    # Returns true if all `recipe` ingredients are found in `ingredients`
    # An ingredient is found if its downcased version in found in the recipe ingredient
    #######
    def self.recipe_has_all_ingredients? ingredients, recipe
        if !recipe then return false end
        recipe_ingredients = recipe["ingredients"].map {|s| self.normalize(s)}
        recipe_ingredients.all? do |recipe_ingredient|
            ingredients.detect do |ingredient|
                recipe_ingredient.include? self.normalize(ingredient)
            end
        end
    end


    #####
    ## HELPERS
    #####
    # https://stackoverflow.com/a/15696883
    def self.normalize(str)
        I18n.transliterate(str).downcase
    end
end