//
//  Home.swift
//  ezitinerary
//
//  Created by Alfredo Junio on 26/04/22.
//

import SwiftUI
import CoreData

struct Home: View {
    @StateObject var tripModel: TripActivityViewModel = TripActivityViewModel()
    @Namespace var animation
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.actDate, order: .reverse)]) var tripAct:FetchedResults<TripActivity>
    
    // Core data context
    @Environment(\.managedObjectContext) var context
    
    // Edit button context
    @Environment(\.editMode) var editButton
    
    // Dark/Light Mode
    @Environment(\.colorScheme) var colorScheme
    
    // Calendar week stuff
    private let calendar: Calendar
    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    
    @State private var selectedDate = Self.now
    private static var now = Date()
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthDayFormatter = DateFormatter(dateFormat:"dd/MM", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "dd", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            //Lazy stack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    //Current week view
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        VStack {
                            CalendarWeekListView (
                                calendar: calendar,
                                date: $selectedDate,
                                content: { date in
                                    Button(action: {
                                        selectedDate = date
                                        tripModel.currentDay = date
                                    }) {
                                        VStack(spacing: 10) {
                                            Text(dayFormatter.string(from: date))
                                                .font(.system(size: 15)).fontWeight(.semibold)
                                                
                                                
                                            Text(weekDayFormatter.string(from: date))
                                                .font(.system(size: 14))
                                                
                                            
                                            Circle().fill(.white)
                                                .frame(width: 8, height: 8)
                                                .opacity(calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
                                        }
                                        // Foreground style
                                        .foregroundStyle(calendar.isDate(date, inSameDayAs: selectedDate)
                                                         ? .primary
                                                         : calendar.isDateInToday(date) ? .primary : .secondary)
                                        .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate)
                                                         ? .white
                                                         : calendar.isDateInToday(date)
                                                         ? secondC ?? .blue
                                                         : Color("DateColor")
                                                )
                                        
                                        // Capsule Shape
                                        .frame(width: 45, height: 90)
                                        .background(
                                            ZStack {
                                                // Geometry effect
                                                if tripModel.isToday(date: date) {
                                                    RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)).fill(primaryC ?? .white)
                                                        .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                                }
                                            }
                                        )
                                        .contentShape(Capsule())
                                        
//                                        Text("00")
//                                            .font(.system(size: 13))
//                                            .padding(8)
//                                            .foregroundColor(.clear)
//                                            .overlay(
//                                                Text(dayFormatter.string(from: date))
//                                                    .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate)
//                                                                     ? Color.black
//                                                                     : calendar.isDateInToday(date) ? .blue
//                                                                     : .gray
//                                                    )
//                                            )
//                                            .overlay(
//                                                Circle()
//                                                    .foregroundColor(.gray.opacity(0.38))
//                                                    .opacity(calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
//                                            )
                                    }
                                },
//                                header: { date in
//                                    Text("00")
//                                        .font(.system(size: 13))
//                                        .padding(8)
//                                        .foregroundColor(.clear)
//                                        .overlay(
//                                            Text(weekDayFormatter.string(from: date))
//                                                .font(.system(size: 15))
//                                        )
//                                },
                                title: { date in
                                    HStack {
                                        Text(monthDayFormatter.string(from: selectedDate))
                                            .font(.headline)
                                            .padding()
                                        Spacer()
                                    }
                                    .padding(.bottom, 6)
                                },
                                weekSwitcher: { date in
                                    Button {
                                        withAnimation {
                                            guard let newDate = calendar.date(
                                                byAdding: .weekOfMonth,
                                                value: -1,
                                                to: selectedDate
                                            ) else {
                                                return
                                            }
                                            
                                            tripModel.currentDay = newDate
                                            selectedDate = newDate
                                        }
                                    } label: {
                                        Label(
                                            title: { Text("Previous") },
                                            icon: { Image(systemName: "chevron.left") }
                                        )
                                        .foregroundColor(primaryC ?? .purple)
                                        .labelStyle(IconOnlyLabelStyle())
                                        .padding(.horizontal)
                                    }
                                    
                                    Button {
                                        withAnimation {
                                            guard let newDate = calendar.date(
                                                byAdding: .weekOfMonth,
                                                value: +1,
                                                to: selectedDate
                                            ) else {
                                                return
                                            }
                                            
                                            tripModel.currentDay = newDate
                                            selectedDate = newDate
                                        }
                                    } label: {
                                        Label(
                                            title: { Text("Next") },
                                            icon: { Image(systemName: "chevron.right") }
                                        )
                                        .foregroundColor(primaryC ?? .purple)
                                        .labelStyle(IconOnlyLabelStyle())
                                        .padding(.horizontal)
                                    }
                                }
                            )
                        }.padding(.horizontal)
