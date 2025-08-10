import SwiftUI

struct SecondView: View {
    @Binding var path: [Screen]
    let doctor: Doctor
    var body: some View {
        ZStack(alignment: .top) {
            Color.bgCol.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Header(title: doctor.specialization.first?.name ?? "Врач", action: { path = [] }, isMain: false)
                HStack(spacing: 16) {
                    DocAvatar(data: doctor)
                    Text("\(doctor.lastName) \(doctor.firstName)")
                        .font(.title)
                    Spacer()
                }
                DoctorProfileHeader(
                    experienceYears: doctor.seniority ?? 0,
                    category: doctor.categoryFullName,
                    education: "1-й ММИ им. И.М.Сеченова",
                    clinic: "Детская клиника РебёнОК"
                )
                HStack {
                    Text("Стоимость услуг")
                    Spacer()
                    Text(doctor.minPriceText)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                Text("Проводит диагностику и лечение терапевтических больных. Осуществляет расшифровку и снятие ЭКГ. Дает рекомендации по диетологии. Доктор имеет опыт работы в России и зарубежом. Проводит консультации пациентов на английском языке.")
                    .font(.system(size: 14, weight: .regular))
                Spacer()
                SignUpBtn(action: { path.append(.price(doctor)) }, text: "Записаться", bgCol: .signUpTrue, textCol: .white)
            } .padding(16)
            .navigationBarHidden(true)
        }
    }
}

