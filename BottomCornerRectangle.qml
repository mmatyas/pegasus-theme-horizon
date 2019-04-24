import QtQuick 2.0

Item {
    id: root

    property real radius: 0
    property bool isLeft: true
    property color baseColor
    property color hoverColor

    readonly property bool isActive: activeFocus || mouse.containsMouse
    readonly property real gradientFactor: 0.3

    property color color: isActive ? hoverColor : baseColor
    Behavior on color { ColorAnimation { duration: 150 }}

    signal clicked()

    Keys.onPressed: {
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            root.clicked();
        }
    }

    function gradientAt(percent) {
        return Qt.darker(root.color, 1.0 + gradientFactor * percent)
    }


    Rectangle {
        id: cornerCircle

        anchors.left: root.isLeft ? parent.left : undefined
        anchors.right: root.isLeft ? undefined : parent.right
        anchors.bottom: parent.bottom
        width: radius * 2
        height: radius * 2
        radius: root.radius

        gradient: Gradient {
            GradientStop { position: 0.0; color: gradientAt(cornerCircle.height / root.height) }
            GradientStop { position: 1.0; color: gradientAt(1.0) }
        }
    }

    Rectangle {
        id: sideBar

        anchors.left: root.isLeft ? parent.left : undefined
        anchors.right: root.isLeft ? undefined : parent.right
        anchors.top: parent.top
        width: root.radius
        height: parent.height - root.radius

        gradient: Gradient {
            GradientStop { position: 0.0; color: root.color }
            GradientStop { position: 1.0; color: gradientAt(sideBar.height / root.height) }
        }
    }

    Rectangle {
        anchors.left: root.isLeft ? sideBar.right : parent.left
        anchors.right: root.isLeft ? parent.right : sideBar.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        gradient: Gradient {
            GradientStop { position: 0.0; color: root.color }
            GradientStop { position: 1.0; color: gradientAt(1.0) }
        }
    }


    MouseArea {
        id: mouse
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
