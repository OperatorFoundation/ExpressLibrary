//
//  ArduinoEnvironment.swift
//  
//
//  Created by Dr. Brandon Wiley on 8/12/22.
//

import Foundation

import Gardener

public class ArduinoEnvironment
{
    static public func new(_ name: String) throws -> ArduinoEnvironment
    {
        let environment = ArduinoEnvironment.getURL(name: name)

        if File.exists(environment.path)
        {
            throw ArduinoEnvironmentError.environmentAlreadyExists(name)
        }
        else
        {
            return try ArduinoEnvironment(name: name)
        }
    }

    static public func load(_ name: String) throws -> ArduinoEnvironment
    {
        let environment = ArduinoEnvironment.getURL(name: name)

        if File.exists(environment.path)
        {
            return try ArduinoEnvironment(name: name)
        }
        else
        {
            throw ArduinoEnvironmentError.environmentDoesNotExist(name)
        }
    }

    static func getURL(name: String) -> URL
    {
        let support = File.applicationSupportDirectory()
        let arduino = support.appendingPathComponent("arduino")
        let environment = arduino.appendingPathComponent(name)
        return environment
    }

    let name: String

    public init(name: String) throws
    {
        self.name = name

        let url = ArduinoEnvironment.getURL(name: name)
        if !File.exists(url.path)
        {
            guard File.makeDirectory(url: url) else
            {
                throw ArduinoEnvironmentError.couldNotCreateDirectory(url)
            }

            let user = url.appendingPathComponent("user")
            guard File.makeDirectory(url: user) else
            {
                throw ArduinoEnvironmentError.couldNotCreateDirectory(user)
            }

            let data = url.appendingPathComponent("data")
            guard File.makeDirectory(url: data) else
            {
                throw ArduinoEnvironmentError.couldNotCreateDirectory(data)
            }
        }
    }
}

public enum ArduinoEnvironmentError: Error
{
    case environmentAlreadyExists(String)
    case environmentDoesNotExist(String)
    case couldNotCreateDirectory(URL)
}
