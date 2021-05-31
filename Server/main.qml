import QtQuick 2.1
import QtMultimedia 5.9
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.9
import Qt3D.Input 2.0
import Qt3D.Extras 2.9
import QtQuick.Controls 2.2
import QtQuick.Shapes 1.12
import an.qml.TransObj 1.0
//下一步，
Item {//线程
    //width: 120
    //height: 80
    Scene3D{
        //anchors.rightMargin: 199
        anchors.bottomMargin: 0
        //anchors.leftMargin: 41
        //anchors.topMargin: 73
        anchors.fill: parent
        focus: true
        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio


        Entity {
            id: sceneRoot

            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                aspectRatio: 16/9
                nearPlane : 0.1
                farPlane : 1000.0
                //position: Qt.vector3d( -150.0, 150.0, 150.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                //viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
                components: [camera_trans,camera]
            }

           OrbitCameraController {
                camera: camera
            }

            components: [
                RenderSettings {
                    activeFrameGraph: ForwardRenderer {
                        clearColor: Qt.rgba(0, 0, 0, 1)
                        camera: camera
                    }
                },
                // Event Source will be set by the Qt3DQuickWindow
                InputSettings { }
            ]

            Transform{
                id:camera_trans
                property real y_angle: 0.0
                property real x_angle: 0.0
                property real x_tran: 0.0
                property real y_tran: 0.0
                property real z_tran: 350.0
                matrix:{
                    var m = Qt.matrix4x4();
                    m.rotate(y_angle, Qt.vector3d(0, 1,0));//绕y轴旋转
                    m.rotate(x_angle,Qt.vector3d(1,0,0));
                    m.translate(Qt.vector3d(x_tran,y_tran, z_tran));
                    return m;
                }
            }

           NumberAnimation{
               id:camera_y
               property bool ok: false
               property real m: 0.0//这个值是飞机初始的旋转值
               target:camera_trans
               property: "y_angle"
               duration: 450
               from:m
               to:m-45.0
               running: ok
               onStopped: {
                   ok=false;
                   m-=45.0
               }
           }
           NumberAnimation{
               id:camera_x
               property bool ok: false
               property real m: 0.0
               target:camera_trans
               property: "x_angle"
               duration: 450
               from:m
               to:m+45.0
               running: ok
               onStopped: {
                   ok=false;
                   m+=45.0
               }
           }
           NumberAnimation{//飞机移动
               id:translate_x
               property bool ok: false
               target: en_tf
               property: "x"
               duration: 450
               from:0.0
               to:80.0
               running: ok
               onStopped: {
                   ok=false;
               }
           }
           NumberAnimation{//摄像机移动
               id:translate_z
               property bool ok: false
               target: camera_trans
               property: "z_tran"
               duration: 450
               from:350.0
               to:50.0
               running: ok
               onStopped: {
                   ok=false;
               }
           }
           // Lights{ }

           Entity{
               id:light
               property bool able: false
               components: [
                   DirectionalLight{
                       enabled: light.able
                       worldDirection: Qt.vector3d(0, 1, 0).normalized();
                       color: "#fbf9ce"
                       intensity: 3
                   },
                   PointLight{
                       id:p_light
                       enabled: true
                       color: "#fbf9ce"
                       intensity: 2.5
                   },

                   DirectionalLight{
                       enabled: light.able
                       worldDirection: Qt.vector3d(0, -1, 0).normalized();
                       color: "#fbf9ce"
                       intensity: 1
                   },
                   DirectionalLight{
                       enabled: light.able
                       worldDirection: Qt.vector3d(1, 0, 0).normalized();
                       color: "#fbf9ce"
                       intensity: 1
                   },
                   DirectionalLight{
                       enabled: light.able
                       worldDirection: Qt.vector3d(-1, 0, 0).normalized();
                       color: "#fbf9ce"
                       intensity: 1
                   },
                   DirectionalLight{
                       enabled: light.able
                       worldDirection: Qt.vector3d(0, 0, 1).normalized();
                       color: "#fbf9ce"
                       intensity: 1
                   },
                   DirectionalLight{
                       enabled:light.able
                       worldDirection: Qt.vector3d(0, 0, -1).normalized();
                       color: "#fbf9ce"
                       intensity: 1
                   },

           EnvironmentLight {
                       id:env_light
               enabled: true

               irradiance: TextureLoader {//辐射通量密度
                   source: "qrc:/default_irradiance.dds"
                   wrapMode {
                       x: WrapMode.ClampToEdge
                       y: WrapMode.ClampToEdge
                   }
                   generateMipMaps: false
               }
           }
            ]
           }
            Transform{
                id:en_tf
                property real x: 0.0
                translation: Qt.vector3d(x,0.0,0.0)
            }
            Entity{
                TexturedMetalRoughMaterial{
                    id:sky_tex
                    baseColor:  TextureLoader {
                    source: "qrc:/sky.jpeg"
                    format: Texture.SRGB8_Alpha8
                    generateMipMaps: true
                    }
                }
                Mesh{
                    id:sky
                    source: "qrc:/sky.obj"
                }
                components: [sky,sky_tex]
            }
            PhongAlphaMaterial{
                id:material
                //ambient: "red"
                diffuse: "black"
                specular: Qt.rgba(0.0,0,0,0)
                alpha: 1.0
            }

            Entity {
                id: plane

                PhongAlphaMaterial {
                    id: material2
                    diffuse: Qt.rgba(0.1,0.1,0.5,1)
                    specular: Qt.rgba(0,0,0,1)
                    alpha: 1.0
                }

            TexturedMetalRoughMaterial{
                id:ss
                baseColor:  TextureLoader {
                source: "qrc:/map.jpg"
                format: Texture.SRGB8_Alpha8
                generateMipMaps: true
                }
            }
                Mesh {
                    id: planeMesh
                    source: "qrc:/body.obj"
                }

                components: [planeMesh,ss,en_tf]
            }
            Entity{
                id:head
                TexturedMetalRoughMaterial{
                    id:h_m
                    baseColor: "red"
                    ColorAnimation on baseColor {
                        id:an1
                        from:"red"
                        to:"black"
                        duration: 800
                        onStopped: {an2.start();}
                    }
                    ColorAnimation on baseColor{
                        id:an2
                        from:"black"
                        to:"red"
                        duration: 800
                        onStopped: an1.start();
                    }
                }

                Mesh{
                    id:head_mesh
                    source: "qrc:/head.obj"
                }
                components: [head_mesh]
            }

            Entity{
                id:jiyi1
                Mesh{
                    id:jiyi
                    source: "qrc:/jiyi.obj"
                }
                TexturedMetalRoughMaterial{
                    id:b_w
                    baseColor:  TextureLoader {
                        source: "qrc:/jiyi.jpg"
                        format: Texture.SRGB8_Alpha8
                        generateMipMaps: true
                    }
                }
                components: [jiyi,b_w,en_tf]
            }
            Entity{
                id:win
                Mesh{
                    id:window
                    source: "qrc:/window.obj"
                }
                TexturedMetalRoughMaterial{
                    id:win_mt
                    baseColor: "black"
                }
                components: [window,win_mt,en_tf]
            }
            Entity{
                id:jiyi2_
                Mesh{
                    id:jiyi2
                    source: "qrc:/jiyi2.obj"
                }
                components: [jiyi2,b_w,en_tf]
            }
            Entity{
                id:engine_
                Mesh{
                    id:engine
                    source: "qrc:/engine.obj"
                }
                components: [engine,b_w,en_tf]
            }
            Entity{
                id:chuizhi_
                Mesh{
                    id:chuizhi
                    source: "qrc:/chuizhi.obj"
                }
                components: [chuizhi,b_w,en_tf]
            }
            Entity{
                id:shuiping_
                Mesh{
                    id:shuiping
                    source:"qrc:/shuiping.obj"
                }
                TexturedMetalRoughMaterial{
                    id:sp
                    baseColor: "white"
                }

                components: [shuiping,sp,en_tf]
            }
            Entity{
                id:electric
                Mesh{
                    id:power
                    source: "qrc:/power.obj"
                }
                PhongAlphaMaterial{
                    id:p_m
                    diffuse: "blue"
                    specular: "blue"
                    alpha: 0.8
                }
                Transform{
                    id:p_tf
                    property real y: -2.0
                    translation: Qt.vector3d(80,y,0)
                }
                components: [power,p_tf]
            }
                NumberAnimation{
                    id:p_na1
                    property bool ok: false
                    target: p_tf
                    property: "y"
                    from:-1
                    to:5
                    duration: 600
                    running: ok
                    onStarted: {
                        electric.components=[power,p_m,p_tf];
                    }

                    onStopped: {
                        ok=false;
                        ccr_l.components=[lccr,n_m,en_tf];
                        ccr_r.components=[rccr,n_m,en_tf];
                        ars_l.components=[lars,n_m,en_tf];
                        ars_r.components=[rars,n_m,en_tf];
                        //t1.color="blue";t2.color="blue";t5.color="blue";t6.color="blue";
                        p_na2.start();
                    }
                }
                NumberAnimation{
                    id:p_na2
                    target: p_tf
                    property: "y"
                    to:9
                    duration: 400
                    onStopped: {
                        rdc3.components=[rdc_3,n_m,en_tf];
                        rdc4.components=[rdc_4,n_m,en_tf];
                        //t4.color="blue";t8.color="blue";
                        p_na3.start();
                    }
                }
                NumberAnimation{
                    id:p_na3
                    target: p_tf
                    property: "y"
                    to:15
                    duration: 500
                    onStopped: {
                        rdc1.components=[rdc_1,n_m,en_tf];
                        rdc2.components=[rdc_2,n_m,en_tf];
                        //t3.color="blue";t7.color="blue";
                        electric.components=[power,p_tf];
                    }
                }

            Entity{
                id:neibu_
                Mesh{
                    id:neibu
                    source: "qrc:/neibu.obj"
                }
                PhongAlphaMaterial{
                    id:nb_p
                    diffuse: "white"
                    alpha: 0.5
                }
                components: [neibu,nb_p,en_tf]
            }
            PhongAlphaMaterial{//白色
                id:n_p
                diffuse: "white"
                //alpha: 0.5
            }
            PhongAlphaMaterial{//绿色
                id:n_m
                diffuse: "black"
                specular: "black"
                alpha: 1.0
            }
            SequentialAnimation{
                ColorAnimation{
                    target: n_m
                    property: "diffuse"
                    to:Qt.rgba(0,0.31,0,1)
                    duration: 500
                }
                ColorAnimation{
                    target: n_m
                    property: "diffuse"
                    to:"black"
                    duration: 500
                }
                running: true
                loops: Animation.Infinite
            }

            Entity{
                id:ccr_l
                Mesh{
                    id:lccr
                    source: "qrc:/CCR_L.obj"
                }
                components: [lccr,n_p,en_tf]
            }
            Entity{
                id:ccr_r
                Mesh{
                    id:rccr
                    source: "qrc:/CCR_R.obj"
                }

                components: [rccr,n_p,en_tf]
            }
            Entity{
                id:ars_l
                Mesh{
                    id:lars
                    source: "qrc:/ARS_L.obj"
                }
                components: [lars,n_p,en_tf]
            }
            Entity{
                id:ars_r
                Mesh{
                    id:rars
                    source: "qrc:/ARS_R.obj"
                }
                components: [rars,n_p,en_tf]
            }
            Entity{
                id:rdc1
                Mesh{
                    id:rdc_1
                    source: "qrc:/RDC1.obj"
                }
                components: [rdc_1,n_p,en_tf]
            }
            Entity{
                id:rdc2
                Mesh{
                    id:rdc_2
                    source: "qrc:/RDC2.obj"
                }
                components: [rdc_2,n_p,en_tf]
            }
            Entity{
                id:rdc3
                Mesh{
                    id:rdc_3
                    source: "qrc:/RDC3.obj"
                }
                components: [rdc_3,n_p,en_tf]
            }
            Entity{
                id:rdc4
                Mesh{
                    id:rdc_4
                    source: "qrc:/RDC4.obj"
                }
                components: [rdc_4,n_p,en_tf]
            }
            property string col: "transparent"
            Text2DEntity{
                id:t1
                text: qsTr("左CCR")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr1
                    translation: Qt.vector3d(0,-3,13)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y//-135//text是绕左边进行旋转
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr1_y
                        property bool ok: false
                        from:tr1.angle_y;to:tr1.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr1.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr1_x
                        property bool ok: false
                        from:tr1.angle_x;to:tr1.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr1.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr1]
            }
            Text2DEntity{
                id:t2
                text: qsTr("右CCR")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr2
                    translation: Qt.vector3d(0,-3,-15)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr2_y
                        property bool ok: false
                        from:tr2.angle_y;to:tr2.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr2.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr2_x
                        property bool ok: false
                        from:tr2.angle_x;to:tr2.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr2.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr2]
            }

            Text2DEntity{//后放的能把先放的挡住
                id:t3
                text: qsTr("RDC1")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr3
                    translation: Qt.vector3d(2,5,17.5)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr3_y
                        property bool ok: false
                        from:tr3.angle_y;to:tr3.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr3.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr3_x
                        property bool ok: false
                        from:tr3.angle_x;to:tr3.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr3.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr3]
            }
            Text2DEntity{
                id:t4
                text: qsTr("RDC3")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr4
                    translation: Qt.vector3d(2,0.5,17.5)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr4_y
                        property bool ok: false
                        from:tr4.angle_y;to:tr4.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr4.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr4_x
                        property bool ok: false
                        from:tr4.angle_x;to:tr4.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr4.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr4]
            }
            Text2DEntity{
                id:t5
                text: qsTr("左ARS")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr5
                    translation: Qt.vector3d(1,-3.5,18)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr5_y
                        property bool ok: false
                        from:tr5.angle_y;to:tr5.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr5.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr5_x
                        property bool ok: false
                        from:tr5.angle_x;to:tr5.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr5.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr5]
            }
            Text2DEntity{
                id:t6
                text: qsTr("右ARS")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr6
                    translation: Qt.vector3d(1,-3.5,-21)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr6_y
                        property bool ok: false
                        from:tr6.angle_y;to:tr6.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr6.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr6_x
                        property bool ok: false
                        from:tr6.angle_x;to:tr6.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr6.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr6]
            }
            Text2DEntity{
                id:t7
                text: qsTr("RDC2")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr7
                    translation: Qt.vector3d(-14,5.5,-7)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr7_y
                        property bool ok: false
                        from:tr7.angle_y;to:tr7.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr7.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr7_x
                        property bool ok: false
                        from:tr7.angle_x;to:tr7.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr7.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr7]
            }
            Text2DEntity{
                id:t8
                text: qsTr("RDC4")
                width: 5
                height: 1.6
                color: sceneRoot.col
                font.pointSize:1
                Transform{
                    id:tr8
                    translation: Qt.vector3d(-14,1.5,-7)//往机头是x负方向，往门是z正方向
                    property real angle_y: 0.0
                    property real angle_x: 0.0
                    rotationY: angle_y
                    rotationX: angle_x
                    NumberAnimation on rotationY {//y-  x+
                        id:tr8_y
                        property bool ok: false
                        from:tr8.angle_y;to:tr8.angle_y-45.0;running: ok;duration: 450;
                        onStopped: {tr8.angle_y-=45.0;ok=false;}
                    }
                    NumberAnimation on rotationX {
                        id:tr8_x
                        property bool ok: false
                        from:tr8.angle_x;to:tr8.angle_x+45.0;running: ok;duration: 450;
                        onStopped: {tr8.angle_x+=45.0;ok=false;}
                    }
                }
                components: [tr8]
            }

            SequentialAnimation{
                ColorAnimation{
                    target: material
                    property: "diffuse"
                    from :"black"
                    to:Qt.rgba(0.31,0,0,1)
                    duration: 400
                }
                ColorAnimation{
                    target: material
                    property: "diffuse"
                    from :Qt.rgba(0.31,0,0,1)
                    to:"black"
                    duration: 400
                }
                loops: Animation.Infinite
                running: true
           }


        }

    }

    MediaPlayer {
        id: playMusic
        source: "qrc:/1.wav"
    }

    TransObj{
        id:transobj
        objectName: "tran"
        onValFromCpp: {
            console.log("来自cpp的值是："+val);
            switch(val)
            {
            case 1:playMusic.play();rdc1.components=[rdc_1,material,en_tf];
                head.components=[head_mesh,h_m];t3.color="purple";break;
            case 2:ccr_l.components=[lccr,material,en_tf];playMusic.play();
                t1.color="purple";break;
            case 10:camera_y.ok=true;tr1_y.ok=true;tr2_y.ok=true;tr3_y.ok=true;
                tr4_y.ok=true;tr5_y.ok=true;tr6_y.ok=true;tr7_y.ok=true;tr8_y.ok=true;break;
            case 11:camera_x.ok=true;tr1_x.ok=true;tr2_x.ok=true;tr3_x.ok=true;
                tr4_x.ok=true;tr5_x.ok=true;tr6_x.ok=true;tr7_x.ok=true;tr8_x.ok=true;break;
            case 12:plane.components=[planeMesh,material2,en_tf];win.components=[window,en_tf];
                translate_x.ok=true;translate_z.ok=true;head.components=[head_mesh];
                env_light.enabled=false;p_light.enabled=false;light.able=true;
                sceneRoot.col="green";break;//查看组件
            case 13:p_na1.ok=true;sceneRoot.col="orange";break;
            }
        }
    }

    //MouseHandler 和 KeyboardHandler是好东西
}






