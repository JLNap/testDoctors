import SwiftUI

struct Header: View {
    var title: String
    var action: () -> Void
    var isMain: Bool
    var body: some View {
        HStack {
            if !isMain {
                Button(action: action) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundStyle(.secFontCol)
                }
            }
            Spacer()
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.black)
            Spacer()
        }
    }
}

struct SortBtn: View {
    var action: () -> Void
    var sortName: DoctorSort
    var text: String
    var image: String
    var bgCol: Color
    var foreground: Color
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.subheadline)
                if !image.isEmpty {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 10)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .foregroundStyle(foreground)
            .background(bgCol)
            .overlay(
               Rectangle()
                   .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

enum DoctorSort: String, CaseIterable, Identifiable {
    case price = "По цене"
    case seniority = "По стажу"
    case rating = "По рейтингу"

    var id: String { self.rawValue }
}

enum SortDirection: String, CaseIterable, Identifiable {
    case ascending = "По возрастанию"
    case descending = "По убыванию"

    var id: String { self.rawValue }
}

struct SortButtonConfig {
    let sort: DoctorSort
    let label: String
}

struct SearchSort: View {
    @ObservedObject var vm: MainVM
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Поиск", text: $vm.text)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
            
            HStack(spacing: 0) {
                ForEach(vm.sortConfigs, id: \.sort) { config in
                    vm.sortButton(for: config)
                }
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                   .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct DocAvatar: View {
    var data: Doctor
    
    var body: some View {
        if let avatarURL =  data.avatar, let url = URL(string: avatarURL) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
        }
    }
}

struct DocCell: View {
    var data: Doctor
    var isDisabled: Bool {
        data.minPrice == nil
    }
    @State var isFavorite = false
    @Binding var path: [Screen]
    var body: some View {
            VStack {
                HStack(alignment: .top, spacing: 16) {
                    DocAvatar(data: data)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(data.lastName) \(data.firstName) \(data.patronymic ?? "")")
                            .font(.system(size: 16, weight: .semibold))
                        StarRatingView(rating: Int((data.ratingsRating)?.rounded() ?? 0))
                        HStack(spacing: 2) {
                            Text(data.specialization.first?.name ?? "Врач")
                            Text(" •")
                            Text(" стаж \(data.seniority ?? 0) лет")
                        }
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.gray)
                        Text(data.minPriceText)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Spacer()
                    Button(action: { isFavorite.toggle() }){
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                    } .foregroundStyle(isFavorite ? .signUpTrue : .bgCol)
                }
                Spacer()
                SignUpBtn(action: {
                    path.append(.second(data))
                },
                          text: !isDisabled ? "Записаться" : "Нет свободного расписания",
                          bgCol: !isDisabled ? .signUpTrue : .bgCol,
                          textCol: !isDisabled ? .white : .black)
                .disabled(isDisabled)
            }   .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SignUpBtn: View {
    var action: () -> Void
    var text: String
    var bgCol: Color
    var textCol: Color
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(textCol)
                .frame(maxWidth: .infinity, minHeight: 47)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(bgCol)
                )
        }
    }
}

struct StarRatingView: View {
    let rating: Int
    var maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(index <= rating ? .rateStar : .unRateStar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            }
        }
    }
}


struct DoctorProfileHeader: View {
    let experienceYears: Int
    let category: String
    let education: String
    let clinic: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoRow(icon: "expImg", text: "Опыт работы: \(experienceYears) лет")
            InfoRow(icon: "categoryImg", text: category)
            InfoRow(icon: "educationImg", text: education)
            InfoRow(icon: "workPlaceImg", text: clinic)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
                .frame(width: 24, height: 24)
            Text(text)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.secFontCol)
        }
    }
}

struct PriceViewStack: View {
    var time: String
    var price: String
    
    var body: some View {
        HStack {
            Text(time)
                .font(.system(size: 16, weight: .regular))
            Spacer()
            Text(price)
                .font(.system(size: 16, weight: .semibold))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(.white)
            .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
