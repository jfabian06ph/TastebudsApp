//
//  RecipeGridItemView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeGridItemView: View {
    let recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            if let imageLink = recipe.imageLink, let url = URL(string: imageLink) {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
            } else {
                Image("webImagePlaceholder")
                       .resizable()
                       .scaledToFill()
                       .frame(height: 180)
                       .clipped()
            }

            // Bottom gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            ).frame(height: 150)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

            // Text content (VStack)
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)

                if let description = recipe.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }

                HStack {
                    if recipe.dietary.contains(.vegetarian) {
                        Text("🌱")
                    }
                    Spacer()
                    Text("\(recipe.servings) servings")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }.padding(12)
        }.frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}



#Preview {
    RecipeGridItemView(recipe: Recipe(id: "1",
                                      title: "Vegetarian Pasta",
                                      description: "A quick and healthy pasta dish.",
                                      servings: 2,
                                      ingredients: ["200g pasta",
                                                    "2 cloves garlic",
                                                    "1 cup cherry tomatoes",
                                                    "Olive oil"],
                                      instructions: ["Boil the pasta until al dente.",
                                                     "Sauté garlic in olive oil.",
                                                     "Add tomatoes and cook briefly.",
                                                     "Combine pasta and sauce."],
                                      dietary: [.vegetarian],
                                      imageLink: nil)
    ).padding()
}
