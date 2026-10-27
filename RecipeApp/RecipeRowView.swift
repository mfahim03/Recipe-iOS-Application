import SwiftUI
import UIKit

struct RecipeRowView: View {
    let recipe: Recipe
    let onSelect: () -> RecipeDetailView
    let onFavoriteTap: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            NavigationLink {
                onSelect()
            } label: {
                HStack(spacing: 14) {
                    RecipeImageView(imageName: recipe.imageName, height: 76)
                        .frame(width: 92)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(recipe.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                        Text(recipe.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
            }

            Button(action: onFavoriteTap) {
                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(recipe.isFavorite ? .red : .secondary)
                    .frame(width: 40, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(recipe.isFavorite ? "Remove \(recipe.name) from favorites" : "Add \(recipe.name) to favorites")
        }
        .padding(.vertical, 3)
    }
}

/// Loads a photo from the app asset catalog through UIImage(named:). The symbol fallback
/// keeps the layout usable until matching recipe images are added to Assets.xcassets.
struct RecipeImageView: View {
    let imageName: String
    var height: CGFloat = 220

    var body: some View {
        Group {
            if let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(colors: [.orange.opacity(0.22), .pink.opacity(0.14)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(systemName: "fork.knife")
                        .font(.system(size: 34, weight: .light))
                        .foregroundStyle(.orange)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipped()
        .accessibilityLabel("Photo of \(imageName.replacingOccurrences(of: "-", with: " "))")
    }
}
