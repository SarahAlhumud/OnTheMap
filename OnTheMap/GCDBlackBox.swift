//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 03/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
