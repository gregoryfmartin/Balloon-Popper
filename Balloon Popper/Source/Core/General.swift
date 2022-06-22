//
//  General.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 6/20/22.
//

import Foundation

///
/// A collection of exceptions that could be thrown by any throwing function. Up to this point, exceptions haven't
/// been raised by anything, but as the program progresses, these will see more liberal use, and will also be
/// retrofitted to the existing code.
///
enum GMExceptions: Error {
    case funcNotImplemented
}
