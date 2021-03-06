import XCTest
@testable import GiniVision

class CameraViewControllerTests: XCTestCase {
    
    var vc = CameraViewController(success: { _ in }, failure: { _ in })
    
    func testInitialization() {
        XCTAssertNotNil(vc, "view controller should not be nil")
    }
    
    func testCameraOverlayAccessibility() {
        XCTAssertNotNil(vc.cameraOverlay, "camera overlay should be accessible and not nil")
    }
    
}

