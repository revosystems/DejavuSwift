import SwiftUI
import UIKit

@available(iOS 15.0, *)
public struct DejavuSelectorView<Item: Equatable & Identifiable>: View {
    
    // MARK: - Properties
    
    let allItems: [Item]
    
    @State var selectedItem: Item?
    
    let title: String
    
    let titleBlock: (Item) -> String
    
    let iconBlock: ((Item) -> String?)?
    
    let leftIconBlock: ((Item) -> String?)?
    
    let onSelection: (Item) -> Void
    
    let searchFilter: ((Item, String) -> Bool)?
    
    let searchPlaceholder: String?
    
    let selectedRowColor: Color
    
    // MARK: - State
    
    @State private var searchText: String = ""
    @SwiftUI.Environment(\.dismiss) private var dismiss
    @SwiftUI.Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Computed Properties
    
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return allItems
        }
        
        if let searchFilter {
            return allItems.filter { searchFilter($0, searchText) }
        }
        
        return allItems.filter {
            titleBlock($0).lowercased().contains(searchText.lowercased())
        }
    }
    
    private var shouldShowBackButton: Bool {
        guard isIpad(),
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return false
        }
        
        if let navController = findNavigationController(in: rootVC),
           navController.viewControllers.count > 1 {
            if navController.viewControllers.contains(where: { $0 is UIHostingController<DejavuSelectorView<Item>> }) {
                return true
            }
        }
        
        return false
    }
    
    private func findNavigationController(in viewController: UIViewController) -> UINavigationController? {
        if let nav = viewController as? UINavigationController {
            return nav
        }
        for child in viewController.children {
            if let nav = findNavigationController(in: child) {
                return nav
            }
        }
        return nil
    }
    
    public init(
        items: [Item],
        selected: Item? = nil,
        title: String,
        titleBlock: @escaping (Item) -> String,
        iconBlock: ((Item) -> String?)? = nil,
        leftIconBlock: ((Item) -> String?)? = nil,
        searchFilter: ((Item, String) -> Bool)? = nil,
        searchPlaceholder: String? = nil,
        selectedRowColor: Color? = nil,
        onSelection: @escaping (Item) -> Void
    ) {
        self.allItems = items
        self.selectedItem = selected
        self.title = title
        self.titleBlock = titleBlock
        self.iconBlock = iconBlock
        self.leftIconBlock = leftIconBlock
        self.searchFilter = searchFilter
        self.searchPlaceholder = searchPlaceholder
        self.selectedRowColor = selectedRowColor ?? .blue
        self.onSelection = onSelection
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                
                if filteredItems.isEmpty {
                    emptyStateView
                } else {
                    itemsList
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var searchBar: some View {
        SearchBar(
            text: $searchText,
            placeholder: searchPlaceholder,
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var itemsList: some View {
        List(filteredItems) { item in
            let isSelected = item == selectedItem
            SelectorRow(
                title: titleBlock(item),
                iconName: iconBlock?(item),
                leftIconName: leftIconBlock?(item),
                isSelected: isSelected,
                selectedRowColor: selectedRowColor
            )
            .onTapGesture {
                handleSelection(item)
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(__("noResults"))
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        if shouldShowBackButton {
            Button(action: {
                if let topVC = findTopViewController() {
                    topVC.dismiss(animated: true)
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Back")
                    .foregroundColor(.primary)
            }
        }
    }
    
    // MARK: - Actions
    
    private func handleSelection(_ item: Item) {
        selectedItem = item
        onSelection(item)
        DispatchQueue.main.async {
            if let topVC = findTopViewController() {
                topVC.dismiss(animated: true)
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func findTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return nil
        }
        
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        return topVC
    }
}

// MARK: - SelectorRow

private struct SelectorRow: View {
    let title: String
    let iconName: String?
    let leftIconName: String?
    let isSelected: Bool
    let selectedRowColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            if let leftIconName {
                imageFor(leftIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.secondary)
            }
            
            if let iconName {
                imageFor(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(selectedRowColor)
                    .font(.body.weight(.semibold))
            }
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .listRowBackground(isSelected ? selectedRowColor.opacity(0.1) : Color.clear)
    }
}

// MARK: - Preview Helpers
struct PreviewItem: Equatable, Identifiable {
    let id: Int
    let name: String
    let iconName: String?
    
    static func == (lhs: PreviewItem, rhs: PreviewItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct SelectorView_Previews: PreviewProvider {
    static var previews: some View {
        let items: [PreviewItem] = [
            PreviewItem(id: 1, name: "Apple", iconName: "apple.logo"),
            PreviewItem(id: 2, name: "Banana", iconName: nil),
            PreviewItem(id: 3, name: "Cherry", iconName: "leaf.fill"),
            PreviewItem(id: 4, name: "Date", iconName: nil),
            PreviewItem(id: 5, name: "Elderberry", iconName: "star.fill")
        ]
        
        if #available(iOS 15.0, *) {
            DejavuSelectorView(
                items: items,
                selected: items[2],
                title: "Select Fruit",
                titleBlock: { $0.name },
                iconBlock: { $0.iconName },
                onSelection: {
                    print("Selected: \($0.name)")
                }
            )
        }
    }
}

