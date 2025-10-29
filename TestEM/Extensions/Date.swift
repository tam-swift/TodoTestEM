//
//  Date.swift
//  TestEM
//
//  Created by Tamerlan Swift on 26.10.2025.
//

import Foundation

extension Date {
    
    private var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    
    /// Converts a Date to a String
    /// ```
    /// Date() -> 26/10/25
    /// ```
    func dateFormatter() -> String {
        return fullDateFormatter.string(from: self)
    }
}
