import Foundation

extension NSDate {
    
    public var timeAgo: String {
        let components = self.dateComponents()
        
        if components.year > 0 {
            if components.year < 2 {
                return "Last year"
            } else {
                return String(format: "%@ years ago", arguments: [String(components.year)])
            }
        }
        
        if components.month > 0 {
            if components.month < 2 {
                return "Last month"
            } else {
                return String(format: "%@ months ago", arguments: [String(components.month)])
            }
        }
        
        // TODO: localize for other calanders
        if components.day >= 7 {
            let week = components.day/7
            if week < 2 {
                return "Last week"
            } else {
                return String(format: "%@ weeks ago", arguments: [String(week)])
            }
        }
        
        if components.day > 0 {
            if components.day < 2 {
                return "Yesterday"
            } else  {
                return String(format: "%@ days ago", arguments: [String(Double(components.day))])
            }
        }
        
        if components.hour > 0 {
            if components.hour < 2 {
                return "An hour ago"
            } else  {
                return String(format: "%@ hours ago", arguments: [String(components.hour)])
            }
        }
        
        if components.minute > 0 {
            if components.minute < 2 {
                return "A minute ago"
            } else {
                return String(format: "%@ minutes ago", arguments: [String(components.minute)])
            }
        }
        
        if components.second > 0 {
            if components.second < 5 {
                return "Just now"
            } else {
                return String(format: "%@ seconds ago", arguments: [String(Double(components.second))])
            }
        }
        
        return ""
    }
    
    private func dateComponents() -> NSDateComponents {
        let calander = NSCalendar.currentCalendar()
        return calander.components([.Second, .Minute, .Hour, .Day, .Month, .Year], fromDate: self, toDate: NSDate(), options: [])
    }
    
    
}
