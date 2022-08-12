//
//  LineOrientedSerialPort.swift
//
//
//  Created by Dr. Brandon Wiley on 8/11/22.
//

import Foundation

import Chord
import Datable
import ORSSerial
import Straw

public class LineOrientedSerialPort: NSObject, ORSSerialPortDelegate
{
    let port: ORSSerialPort
    let queue = BlockingQueue<String>()

    var open: Bool = true
    let writeLock = DispatchSemaphore(value: 0)
    let readLock = DispatchSemaphore(value: 0)

    public init(_ port: ORSSerialPort, maximumLineLength: UInt = 80, baudRate: Int = 115200)
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

        self.port.startListeningForPackets(matching: ORSSerialPacketDescriptor(prefixString: nil, suffixString: "\n", maximumPacketLength: maximumLineLength, userInfo: nil))
    }

    public func writeLine(_ string: String) throws
    {
        guard self.open else
        {
            throw SerialPortError.portClosed
        }

        let text = string + "\n"

        writeLock.wait()
        self.port.send(text.data)
        writeLock.signal()
    }

    public func readLine() throws -> String
    {
        guard self.open else
        {
            throw SerialPortError.portClosed
        }

        let result = self.queue.dequeue()
        let start = result.startIndex
        let end = result.endIndex

        let substring = result[start..<end]
        return String(substring)
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
        return // discard
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
        return
    }

    public func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor)
    {
        let string = packetData.string
        self.queue.enqueue(element: string)
    }
    // ORSSerialPortDelegate ends
}
