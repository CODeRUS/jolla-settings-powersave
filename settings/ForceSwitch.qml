import QtQuick 2.1
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0

Switch {
    id: mobileSwitch

    property string entryPath

    property string key_powersave_force: "/system/osso/dsm/energymanagement/force_power_saving"
    property var values: ({})

    DBusInterface {
        id: mceRequestIface
        service: 'com.nokia.mce'
        path: '/com/nokia/mce/request'
        iface: 'com.nokia.mce.request'
        bus: DBus.SystemBus

        Component.onCompleted: {
            typedCall('get_config', [{"type": "s", "value": key_powersave_force}], function (value) {
                var temp = values
                temp[key_powersave_force] = value
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
            if (key == key_powersave_force) {
                var temp = values
                temp[key] = value
                values = temp
            }
        }
    }

    icon.source: "/usr/share/jolla-settings/pages/powersave/icon-m-powersave-force"
    checked: values[key_powersave_force]
    automaticCheck: false
    onClicked: mceRequestIface.typedCall('set_config', [{"type": "s", "value": key_powersave_force},
                                                        {"type": "v", "value": !checked}])

    Behavior on opacity { FadeAnimation { } }
}
