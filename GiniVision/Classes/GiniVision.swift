//
//  GiniVision.swift
//  GiniVision
//
//  Created by Peter Pult on 15/06/16.
//  Copyright © 2016 Gini GmbH. All rights reserved.
//

import UIKit

/**
 Delegate to inform the reveiver about the current status of the Gini Vision Library.
 Makes use of callbacks for handling incoming data and to control view controller presentation.
 
 - note: Screen API only.
 */
@objc public protocol GiniVisionDelegate {
    
    /**
     Called when the user has taken an image.
     
     - parameter imageData: JPEG image data including meta information.
     */
    func didCapture(_ imageData: Data)
    
    /**
     Called when the user has reviewed the image and potentially rotated it to the correct orientation.
     
     - parameter imageData: JPEG image data including eventually updated meta information.
     - parameter changes:   Indicates whether `imageData` was altered.
    */
    func didReview(_ imageData: Data, withChanges changes: Bool)
    
    /**
     Called when the user cancels capturing on the camera screen. Should be used to dismiss the presented view controller.
     */
    func didCancelCapturing()
    
    /**
     Called when the user navigates back from the review screen to the camera potentially to retake an image. Should be used to cancel any ongoing analysis task on the image.
     */
    @objc optional func didCancelReview()
    
    /**
     Called when the user is presented with the analsis screen. Use the `analysisDelegate` object to inform the user about the current status of the analysis task.
     
     - parameter analysisDelegate: The analsis delegate to send updates to.
     */
    @objc optional func didShowAnalysis(_ analysisDelegate: AnalysisDelegate)
    
    /**
     Called when the user navigates back from the analysis screen to the review screen. Should be used to cancel any ongoing analysis task on the image.
     */
    @objc optional func didCancelAnalysis()
    
}

/**
 Convenience class to interact with the Gini Vision Library.
 
 The Gini Vision Library provides views for capturing, reviewing and analysing documents.
 
 By integrating this library in your application you can allow your users to easily take a picture of a document, review it and - by implementing the necessary callbacks - upload the document for analysis to the Gini API.
 
 The Gini Vision Library can be integrated in two ways, either by using the **Screen API** or the **Component API**. The Screen API provides a fully pre-configured navigation controller for easy integration, while the Component API provides single view controllers for advanced integration with more freedom for customization.
 
 - important: When using the Component API we advise you to use a similar flow as suggested in the Screen API. Use the `CameraViewController` as an entry point with the `OnboardingViewController` presented on top of it. After capturing let the user review the document with the `ReviewViewController` and finally present the `AnalysisViewController` while the user waits for the analysis results.
 */
@objc public final class GiniVision: NSObject {
    
    /**
     Sets a configuration which is used to customize the look and feel of the Gini Vision Library,
     for example to change texts and colors displayed to the user.
     
     - parameter configuration: The configuration to set.
     */
    public class func setConfiguration(_ configuration: GiniConfiguration) {
        if configuration.debugModeOn {
            print("GiniVision: Set mode to DEBUG (WARNING: Never make a release in DEBUG mode!)")
        }
        GiniConfiguration.sharedConfiguration = configuration // TODO: Make a copy to avoid changes during usage
    }
    
    /**
     Returns a navigation view controller with the camera screen loaded and ready to go. It's the easiest way to get started with the Gini Vision Library as it comes pre-configured and handles all screens and transitions out of the box.
     
     - note: Screen API only.
     
     - parameter delegate: An instance conforming to the `GiniVisionDelegate` protocol.
     
     - returns: A presentable navigation view controller.
     */
    public class func viewController(withDelegate delegate: GiniVisionDelegate) -> UIViewController {
        let cameraContainerViewController = CameraContainerViewController()
        let navigationController = GiniNavigationViewController(rootViewController: cameraContainerViewController)
        navigationController.giniDelegate = delegate
        return navigationController
    }
    
    /**
     Returns a navigation view controller with the camera screen loaded and ready to go. Allows to set a custom configuration to change the look and feel of the Gini Vision Library.
     
     - note: Screen API only.
     
     - parameter delegate:      An instance conforming to the `GiniVisionDelegate` protocol.
     - parameter configuration: The configuration to set.
     
     - returns: A presentable navigation view controller.
     */
    public class func viewController(withDelegate delegate: GiniVisionDelegate, withConfiguration configuration: GiniConfiguration) -> UIViewController {
        setConfiguration(configuration)
        return viewController(withDelegate: delegate)
    }
    
    /**
     Returns the current version of the Gini Vision Library. 
     If there is an error retrieving the version the returned value will be an empty string.
     */
    public static var versionString: String {
        return GiniVisionVersion
    }
}