//                        HStack(spacing: 10) {
//                            ForEach(tripModel.currentWeek, id: \.self) { day in
//                                VStack(spacing: 10) {
//                                    Text(tripModel.extractDate(date: day, format: "dd")).font(.system(size: 15)).fontWeight(.semibold)
//                                    Text(tripModel.extractDate(date: day, format: "EEE")).font(.system(size: 14))
//                                    Circle().fill(.white)
//                                        .frame(width: 8, height: 8)
//                                        .opacity(tripModel.isToday(date: day) ? 1 : 0)
//                                }
//                                // Foreground style
//                                .foregroundStyle(tripModel.isToday(date: day) ? .primary : .secondary)
//                                .foregroundColor(tripModel.isToday(date: day) ? .white : .black)
//                                // Capsule Shape
//                                .frame(width: 45, height: 90)
//                                .background(
//                                    ZStack {
//                                        // Geometry effect
//                                        if tripModel.isToday(date: day) {
//                                            RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)).fill(primaryC ?? .white)
//                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
//                                        }
//                                    }
//                                )
//                                .contentShape(Capsule())
//                                .onTapGesture {
//                                    withAnimation{
//                                        tripModel.currentDay = day
//                                    }
//                                }
//                            }
                            
//                            DynamicDateView() { (object: TripActivity) in
////                                if dateFilter != object.actDate {
//
//                                    VStack(spacing: 10) {
//                                        Text(tripModel.extractDate(date: object.actDate ?? Date(), format: "dd")).font(.system(size: 15)).fontWeight(.semibold)
//                                        Text(tripModel.extractDate(date: object.actDate ?? Date(), format: "EEE")).font(.system(size: 14))
//                                        Circle().fill(.white)
//                                            .frame(width: 8, height: 8)
//                                            .opacity(tripModel.isToday(date: object.actDate ?? Date()) ? 1 : 0)
//                                    }
//                                    // Foreground style
//                                    .foregroundStyle(tripModel.isToday(date: object.actDate ?? Date()) ? .primary : .secondary)
//                                    .foregroundColor(tripModel.isToday(date: object.actDate ?? Date()) ? .white : .black)
//                                    // Capsule Shape
//                                    .frame(width: 45, height: 90)
//                                    .background(
//                                        ZStack {
//                                            // Geometry effect
//                                            if tripModel.isToday(date: object.actDate ?? Date()) {
//                                                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)).fill(primaryC ?? .white)
//                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
//                                            }
//                                        }
//                                    )
//                                    .contentShape(Capsule())
//                                    .onTapGesture {
//                                        withAnimation{
//                                            tripModel.currentDay = object.actDate ?? Date()
//                                        }
//                                    }
////                                    }
//
//
//                            }
//                        }.padding(.horizontal)
                    }
                    
                    ActivityView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .top)
        
        // Add Button
        .overlay (
            Button(action: {
                tripModel.addNewActivity.toggle()
            }, label: {
                Label{
                    
                    Text("Add Activity")
                        .font(.callout)
                        .fontWeight(.semibold)

                
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                
            }).foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(primaryC ?? .black, in: Capsule())
            
            , alignment: .bottom
            
        ).sheet(isPresented: $tripModel.addNewActivity) {
            tripModel.editActivity = nil
        } content: {
            NewActivity().environmentObject(tripModel)
        }
    }
    
    // func total budget
    private func totalBudgetToday() -> Int {
        var budgetToday: Int = 0
        for item in tripAct {
            budgetToday += Int(item.actBudget)
        }
        return budgetToday
    }
    
    // Activities
    func ActivityView()->some View{
        LazyVStack(spacing: 20) {
            
            // Converting object to activity model
            DynamicFilteredView(dateToFilter: tripModel.currentDay) { (object: TripActivity) in
                ActCardView(activities: object)
                
            }
            
        }
        .padding()
        .padding(.top)
    }
    
    // Activity Card View
    func ActCardView(activities: TripActivity)->some View{
        
        // Since CoreData Values will Give Optimal Data
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top, spacing: 30){
            
            if editButton?.wrappedValue == .active {
                
                VStack(spacing: 10) {
                    if activities.actDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(activities.actDate ?? Date()) {
                        Button {
                            tripModel.editActivity = activities
                            tripModel.addNewActivity.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundColor(primaryC ?? .primary)
                        }
                    }
                    Button {
                        // Deleting Activity
                        context.delete(activities)
                        
                        // Saving
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                
            } else {
                VStack(spacing: 10) {
                    Circle().fill(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? (activities.isCompleted ? greenC ?? .green : secondC ?? .black) : .clear)
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .stroke(primaryC ?? .black, lineWidth: 1)
                                .padding(-3)
                        )
                        .scaleEffect(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? 0.8 : 1)
                    
                    Rectangle()
                        .fill(primaryC ?? .black)
                        .frame(width: 3)
                }
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 8){
                        Text(activities.actTitle ?? "").font(.title2.bold()).foregroundColor(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? .white : colorScheme == .dark ? .white : .black)
                        
                        Text(activities.actDesc ?? "").font(.callout).foregroundStyle(.secondary).foregroundColor(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? .white : colorScheme == .dark ? .white : .black)
                        
                        HStack (spacing: 15) {
                            !tripModel.isCurrentHour(date: activities.actDate ?? Date()) ?
                            Text("Rp. " + String(activities.actBudget)).font(.callout).foregroundStyle(.secondary).foregroundColor(colorScheme == .dark ? .white : .black) : nil
                            
                            HStack (spacing: 3) {
                                Image(systemName: "person.fill").foregroundColor(secondC ?? .white)
                                Text(!tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? String(activities.actTraveler) : !(activities.actTraveler > 1) ? String(activities.actTraveler) + " Traveler" : String(activities.actTraveler) + " Travelers").font(.callout).foregroundStyle( tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? .primary : .secondary)
                                    .foregroundColor(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? .white : colorScheme == .dark ? .white : .black)
                            }
                        }
                        
                    }
                    .hLeading()
                    
                    VStack (spacing: 8) {
                        Text(activities.actDate?.formatted(date: .omitted, time: .shortened) ?? "").foregroundColor(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? .white : colorScheme == .dark ? .white : .black)
                        Text(activities.actPrior ?? "").font(.callout).padding(.vertical, 5).padding(.horizontal, 5).foregroundColor(.white).background(Color(activities.actPrior == "Must do's" ? "ED6B6B" : activities.actPrior == "Like to do" ? "00B5BF" : "F4D90C") .cornerRadius(5))
                    }
                }
                
                if tripModel.isCurrentHour(date: activities.actDate ?? Date()) {
                    HStack(spacing: 0){
                        HStack(spacing: 10) {
                            Image(systemName: "newspaper.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            
                            Text("Rp. "+String(activities.actBudget)).font(.title2.bold())
                        }
                        .hLeading()
                        
                        // Check Button
                        if !activities.isCompleted {
                            Button {
                                // Updating status
                                activities.isCompleted = true
                                
                                // Saving
                                try? context.save()
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
//                        Text(activities.isCompleted ? "Marked as completed" : "Mark activity as completed")
//                            .font(.system(size: activities.isCompleted ? 14 : 16, weight: .light))
//                            .foregroundColor(activities.isCompleted ? .gray : .white)
//                            .hLeading()
                    }.padding(.top)
                }
                
            }
            .foregroundColor(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? .white : .black)
            .padding(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? 15 : 0)
            .padding(.bottom, tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background(
                Color("2F1C89")
                    .cornerRadius(25)
                    .opacity(tripModel.isCurrentHour(date: activities.actDate ?? Date()) ? 1 : 0)
            )
            
        }
        .hLeading()
        .onAppear() {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    // Header
    func HeaderView()->some View{
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted)).foregroundColor(.gray)
                
                Text("Itinerary Activities").font(.title2.bold())
                HStack {
                    Text("Total Travel Budget:")
                    Text("Rp. " + String(totalBudgetToday())).fontWeight(.bold).foregroundColor(secondC ?? .black)
                }
                
            }
            .hLeading()
            
            // Edit Button
            EditButton().accentColor(primaryC ?? .purple)
            
            
        }
        .padding()
        .padding(.top, getSafeArea().top)
    }
}

