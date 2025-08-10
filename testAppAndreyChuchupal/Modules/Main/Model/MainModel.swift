import Foundation

struct RootResponse: Decodable {
    let count: Int
    let previous: String?
    let message: String
    let errors: String?
    let data: UsersResponse
}

struct UsersResponse: Decodable {
    let users: [Doctor]
}

struct Doctor: Decodable, Identifiable, Hashable {
    let id: String
    let slug: String?
    let firstName: String
    let patronymic: String?
    let lastName: String
    let genderLabel: String?
    let specialization: [DoctorSpecialization]
    let ratings: [DoctorRating]
    let ratingsRating: Double?
    let seniority: Int?
    let textChatPrice: Int?
    let videoChatPrice: Int?
    let homePrice: Int?
    let hospitalPrice: Int?
    let avatar: String?
    let rankLabel: String?
    let scientificDegreeLabel: String?
    let categoryLabel: String?
    var categoryFullName: String {
        switch categoryLabel?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "высшая":
            return "Врач высшей категории"
        case "первая":
            return "Врач первой категории"
        case "вторая":
            return "Врач второй категории"
        case "средняя":
            return "Врач средней категории"
        default:
            return "Категория врача не указана"
        }
    }
    let isFavorite: Bool
    let higherEducation: [HigherEducation]?
    let workExpirience: [WorkExpirience]?

    var minPrice: Int? {
        let prices: [Int?] = [textChatPrice, videoChatPrice, homePrice, hospitalPrice]
        let validPrices = prices.compactMap { $0 }.filter { $0 > 0 }
        return validPrices.min()
    }

    var minPriceText: String {
        minPrice.map { "от \($0) ₽" } ?? "Не принимает"
    }

    var isBookable: Bool {
        minPrice != nil
    }

    enum CodingKeys: String, CodingKey, Hashable {
        case id, slug
        case firstName = "first_name"
        case patronymic
        case lastName = "last_name"
        case genderLabel = "gender_label"
        case specialization
        case ratings
        case ratingsRating = "ratings_rating"
        case seniority
        case textChatPrice = "text_chat_price"
        case videoChatPrice = "video_chat_price"
        case homePrice = "home_price"
        case hospitalPrice = "hospital_price"
        case avatar
        case rankLabel = "rank_label"
        case scientificDegreeLabel = "scientific_degree_label"
        case categoryLabel = "category_label"
        case isFavorite = "is_favorite"
        case higherEducation = "higher_education"
        case workExpirience = "work_expirience"
    }
}

struct HigherEducation: Decodable, Hashable {
    let university: String?
    let specialization: String?
    let qualification: String?
}

struct WorkExpirience: Decodable, Hashable {
    let organization: String?
    let position: String?
}

struct DoctorSpecialization: Decodable, Hashable {
    let id: Int
    let name: String
    let isModerated: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case isModerated = "is_moderated"
    }
}

struct DoctorRating: Decodable, Hashable {
    let id: Int
    let name: String
    let value: Double
}
