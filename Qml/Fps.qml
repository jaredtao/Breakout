import QtQuick 2.6
Item{
    property int fps: 0
    property int frameCount: 0
    Item {
        id: fpsItem
        implicitWidth: 100
        implicitHeight: 50
        NumberAnimation on rotation {
            from: 0
            to: 360
            duration: 800
            loops: Animation.Infinite
        }
        onRotationChanged: ++frameCount;
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            fps = frameCount;
            frameCount = 0;
        }
    }

    Text {
        text: "FPS:" + fps
        font.pixelSize: 20
        color: "green"
    }
}
