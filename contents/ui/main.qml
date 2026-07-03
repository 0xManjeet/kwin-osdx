import QtQuick
import QtQuick.Window
import org.kde.kwin

Window {
    id: osdWindow
    visible: false
    color: "transparent"

    // Frameless unclickable overlay
    flags: Qt.BypassWindowManagerHint | Qt.FramelessWindowHint | Qt.WindowTransparentForInput | Qt.WindowStaysOnTopHint

    width: label.contentWidth + 60
    height: label.contentHeight + 20

    // Safely reads your active color scheme
    SystemPalette {
        id: palette
        colorGroup: SystemPalette.Active
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: palette.window
        border.color: palette.highlight
        border.width: 1
        opacity: 0.95

        Text {
            id: label
            anchors.centerIn: parent
            color: palette.windowText
            font.pointSize: 14
            font.bold: true
        }
    }

    Timer {
        id: hideTimer
        interval: 400
        repeat: false
        onTriggered: osdWindow.visible = false
    }

    Connections {
        target: Workspace

        function onCurrentDesktopChanged() {
            // Ignore if overview effect is active
            if (Workspace.isEffectActive("overview")) {
                return;
            }

            // Assign Desktop Name
            label.text = Workspace.currentDesktop.name;

            // Get screen bounds (Multi-monitor safe for Plasma 6)
            var screenGeo = Workspace.clientArea(KWin.FullScreenArea, Workspace.activeScreen, Workspace.currentDesktop);

            // Compute Top Center
            osdWindow.x = screenGeo.x + (screenGeo.width / 2) - (osdWindow.width / 2);
            osdWindow.y = screenGeo.y + 40;

            osdWindow.visible = true;
            hideTimer.restart();
        }
    }
}
