//
//  AsyncOperation.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 06.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation

class AsyncOperation {

    private let semaphore: DispatchSemaphore
    private let dispatchQueue: DispatchQueue
    typealias CompleteClosure = ()->()

    init(numberOfSimultaneousActions: Int, dispatchQueueLabel: String) {
        semaphore = DispatchSemaphore(value: numberOfSimultaneousActions)
        dispatchQueue = DispatchQueue(label: dispatchQueueLabel)
    }

    func run(closure: @escaping (@escaping CompleteClosure)->()) {
        dispatchQueue.async {
            self.semaphore.wait()
            closure {
                self.semaphore.signal()
            }
        }
    }
}
