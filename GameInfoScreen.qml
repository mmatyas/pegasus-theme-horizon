import QtQuick 2.12

FocusScope {
    id: root

    readonly property real heightRatio: 9 / 16
    readonly property real openDuration: 300
    readonly property real closeDuration: 250
    property var originData
    property rect originCell

    signal closed()

    anchors.fill: parent
    visible: bgShadow.opacity > 0.001


    function open(geometry) {
        originCell = geometry;
        state = "open";
    }

    function close() {
        state = "";
        root.closed();
    }


    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isCancel(event)) {
            event.accepted = true;
            root.close();
            return;
        }
    }


    Rectangle {
        id: bgShadow
        anchors.fill: parent
        color: "#000"
        opacity: 0.0

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    Rectangle {
        id: containerShadow

        readonly property int shadowWidth: originCell.width * 0.015

        anchors.centerIn: container
        width: container.width + 2 * shadowWidth
        height: container.height + 2 * shadowWidth
        radius: container.radius * 1.3

        color: "#000"
        opacity: 0.2
    }

    Rectangle {
        id: container

        readonly property int fullWidth: (root.height / heightRatio) * 0.6
        readonly property int fullHeight: root.height * 0.9
        property real padding: originCell.height * 0.015

        x: originCell.x
        y: originCell.y
        width: originCell.width
        height: originCell.height
        radius: originCell.height * 0.03 * 1.5
        color: "#eee"
        clip: true

        anchors.horizontalCenter: undefined
        anchors.verticalCenter: undefined

        Item {
            id: img
            width: originCell.width - 2 * originCell.height * 0.015
            height: width * heightRatio

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: parent.padding

            GameImage { game: originData }
        }

        Text {
            id: title
            text: originData.title
            color: "#282828"

            font.pixelSize: root.height * 0.045
            font.family: globalFonts.sans
            font.capitalization: Font.AllUppercase
            font.weight: Font.Light

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            width: container.fullWidth - img.width - 3 * parent.padding
            anchors.top: img.top
            anchors.bottom: img.bottom
            anchors.left: img.right
            anchors.leftMargin: parent.padding
            elide: Text.ElideRight
            wrapMode: Text.Wrap

            opacity: 0.0
            visible: opacity > 0.001
        }

        Text {
            id: desc

            text: originData.description || originData.summary
            color: "#282828"

            horizontalAlignment: Text.AlignJustify

            font.pixelSize: title.font.pixelSize * 0.6
            font.family: globalFonts.sans
            font.weight: Font.Light

            width: container.fullWidth - 2 * parent.padding
            anchors.top: img.bottom
            anchors.bottom: likebtn.top
            anchors.margins: parent.padding
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.Wrap

            opacity: title.opacity
            visible: title.visible
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: likebtn.top
            height: desc.font.pixelSize * 5
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.8; color: container.color }
            }
        }

        BottomCornerRectangle {
            id: likebtn

            anchors.left: parent.left
            anchors.bottom: parent.bottom

            width: parent.width * 0.3
            height: desc.font.pixelSize + container.padding * 1.2
            radius: parent.radius
            isLeft: true
            onClicked: originData.favorite = !originData.favorite

            baseColor: "#38f"
            hoverColor: "#04e"

            opacity: title.opacity
            visible: title.visible

            Image {
                source: (originData.favorite && "assets/heart_filled.svg") || "assets/heart_empty.svg"
                sourceSize { width: 32; height: 32 }
                asynchronous: true

                anchors.centerIn: parent
                width: parent.width
                height: parent.height * 0.5
                fillMode: Image.PreserveAspectFit
            }
        }

        BottomCornerRectangle {
            id: launchbtn

            anchors.left: likebtn.right
            anchors.right: parent.right
            anchors.top: likebtn.top
            anchors.bottom: likebtn.bottom

            radius: parent.radius
            isLeft: false
            baseColor: likebtn.baseColor
            hoverColor: likebtn.hoverColor
            onClicked: originData.launch()

            opacity: title.opacity
            visible: title.visible

            focus: true
            KeyNavigation.left: likebtn

            Text {
                text: "Launch!"
                anchors.centerIn: parent

                font.pixelSize: title.font.pixelSize * 0.75
                font.family: globalFonts.sans
                font.bold: true
                color: "#eee"
            }
        }
    }


    states: [
        State {
            name: "open"
            PropertyChanges { target: bgShadow; opacity: 0.4 }
            PropertyChanges { target: title; opacity: 1.0 }
            PropertyChanges { target: container; padding: originCell.height * 0.15 }
            PropertyChanges { target: container; x: 0.0 }
            PropertyChanges { target: container; y: 0.0 }
            PropertyChanges { target: container; width: container.fullWidth }
            PropertyChanges { target: container; height: container.fullHeight }
            AnchorChanges {
                target: container
                anchors.horizontalCenter: root.horizontalCenter
                anchors.verticalCenter: root.verticalCenter
            }
        }
    ]

    readonly property var bezierStandard: [ 0.4,0.0, 0.2,1.0, 1.0,1.0 ]
    transitions: [
        Transition {
            from: ""; to: "open"
            PropertyAnimation {
                target: bgShadow; properties: "opacity";
                duration: openDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
            PropertyAnimation {
                target: title; properties: "opacity";
                duration: openDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
            PropertyAnimation {
                target: container; properties: "padding,width,height";
                duration: openDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
            AnchorAnimation {
                targets: container;
                duration: openDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
        },
        Transition {
            from: "open"; to: ""
            PropertyAnimation {
                target: bgShadow; properties: "opacity";
                duration: closeDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
            PropertyAnimation {
                target: title; properties: "opacity";
                duration: closeDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
            PropertyAnimation {
                target: container; properties: "padding,width,height";
                duration: closeDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
            AnchorAnimation {
                targets: container;
                duration: closeDuration; easing { type: Easing.Bezier; bezierCurve: bezierStandard }}
        }
    ]
}
