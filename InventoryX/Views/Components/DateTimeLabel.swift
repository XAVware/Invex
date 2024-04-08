//
//  DateTimeLabel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.
//

import SwiftUI

struct DateTimeLabel: View {
    
    var dateString: String {
        let date = Date.now
        var string: String = ""
        let weekday = date.formatted(.dateTime.weekday(.wide))
        string.append("\(weekday), ")
        let monthAndDay = "\(Date.now.formatted(.dateTime.month(.wide).day(.defaultDigits)))"
        string.append(monthAndDay)
        return string
    }
    
    var body: some View {
        VStack {
            Text("\(Date.now.formatted(date: .omitted, time: .shortened))")
                .font(.system(size: 84))
                .fontWeight(.bold)
            
            Text(dateString)
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    DateTimeLabel()
}
