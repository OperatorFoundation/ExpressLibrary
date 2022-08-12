//
//  CircuitPythonDependency.swift
//  
//
//  Created by Dr. Brandon Wiley on 8/12/22.
//

import Foundation

public class CircuitPythonDependency
{
    static func guessPipPackageName(circupPackageName: String) -> String
    {
        if circupPackageName.starts(with: "adafruit_")
        {
            let parts = circupPackageName.split(separator: "_")
            let rest = parts[1...]
            let suffix = rest.joined(separator: "-")
            let result = "adafruit-circuitpython-\(suffix)"
            return result
        }
        else
        {
            return circupPackageName.replacingOccurrences(of: "_", with: "-")
        }
    }

    let circupPackageName: String
    let pipPackageName: String

    public init(circupPackageName: String, pipPackageName: String? = nil)
    {
        self.circupPackageName = circupPackageName

        if let pipPackageName = pipPackageName
        {
            self.pipPackageName = pipPackageName
        }
        else
        {
            self.pipPackageName = CircuitPythonDependency.guessPipPackageName(circupPackageName: circupPackageName)
        }
    }

    public func install()
    {
        // FIXME
    }

    public func uninstall()
    {
        // FIXME
    }
}
