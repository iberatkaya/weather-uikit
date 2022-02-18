import Foundation
import CoreLocation

extension CLLocationManager {
    func isAllowed() -> Bool {
        return (authorizationStatus == CLAuthorizationStatus.authorizedAlways || authorizationStatus == CLAuthorizationStatus.authorizedAlways)
    }
}
