//
//  Debouncer.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation

class Debouncer {
    let delay: TimeInterval
    let queue: DispatchQueue
    var workItem: DispatchWorkItem?
    let syncQueue = DispatchQueue(label: "com.debouncer.sync")

    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }

    func cancelTask() {
        workItem?.cancel()
        workItem = nil
    }

    func debounce(_ action: @escaping () -> Void) {
        let newWorkItem = DispatchWorkItem { [weak self] in
            action()
            self?.cancelTask()
        }

        syncQueue.sync {
            cancelTask()
            workItem = newWorkItem
        }

        queue.asyncAfter(deadline: .now() + delay, execute: newWorkItem)
    }
}
