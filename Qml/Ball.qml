import QtQuick 2.0
import QtQuick.Particles 2.0
Image {
    id: root
    Behavior on x {NumberAnimation{ duration: 200}}
    Behavior on y {NumberAnimation{ duration: 200}}
    property alias running: sys.running
    ParticleSystem {
        id: sys
        ImageParticle {
            //qml 自带的图片
            source: "qrc:///particleresources/star.png"
            color: "red"
            colorVariation: 0.2
            rotation: 15
            rotationVariation: 5
            rotationVelocity: 45
            rotationVelocityVariation: 15
            entryEffect: ImageParticle.Scale
        }
        Emitter {
            anchors.centerIn: parent
            emitRate: 20
            lifeSpan: 400
            lifeSpanVariation: 100
            size: 50
        }
    }
}
