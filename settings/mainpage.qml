import QtQuick 2.1
import Sailfish.Silica 1.0
import com.jolla.settings 1.0
import org.nemomobile.dbus 2.0

Page {
    id: page

    property string key_threshold_value: "/system/osso/dsm/energymanagement/psm_threshold"
    property string key_powersave_enable: "/system/osso/dsm/energymanagement/enable_power_saving"
    property string key_powersave_force: "/system/osso/dsm/energymanagement/force_power_saving"

    property variant threshold_value
    property variant powersave_enable
    property variant powersave_force

    property var values: {
        "/system/osso/dsm/energymanagement/psm_threshold": 50,
        "/system/osso/dsm/energymanagement/enable_power_saving": true,
        "/system/osso/dsm/energymanagement/force_power_saving": true
    }

    DBusInterface {
        id: mceRequestIface
        service: 'com.nokia.mce'
        path: '/com/nokia/mce/request'
        iface: 'com.nokia.mce.request'
        bus: DBus.SystemBus

        function setValue(key, value) {
            typedCall('set_config', [{"type":"s", "value":key}, {"type":"v", "value":value}])
        }

        function getValue(key) {
            typedCall('get_config', [{"type":"s", "value":key}], function (value) {
                var temp = values
                temp[key] = value
                values = temp
            })
        }

        Component.onCompleted: {
            getValue(key_threshold_value)
            getValue(key_powersave_enable)
            getValue(key_powersave_force)
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
            if (key in values) {
                var temp = values
                temp[key] = value
                values = temp
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width

            PageHeader {
                title: qsTr("Powersave")
            }

            IconTextSwitch {
                id: enableSwitch

                property string entryPath: "system_settings/info/powersave/powersave_enable"

                automaticCheck: false
                checked: values[key_powersave_enable]
                text: "Enable powersave mode"
                //description: qsTrId("settings_flight-la-flight-mode-description")
                icon.source: "/usr/share/jolla-settings/pages/powersave/icon-m-powersave-enable"

                onClicked: mceRequestIface.setValue(key_powersave_enable, !checked)

            }

            IconTextSwitch {
                id: forceSwitch

                property string entryPath: "system_settings/info/powersave/powersave_force"

                automaticCheck: false
                checked: values[key_powersave_force]
                text: "Force powersave mode"
                //description: qsTrId("settings_flight-la-flight-mode-description")
                icon.source: "/usr/share/jolla-settings/pages/powersave/theme/icon-m-powersave-force"

                onClicked: mceRequestIface.setValue(key_powersave_force, !checked)
            }

            ThresholdSlider {
                id: thresholdSlider
                width: parent.width
                entryPath: "system_settings/info/powersave/powersave_threshold"
                highlighted: down
            }
        }
    }
}
