import QtQuick 2.1
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0

Switch {
    id: mobileSwitch

    property string entryPath

    property string key_powersave_enable: "/system/osso/dsm/energymanagement/enable_power_saving"
    property var values: ({})

    DBusInterface {
        id: mceRequestIface
        service: 'com.nokia.mce'
        path: '/com/nokia/mce/request'
        iface: 'com.nokia.mce.request'
        bus: DBus.SystemBus

        Component.onCompleted: {
            typedCall('get_config', [{"type": "s", "value": key_powersave_enable}], function (value) {
                values[key_powersave_enable] = value
                valuesChanged()
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
            if (key == key_powersave_enable) {
                values[key_powersave_enable] = value
                valuesChanged()
            }
        }
    }

    icon.source: "image://theme/icon-m-powersave"
    checked: values[key_powersave_enable]
    automaticCheck: false
    onClicked: mceRequestIface.typedCall('set_config', [{"type": "s", "value": key_powersave_enable},
                                                        {"type": "v", "value": !checked}])

    Behavior on opacity { FadeAnimation { } }
}
