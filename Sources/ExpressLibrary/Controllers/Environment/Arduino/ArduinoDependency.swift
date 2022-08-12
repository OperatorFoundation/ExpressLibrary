//
//  ArduinoDependency.swift
//  
//
//  Created by Dr. Brandon Wiley on 8/12/22.
//

import Foundation

public enum ArduinoDependency
{
    case package(String)
    case git(URL)
    case zip(URL)

    public func install()
    {
        // FIXME
    }

    public func uninstall()
    {
        // FIXME
    }
}
