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
                values[key] = value
                valuesChanged()
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
                values[key] = value
                valuesChanged()
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
                //: Settings page header text
                //% "Powersave"
                title: qsTrId("settings-powersave-header_title")
            }

            IconTextSwitch {
                id: enableSwitch

                property string entryPath: "system_settings/info/powersave/powersave_enable"

                automaticCheck: false
                checked: values[key_powersave_enable]
                //: Powersave enable switch text
                //% "Enable powersave mode"
                text: qsTrId("settings-powersave-enable_switch_text")
                icon.source: "image://theme/icon-m-powersave"

                onClicked: mceRequestIface.setValue(key_powersave_enable, !checked)

            }

            IconTextSwitch {
                id: forceSwitch

                property string entryPath: "system_settings/info/powersave/powersave_force"

                automaticCheck: false
                checked: values[key_powersave_force]
                //: Powersave force enable switch text
                //% "Force powersave mode"
                text: qsTrId("settings-powersave-force_switch_text")
                icon.source: "image://theme/icon-m-powersave-force"

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
