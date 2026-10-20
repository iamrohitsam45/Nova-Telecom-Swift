import SwiftUI

public struct ProductCategoryFilter: View {
    @Binding public var selectedCategory: ProductCategory?

    public init(selectedCategory: Binding<ProductCategory?>) {
        self._selectedCategory = selectedCategory
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All Hardware" Pill
                Button(action: {
                    HapticFeedback.light()
                    withAnimation { selectedCategory = nil }
                }) {
                    Text("All Hardware")
                        .font(TelecomTypography.captionMedium)
                        .fontWeight(selectedCategory == nil ? .bold : .medium)
                        .foregroundColor(selectedCategory == nil ? .white : TelecomColors.neutralMuted)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            selectedCategory == nil
                            ? TelecomColors.electricBlue
                            : Color.white.opacity(0.06)
                        )
                        .clipShape(Capsule())
                }

                // Individual Category Pills
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    let isSelected = selectedCategory == category

                    Button(action: {
                        HapticFeedback.light()
                        withAnimation { selectedCategory = category }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: category.iconName)
                                .font(.system(size: 12))
                            Text(category.displayName)
                                .font(TelecomTypography.captionMedium)
                                .fontWeight(isSelected ? .bold : .medium)
                        }
                        .foregroundColor(isSelected ? .white : TelecomColors.neutralMuted)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            isSelected
                            ? TelecomColors.electricBlue
                            : Color.white.opacity(0.06)
                        )
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
