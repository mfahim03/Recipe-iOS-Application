import SwiftUI
import UIKit

struct Recipe: Identifiable, Equatable {
    let id: UUID
    var name: String
    var imageName: String
    var description: String
    var ingredients: [String]
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        name: String,
        imageName: String,
        description: String,
        ingredients: [String],
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.description = description
        self.ingredients = ingredients
        self.isFavorite = isFavorite
    }
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var recipes = Recipe.samples

    private var filteredRecipes: [Recipe] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return recipes
        }
        return recipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText)
                || recipe.ingredients.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredRecipes) { recipe in
                    RecipeRowView(recipe: recipe, onSelect: {
                        RecipeDetailView(recipe: recipe) { isFavorite in
                            updateFavorite(for: recipe.id, isFavorite: isFavorite)
                        }
                    }) {
                        toggleFavorite(for: recipe.id)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
            }
            .listStyle(.plain)
            .navigationTitle("My Recipes")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search recipes or ingredients")
            .overlay {
                if filteredRecipes.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
    }

    private func toggleFavorite(for id: UUID) {
        guard let index = recipes.firstIndex(where: { $0.id == id }) else { return }
        recipes[index].isFavorite.toggle()
    }

    private func updateFavorite(for id: UUID, isFavorite: Bool) {
        guard let index = recipes.firstIndex(where: { $0.id == id }) else { return }
        recipes[index].isFavorite = isFavorite
    }
}

private extension Recipe {
    static let samples: [Recipe] = [
        Recipe(name: "Creamy Tomato Pasta", imageName: "tomato-pasta", description: "A cozy, silky tomato pasta with garlic, basil, and a touch of cream. Ready in about 30 minutes.", ingredients: ["Pasta", "Cherry tomatoes", "Garlic", "Heavy cream", "Fresh basil", "Parmesan"]),
        Recipe(name: "Avocado Toast", imageName: "avocado-toast", description: "Crisp sourdough topped with creamy avocado, lemon, chili flakes, and herbs.", ingredients: ["Sourdough bread", "Ripe avocado", "Lemon", "Chili flakes", "Fresh herbs"]),
        Recipe(name: "Lemon Herb Salmon", imageName: "lemon-salmon", description: "Tender oven-roasted salmon brightened with lemon, olive oil, and fresh herbs.", ingredients: ["Salmon fillets", "Lemon", "Olive oil", "Dill", "Garlic"]),
        Recipe(name: "Berry Pancakes", imageName: "berry-pancakes", description: "Fluffy buttermilk pancakes folded with berries and served with warm maple syrup.", ingredients: ["Flour", "Buttermilk", "Egg", "Blueberries", "Maple syrup"]),
        Recipe(name: "Roasted Vegetable Bowl", imageName: "vegetable-bowl", description: "A colorful grain bowl with roasted seasonal vegetables and a lemon tahini dressing.", ingredients: ["Quinoa", "Sweet potato", "Chickpeas", "Kale", "Tahini", "Lemon"]),
        Recipe(name: "Classic Margherita Pizza", imageName: "margherita-pizza", description: "A simple, crisp pizza topped with tomato, mozzarella, and fragrant basil.", ingredients: ["Pizza dough", "Tomato sauce", "Mozzarella", "Fresh basil", "Olive oil"])
    ]
}

#Preview {
    ContentView()
}
