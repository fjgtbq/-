import QtQuick 2.0
import QtMultimedia 5.9
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.9
import QtQuick.Controls 2.2
Entity{
    id:lights
    property real insen: 4
Entity {
    id:d_light
    components: [
        DirectionalLight {
            worldDirection: Qt.vector3d(0, 0, 10).normalized();
            color: "#fbf9ce"
            intensity: insen
        }
    ]
}
Entity {
    components: [
        DirectionalLight {
            worldDirection: Qt.vector3d(0, 0, -10).normalized();
            color: "#fbf9ce"
            intensity: insen
        }
    ]
}
Entity {
    components: [
        DirectionalLight {
            worldDirection: Qt.vector3d(0, 5, 0).normalized();
            color: "#fbf9ce"
            intensity: insen
        }
    ]
}
Entity {
    components: [
        DirectionalLight {
            worldDirection: Qt.vector3d(0, -5, 0).normalized();
            color: "#fbf9ce"
            intensity: insen
        }
    ]
}
Entity {
    components: [
        DirectionalLight {
            worldDirection: Qt.vector3d(5, 0, 0).normalized();
            color: "#fbf9ce"
            intensity: insen
        }
    ]
}
Entity {
    components: [
        DirectionalLight {
            worldDirection: Qt.vector3d(-5, 0, 0).normalized();
            color: "#fbf9ce"
            intensity: insen
        }
    ]
}
/*Entity{
    components: [
        SpotLight{
            localDirection: Qt.vector3d(0,0,0)
            color: "#fbf9ce"
            intensity: insen
        }

    ]
}*/
}
