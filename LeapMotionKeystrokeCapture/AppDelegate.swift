//
//  AppDelegate.swift
//  LeapMotionKeystrokeCapture
//
//  Created by Aaron Rosen on 5/15/17.
//  Copyright © 2017 Aaron Rosen. All rights reserved.
//

import Cocoa
import Alamofire
import Dispatch

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let leapMotionWrapper = LeapMotionWrapper()
    let leapMotionController: LeapController = LeapController()
    let file: String = "data.csv"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        leapMotionController.addListener(self)
        leapMotionController.setPolicy(LEAP_POLICY_IMAGES)

        if acquirePrivileges() {
            NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
                // TODO: Don't record holding down a key as separate key events. Maybe use 
                // some sort of global `lastKeyCode` variable and only record from LeapMotion 
                // when `keyCode != lastKeyCode`.

                let keyCode = event.keyCode
                guard let frame = self.leapMotionController.frame(0) else { return }
                print("key pressed: \(keyCode)")

                let serialQueue = DispatchQueue(label: "keyRecorder")

                serialQueue.async {
                    // guard let serializedFrame = frame.serialize() else { return }

                    let frameImages = frame.images.flatMap { $0 as? LeapImage }
                    guard frameImages.count == 2 else {
                        print("WARNING: No Images!")
                        return
                    }
                    let leftImageData = self.extractData(frameImages[0])
                    let rightImageData = self.extractData(frameImages[1])

                    let imagesData = leftImageData + rightImageData
                    print("Total Image Data Size: \(imagesData.count)")

                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let path = dir.appendingPathComponent(self.file)

                        do {
//                            let data = imagesData
                            try "".write(to: path, atomically: false, encoding: String.Encoding.utf8)
                        }
                        catch {/* error handling here */}
                    }
                }
            }
        }
    }

    private func extractData(_ leapImage: LeapImage) -> Array<UInt8> {
        let pointerBuffer = UnsafeBufferPointer(
            start: leapImage.data,
            count: (Int(leapImage.width * leapImage.height))
        )
        let pixelArray = Array(pointerBuffer)
        //let pixelArrayString = pixelArray.flatMap { String.init(stringInterpolationSegment: $0) }.joined(separator: ",")
        print("Size of Array: \(pixelArray.count * MemoryLayout<UInt8>.size)")

        return pixelArray
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func acquirePrivileges() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)

        if accessEnabled != true {
            print("You need to enable the keylogger in the System Preferences")
        }

        return accessEnabled == true
    }
}

/*
struct ImageMatrix {
    let rows: Int, columns: Int
    var grid: [UInt8]

    init(rows: Int, columns: Int, withData data: Data? = nil) {
        self.rows = rows
        self.columns = columns

        if let data = data {
            let arrayData = data.reduce(NSMutableArray(), { (collector: NSMutableArray, datum: UInt8) -> NSMutableArray in
                return collector.adding(datum)
            })

            grid = Array(arrayLiteral: arrayData)
        } else {
            grid = Array(repeating: 0, count: rows * columns)
        }
    }

    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    subscript(row: Int, column: Int) -> UInt8 {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }

        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
 */

struct LeapMotionFrameData {
    let serializedFrameData: Data
    let imageData: Data
}

extension AppDelegate: LeapListener {
    func onFrame(_ notification: Notification!) {
        guard let frame = self.leapMotionController.frame(0) else { return }
        let fingers: Array<LeapFinger> = frame.fingers.flatMap { $0 as? LeapFinger }
        let imageSizes = frame.images.flatMap { ($0 as? LeapImage)?.bytesPerPixel }

        /*
        print("Fingers: \(fingers.count)")
        print("Images: \(imageSizes)")
 */
    }
}

