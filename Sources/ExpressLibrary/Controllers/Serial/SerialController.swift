//
//  SerialController.swift
//  
//
//  Created by Dr. Brandon Wiley on 8/11/22.
//

import Foundation

import ORSSerial

public class SerialController: NSObject
{
    static public let instance = SerialController()

    public var ports: [SerialPort] = []

    let manager = ORSSerialPortManager.shared()
    @objc dynamic var allPorts: [ORSSerialPort]
    var portsChanged: NSKeyValueObservation?

    override init()
    {
        self.allPorts = self.manager.availablePorts

        super.init()

        self.filterPorts(self.allPorts)

        self.portsChanged = observe(\.allPorts, options: [.old, .new])
        {
            object, change in

            guard let old = change.oldValue else
            {
                print("No old value")
                return
            }

            guard let new = change.newValue else
            {
                print("No new value")
                return
            }

            self.portsDidChange(old: old, new: new)
        }
    }

    func portsDidChange(old: [ORSSerialPort], new: [ORSSerialPort])
    {
        print(old)
        print(new)

        self.filterPorts(new)
    }

    func filterPorts(_ allPorts: [ORSSerialPort])
    {
        self.ports = allPorts.compactMap
        {
            port in

            if port.path.starts(with: "Bluetooth")
            {
                return nil
            }

            return SerialPort(port)
        }
    }
}
