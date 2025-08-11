import SwiftUI

final class MainVM: ObservableObject {
    private let manager: NetworkProtocol
    @Published var text: String = ""
    @Published var doctors: [Doctor] = []
    @Published var selectedSort: DoctorSort = .price
    @Published var sortDirection: SortDirection = .ascending
    let sortButtons: [DoctorSort] = [.price, .seniority, .rating]
    let sortConfigs: [SortButtonConfig] = [
        SortButtonConfig(sort: .price, label: "По цене"),
        SortButtonConfig(sort: .seniority, label: "По стажу"),
        SortButtonConfig(sort: .rating, label: "По рейтингу")
    ]
    
    init(manager: NetworkProtocol) {
        self.manager = manager
    }
    
    func sortButton(for config: SortButtonConfig) -> some View {
        let isSelected = selectedSort == config.sort
        return SortBtn(
            action: { self.onSortTap(config.sort) },
            sortName: config.sort,
            text: config.label,
            image: selectedSort == config.sort ? directionArrow(for: config.sort) : "",
            bgCol: isSelected ? .signUpTrue : .white,
            foreground: isSelected ? .white : .black
        )
    }
    
    func onSortTap(_ sort: DoctorSort) {
        if selectedSort == sort {
            sortDirection = sortDirection == .ascending ? .descending : .ascending
        } else {
            selectedSort = sort
            sortDirection = .ascending
        }
    }
    
    func directionArrow(for sort: DoctorSort) -> String {
        if selectedSort == sort {
            return sortDirection == .ascending ? "arrow.up" : "arrow.down"
        } else {
            return "arrow.down"
        }
    }
    var sortedDoctors: [Doctor] {
        let lowercasedText = text.lowercased()

        let filtered = doctors.filter { doctor in
            let fullName = [
                doctor.lastName,
                doctor.firstName,
                doctor.patronymic ?? ""
            ].joined(separator: " ").lowercased()
            
            let specialization = doctor.specialization.first?.name.lowercased() ?? ""
            
            return lowercasedText.isEmpty
                || fullName.contains(lowercasedText)
                || specialization.contains(lowercasedText)
        }

        let sorted: [Doctor]
        switch selectedSort {
        case .price:
            sorted = filtered.sorted { ($0.videoChatPrice ?? 0) < ($1.videoChatPrice ?? 0) }
        case .seniority:
            sorted = filtered.sorted { ($0.seniority ?? 0) < ($1.seniority ?? 0) }
        case .rating:
            sorted = filtered.sorted { ($0.ratingsRating ?? 0) < ($1.ratingsRating ?? 0) }
        }
        return sortDirection == .ascending ? sorted : sorted.reversed()
    }

    func fetchDoctors() {
        if let response: RootResponse = manager.loadJSONFromBundle("test", as: RootResponse.self) {
            DispatchQueue.main.async {
                self.doctors = response.data.users
            }
        } else {
            print("Не удалось загрузить докторов")
        }
    }
}