// Design helper function
extension View {
    func hLeading()->some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()->some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter()->some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    // Safe Area
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

struct CalendarWeekListView<Day: View, Title: View, WeekSwitcher: View>: View {
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let title: (Date) -> Title
    private let weekSwitcher: (Date) -> WeekSwitcher
    
    private let dayInWeek = 7
    
    init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder title: @escaping (Date) -> Title,
        @ViewBuilder weekSwitcher: @escaping (Date) -> WeekSwitcher
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.title = title
        self.weekSwitcher = weekSwitcher
    }
    
    var body: some View {
        
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        VStack {
            HStack {
                self.title(month)
                self.weekSwitcher(month)
            }.hLeading()
//            HStack (spacing: 30) {
//                ForEach(days.prefix(dayInWeek), id: \.self, content: header)
//            }
            HStack (spacing: 10) {
                ForEach(days, id: \.self) { date in
                    content(date)
                }
            }
            
            Divider()
            
        }
    }
}

private extension CalendarWeekListView {
    func makeDays() -> [Date] {
        guard let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: date),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: firstWeek.end-1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: firstWeek.start, end: lastWeek.end)
        
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates (
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) {date, _, stop in
            guard let date = date else { return }
            
            guard date < dateInterval.end else {
                stop = true
                return
            }
            
            dates.append(date)
        }
        return dates
    }
    
    func generateDays(
        for dateInterval: DateInterval
    ) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
        self.locale = Locale(identifier: "js_JP")
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Home(calendar: Calendar(identifier: .gregorian)).preferredColorScheme(.light)
            Home(calendar: Calendar(identifier: .gregorian)).preferredColorScheme(.dark)
        }
    }
}
