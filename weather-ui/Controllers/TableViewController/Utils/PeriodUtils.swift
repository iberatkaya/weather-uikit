import Foundation

/// Group the `periods`where the first index of sublist can either be day or night. If first index of sublist item is
/// the day temperature, the second index is the night temperature.
func groupPeriodsByDate(_ periods: [Period]) -> [[Period]] {
    var myPeriods: [[Period]] = []
    var shouldSkip = false
    for p in periods {
        if shouldSkip {
            shouldSkip = false
            continue
        }
        var arr = [p]
        let item = periods.first(where: {
            if let startTimeA = p.startTime, let startTimeB = $0.startTime {
                return Calendar.current.isDate(startTimeA, inSameDayAs: startTimeB) && !Calendar.current.isDate(startTimeA, equalTo: startTimeB, toGranularity: .second)
            }
            return false
        })

        if let item = item {
            arr.append(item)
            shouldSkip = true
        }
        myPeriods.append(arr)
    }

    return myPeriods
}
