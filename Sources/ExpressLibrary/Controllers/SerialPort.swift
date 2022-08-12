//
//  SerialPort.swift
//  
//
//  Created by Dr. Brandon Wiley on 8/11/22.
//

import Foundation

import Chord
import Datable
import ORSSerial
import Straw

public class SerialPort: NSObject, ORSSerialPortDelegate
{
    let port: ORSSerialPort
    let buffer = Straw()

    var open: Bool = true
    let writeLock = DispatchSemaphore(value: 0)
    let readLock = DispatchSemaphore(value: 0)

    public init(_ port: ORSSerialPort, baudRate: Int = 115200)
    {
        self.port = port

        super.init()

        self.port.baudRate = NSNumber(integerLiteral: baudRate)
        self.port.parity = .none
        self.port.numberOfDataBits = 1
        self.port.usesDTRDSRFlowControl = false
        self.port.usesRTSCTSFlowControl = false
        self.port.usesDCDOutputFlowControl = false
        self.port.delegate = self
    }

    public func write(_ string: String) throws
    {
        guard self.open else
        {
            throw SerialPortError.portClosed
        }

        try self.write(string.data)
    }

    public func writeLine(_ string: String) throws
    {
        guard self.open else
        {
            throw SerialPortError.portClosed
        }

        let text = string + "\n"
        try self.write(text.data)
    }

    public func write(_ data: Data) throws
    {
        guard self.open else
        {
            throw SerialPortError.portClosed
        }

        writeLock.wait()
        self.port.send(data)
        writeLock.signal()
    }

    public func read() async throws -> Data
    {
        guard self.open else
        {
            throw SerialPortError.portClosed
        }

        writeLock.wait()
        let result = try await self.buffer.read()
        writeLock.signal()

        return result
    }

    public func read() async throws -> String
    {
        guard self.open else
        {
            throw SerialPortError.portClosed
        }

        let data: Data = try await self.read()
        return data.string
    }

    // ORSSerialPortDelegate
    public func serialPortWasClosed(_ serialPort: ORSSerialPort)
    {
        self.open = false
    }

    public func serialPortWasOpened(_ serialPort: ORSSerialPort)
    {
        self.open = true
    }

    public func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data)
    {
        AsyncAwaitEffectSynchronizer.sync { await self.buffer.write(data) }
    }

    public func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error)
    {
        self.open = false
    }

    public func serialPort(_ serialPort: ORSSerialPort, requestDidTimeout request: ORSSerialRequest)
    {
        self.open = false
    }

    public func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort)
    {
        self.open = false
    }

    public func serialPort(_ serialPort: ORSSerialPort, didReceiveResponse responseData: Data, to request: ORSSerialRequest)
    {
        return // discard
    }

    public func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor)
    {
        return // discard
    }
    // ORSSerialPortDelegate ends
}

public enum SerialPortError: Error
{
    case portClosed
}
