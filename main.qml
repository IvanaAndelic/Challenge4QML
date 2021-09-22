import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.15
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.15

Window {
    id:window
    width: 1080
    height: 1060
    visible: true
    color:'black'
    title: qsTr("Hello World")
    property bool isFullScreen:false
    property bool isClicked:false



    XmlListModel {
        id: xmlModel
        source: "movies_video.xml"
        query: "/channels/channel"

        XmlRole { name: "uid"; query: "uid/string()" }
        XmlRole { name: "url"; query: "url/string()" }

    }

    GridLayout{
        id:grid
       // anchors.fill:parent
        width:parent.width
        height:parent.height
        //rows:1
        //columns:2
        rowSpacing: 5
        flow:GridLayout.TopToBottom
        property bool isLandscape:parent.width>parent.height
        rows:isLandscape?1:2
        columns:isLandscape ? 2 : 1

        onFlowChanged: {
            if(rows===2 && columns===1){
                flow=GridLayout.TopToBottom
                video.height=500
                video.width=300
            }
            else if(columns===2 && rows===1){
                flow=GridLayout.LeftToRight
                video.height=1060
                video.width=parent.width*0.5

            }
        }

        Video{
                 id:video
                 //width:500
                 //height:300
                 //anchors.left:parent
                 autoLoad: true
                 autoPlay: true
                 width:isFullScreen? 1080 : 500
                 height:isFullScreen?1060 : 300
                 Layout.fillHeight: isFullScreen
                 Layout.fillWidth: isFullScreen


                 Image{
                     id:img1
                     width:parent.width/5
                     height:parent.height/5
                     anchors.centerIn: parent
                     source:'qrc:play-circle-outline.svg'
                     opacity:timer1.running?1.0:0.0
                     Behavior on opacity {
                         PropertyAnimation { duration: 5000 }
                     }

                     Timer{
                         id:timer1
                         interval:5000
                  }


                       MouseArea{
                        anchors.fill:parent
                        onClicked:{
                            if(video.playbackState===1){
                                  timer1.start()
                                  video.pause()
                                  img1.source='qrc:play-circle-outline.svg'

                                }else if(video.playbackState===2){
                                  video.play()
                                  img1.source='qrc:pause-outline.svg'
                                  timer1.stop()


                               }
                          }
                       }

                   }

                 Image{
                     id:img2
                     width:parent.width/5
                     height:parent.height/5
                     anchors.bottom:video.bottom
                     anchors.right:video.right
                     source: isFullScreen? 'qrc:enter-outline.svg':'qrc:exit-outline.svg'
                     opacity:timer2.running?1.0:0.0
                     Behavior on opacity {
                         PropertyAnimation { duration: 5000 }
                     }

                     Timer{
                         id:timer2
                         interval:5000
                     }


                     MouseArea{
                        anchors.fill:parent

                          onClicked:{
                              timer2.start()
                              isFullScreen=!isFullScreen
                              //timer2.stop()

                          }


                      }

                 }

      }



    ListView{
        id:list
        width: isFullScreen ? 0 : video.width
        height:isFullScreen ? 0 : parent.height-video.height
        model:xmlModel
        //clip:true
       // orientation:ListView.Vertical
        spacing:1
        //anchors.top:video.bottom
        focus:true
        keyNavigationEnabled: true
        keyNavigationWraps:true
        Layout.fillHeight:true
        visible:isFullScreen?false:true

        delegate: Rectangle{
            id:rect
            width:list.width
            height:list.height/8
            color:focus?"red":"black"
            //anchors.top:video.bottom

            onFocusChanged:{
                if(focus){
                  console.log("fokus")
                  list.currentIndex=index
                  video.source=url
                  video.play()
                }
            }



           // property bool isCurrent: list.currentIndex === index


            Text{
               id:text1
               text:uid
               color:'white'
               font.pointSize: 14
               anchors.centerIn: rect
            }

            MouseArea{
                id:mouse
                anchors.fill:parent

                onClicked:{
                    list.currentIndex=index
                    console.log("klik"+ url)
                    video.source=url
                    video.play()
                    console.log(video.playbackState)
                }
            }
        }

   }
  }
}
