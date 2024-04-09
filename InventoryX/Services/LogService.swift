//
//  LogService.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.
//

import OSLog

@available(iOS 14.0, *)
class LogService {
    let senderName: String
    
    lazy var logger = {
        let bundleId = Bundle.main.bundleIdentifier ?? "Nil Bundle ID"
        return Logger(subsystem: bundleId, category: self.senderName)
    }()
    
    /// LogService should always receive ``self`` as the `sender` parameter. It is fed to the Logger to track the class or struct that needs to log a message.
    init(_ senderName: String = "") {
        self.senderName = String(describing: senderName)
    }
    
    deinit {
        print("Deinitializing Logger for \(senderName)")
    }
    
    func debug(_ message: String) {
        logger.debug(">>> \(message)")
    }
    
    func error(_ message: String) {
        logger.error(">>> \(message)")
    }
    
    func log(_ message: String) {
        logger.log(">>> \(message)")
    }
    
    func info(_ message: String) {
        logger.info(">>> \(message)")
    }
    
    func warning(_ message: String) {
        logger.warning(">>> \(message)")
    }
    
    func trace(_ message: String) {
        logger.trace(">>> \(message)")
    }
    
    func notice(_ message: String) {
        logger.notice(">>> \(message)")
    }
    
    func critical(_ message: String) {
        logger.critical(">>> \(message)")
    }
    
    func fault(_ message: String) {
        logger.fault(">>> \(message)")
    }
    
    /// This function should only be used to preview different logs. All functions will run before class is deinitialized.
//    func testLogs() {
//        self.debug("Logging a debug message")
//        self.error("Logging a error message")
//        self.fault("Logging a fault message")
//        self.info("Logging a info message")
//        self.notice("Logging a notice message")
//        self.trace("Logging a trace message")
//        self.warning("Logging a warning message")
//        self.critical("Logging a critical message")
//    }
}

