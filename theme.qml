import QtQuick 2.12

FocusScope {
    id: root

    readonly property int mainWidth: parent.height / 9.0 * 16.0
    readonly property int innerzoneWidth: mainWidth * 0.85
    readonly property int outerzoneWidth: parent.width - innerzoneWidth

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.1; color: "#30383f" }
            GradientStop { position: 0.8; color: "#08080f" }
        }
    }

    Item {
        id: paddingTop
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.12
    }

    ListView {
        id: collections

        readonly property var currentData: model.get(currentIndex)

        visible: false
        model: api.collections
        delegate: Item {}

        keyNavigationWraps: true
    }

    Item {
        id: header
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: paddingTop.bottom
        width: root.innerzoneWidth
        height: headerLabel.height * 1.5

        Text {
            id: headerLabel
            text: collections.currentData.name
            color: "#ccc"

            font.pixelSize: root.height * 0.055
            font.family: globalFonts.sans
            font.capitalization: Font.AllUppercase
            font.weight: Font.Light

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            elide: Text.ElideRight
        }
    }

    GridView {
        id: grid

        readonly property var currentData: model.get(currentIndex)
        readonly property real cellWidthRatio: 16 / 9
        readonly property int containedWidth: Math.floor((width - preferredHighlightBegin) / cellWidth) * cellWidth

        anchors.top: header.bottom
        anchors.bottom: paddingBottom.top
        anchors.left: parent.left
        anchors.right: parent.right

        flow: GridView.FlowTopToBottom
        focus: true

        preferredHighlightBegin: outerzoneWidth / 2 - cellWidth * 0.05
        preferredHighlightEnd: preferredHighlightBegin + containedWidth
        highlightRangeMode: GridView.StrictlyEnforceRange
        highlightMoveDuration: 100

        cellHeight: height / 3
        cellWidth: (cellHeight * 0.9 * cellWidthRatio) + cellHeight * 0.1

        model: collections.currentData.games
        delegate: GridDelegate {
            width: grid.cellWidth
            height: grid.cellHeight
            onClicked: GridView.view.currentIndex = index
            onEntered: {
                const coords = mapToItem(root, geometry.x, geometry.y);
                const geometry2 = Qt.rect(coords.x, coords.y, geometry.width, geometry.height);
                info.focus = true;
                info.open(geometry2);
            }
        }

        Keys.onPressed: {
            if (event.isAutoRepeat)
                return;

            if (api.keys.isPrevPage(event)) {
                event.accepted = true;
                collections.decrementCurrentIndex();
                return;
            }
            if (api.keys.isNextPage(event)) {
                event.accepted = true;
                collections.incrementCurrentIndex();
                return;
            }
        }
    }

    GameInfoScreen {
        id: info
        originData: grid.currentData
        onClosed: grid.focus = true
    }

    Item {
        id: paddingBottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.15
    }
}
