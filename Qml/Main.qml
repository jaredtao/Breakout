import QtQuick 2.9

Image {
    width: 1024
    height: 768
    source: "qrc:/Img/background-1024x768.jpg"
    Breakout{
        id: breakOut
        anchors.fill: parent

        Text {
            id: tip
            anchors.centerIn: parent
            text: "Press space start game, left and right control slide"
            font.pixelSize: 24
            color: "green"
            visible: !breakOut.isRunning

            SequentialAnimation{
                running: tip.visible
                loops: Animation.Infinite
                NumberAnimation { target:tip; property: "opacity"; from: 0; to: 1; duration: 1000}
                PauseAnimation { duration: 2000 }
                NumberAnimation { target:tip; property: "opacity"; from: 1; to: 0; duration: 1000}
            }
        }

    }
}
