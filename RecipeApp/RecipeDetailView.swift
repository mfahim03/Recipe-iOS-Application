import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    let onFavoriteChange: (Bool) -> Void

    @State private var isFavorite: Bool

    init(recipe: Recipe, onFavoriteChange: @escaping (Bool) -> Void) {
        self.recipe = recipe
        self.onFavoriteChange = onFavoriteChange
        _isFavorite = State(initialValue: recipe.isFavorite)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RecipeImageView(imageName: recipe.imageName, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 12) {
                        Text(recipe.name)
                            .font(.largeTitle.bold())
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundStyle(isFavorite ? .red : .secondary)
                            .accessibilityHidden(true)
                    }
                    Text("Status: \(isFavorite ? "Favorited" : "Not favorited")")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isFavorite ? .red : .secondary)
                    Text(recipe.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingredients")
                        .font(.title2.bold())
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Label(ingredient, systemImage: "checkmark.circle")
                            .foregroundStyle(.primary)
                    }
                }

                Button {
                    isFavorite.toggle()
                    onFavoriteChange(isFavorite)
                } label: {
                    Label(isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: isFavorite ? "heart.fill" : "heart")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(isFavorite ? .red : .accentColor)
                .accessibilityHint("Current status: \(isFavorite ? "Favorited" : "Not favorited")")
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
