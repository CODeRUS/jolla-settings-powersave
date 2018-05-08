import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0

Slider {
    id: slider

    property string entryPath

    property string key_threshold_value: "/system/osso/dsm/energymanagement/psm_threshold"
    property var values: ({})

    DBusInterface {
        id: mceRequestIface
        service: 'com.nokia.mce'
        path: '/com/nokia/mce/request'
        iface: 'com.nokia.mce.request'
        bus: DBus.SystemBus

        Component.onCompleted: {
            typedCall('get_config', [{"type": "s", "value": key_threshold_value}], function (value) {
                var temp = values
                temp[key_threshold_value] = value
                values = temp
            })
        }
    }

    DBusInterface {
        id: mceSignalIface
        service: 'com.nokia.mce'
        path: '/com/nokia/mce/signal'
        iface: 'com.nokia.mce.signal'
        bus: DBus.SystemBus

        signalsEnabled: true

        function config_change_ind(key, value) {
            if (key == key_threshold_value) {
                var temp = values
                temp[key] = value
                values = temp
            }
        }
    }

    minimumValue: 1
    maximumValue: 99
    label: qsTr("Battery threshold")
    valueText: parseInt(value) + "%"
    stepSize: 1

    value: values[key_threshold_value] ? values[key_threshold_value] : 0
    onReleased: mceRequestIface.typedCall('set_config', [{"type": "s", "value": key_threshold_value},
                                                         {"type": "v", "value": parseInt(value)}])
    onPressAndHold: cancel()
}
