//
//  CircuitPythonEnvironment.swift
//  
//
//  Created by Dr. Brandon Wiley on 8/12/22.
//

import Foundation

import Gardener

public class CircuitPythonEnvironment
{
    static public func new(_ name: String) throws -> CircuitPythonEnvironment
    {
        let environment = CircuitPythonEnvironment.getURL(name: name)

        if File.exists(environment.path)
        {
            throw CircuitPythonEnvironmentError.environmentAlreadyExists(name)
        }
        else
        {
            return try CircuitPythonEnvironment(name: name)
        }
    }

    static public func load(_ name: String) throws -> CircuitPythonEnvironment
    {
        let environment = CircuitPythonEnvironment.getURL(name: name)

        if File.exists(environment.path)
        {
            return try CircuitPythonEnvironment(name: name)
        }
        else
        {
            throw CircuitPythonEnvironmentError.environmentDoesNotExist(name)
        }
    }

    static func getURL(name: String) -> URL
    {
        let support = File.applicationSupportDirectory()
        let CircuitPython = support.appendingPathComponent("circuitpython")
        let environment = CircuitPython.appendingPathComponent(name)
        return environment
    }

    let name: String

    public init(name: String) throws
    {
        self.name = name

        let url = CircuitPythonEnvironment.getURL(name: name)
        if !File.exists(url.path)
        {
            guard File.makeDirectory(url: url) else
            {
                throw CircuitPythonEnvironmentError.couldNotCreateDirectory(url)
            }

            let lib = url.appendingPathComponent("lib")
            guard File.makeDirectory(url: lib) else
            {
                throw CircuitPythonEnvironmentError.couldNotCreateDirectory(lib)
            }

            let sitepackages = url.appendingPathComponent("site-packages")
            guard File.makeDirectory(url: sitepackages) else
            {
                throw CircuitPythonEnvironmentError.couldNotCreateDirectory(sitepackages)
            }
        }
    }
}

public enum CircuitPythonEnvironmentError: Error
{
    case environmentAlreadyExists(String)
    case environmentDoesNotExist(String)
    case couldNotCreateDirectory(URL)
}
