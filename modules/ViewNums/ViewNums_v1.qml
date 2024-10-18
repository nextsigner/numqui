import QtQuick 2.0

Rectangle{
    id: r
    anchors.fill: parent
    color: 'black'
    property string t: 'Quiniela'
    Column{
        Rectangle{
            width: r.width
            height: r.height/11
            color: 'black'
            border.width: 2
            border.color: tit.color
            Text{
                id: tit
                text: r.t
                font.pixelSize: r.width*0.04
                color: 'white'
                anchors.centerIn: parent
            }
            Timer{
                running: tit.contentWidth>r.width-app.fs
                repeat: true
                interval: 100
                onTriggered: tit.font.pixelSize-=4
            }
        }
        ListView{
            id: lv
            width: r.width
            height: r.height-(r.height/11)
            model: lm
            delegate: comp
        }
    }
    ListModel{
        id: lm
        function add(vNp1, vNc1, vNp2, vNc2){
            return{
                np1:vNp1,
                np2:vNp2,
                nc1:vNc1,
                nc2:vNc2
            }
        }
    }
    Component{
        id: comp
        Rectangle{
            id: xItem
            width: r.width
            height: r.height/11
            color: '#333'
            //border.width: 4
            //border.color: txt1.color
            Row{
                Rectangle{
                    width: xItem.width*0.5
                    height: xItem.height
                    color: 'transparent'
                    border.width: 1
                    Row{
                        //spacing: xItem.height*0.8
                        anchors.centerIn: parent
                        Rectangle{
                            width: xItem.width*0.15
                            height: xItem.height
                            color: '#333'
                            border.width: 2
                            border.color: np1===1?txt1.color:'white'
                            SequentialAnimation on color{
                                running: np1===1
                                loops: Animation.Infinite
                                ColorAnimation {
                                    from: "gray"
                                    to: "black"
                                    duration: 200
                                }
                                ColorAnimation {
                                    from: "black"
                                    to: "gray"
                                    duration: 200
                                }
                            }
                            Text{
                                id: txt1
                                text: '°<b>'+np1+'</b>'
                                font.pixelSize: xItem.height*0.8
                                color: 'white'
                                anchors.centerIn: parent
                                SequentialAnimation on color{
                                    running: np1===1
                                    loops: Animation.Infinite
                                    ColorAnimation {
                                        from: "white"
                                        to: "red"
                                        duration: 200
                                    }
                                    ColorAnimation {
                                        from: "red"
                                        to: "yellow"
                                        duration: 200
                                    }
                                    ColorAnimation {
                                        from: "yellow"
                                        to: "white"
                                        duration: 200
                                    }
                                }
                            }
                        }
                        Rectangle{
                            width: xItem.width*0.35
                            height: xItem.height
                            color: '#333'
                            border.width: 2
                            border.color: np1===1?txt1.color:'white'
                            Text{
                                text: nc1
                                font.pixelSize: xItem.height*0.8
                                color: txt1.color
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
                Rectangle{
                    width: xItem.width*0.5
                    height: xItem.height
                    color: 'transparent'
                    border.width: 1
                    Row{
                        //spacing: xItem.height*0.8
                        anchors.centerIn: parent
                        Rectangle{
                            width: xItem.width*0.15
                            height: xItem.height
                            color: '#333'
                            border.width: 2
                            border.color: 'white'
                            Text{
                                text: '°<b>'+np2+'</b>'
                                font.pixelSize: xItem.height*0.8
                                color: 'white'
                                anchors.centerIn: parent
                            }
                        }
                        Rectangle{
                            width: xItem.width*0.35
                            height: xItem.height
                            color: '#333'
                            border.width: 2
                            border.color: 'white'
                            Text{
                                text: nc2
                                font.pixelSize: xItem.height*0.8
                                color: 'white'
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {

    }
    function load(j){
        lm.clear()
        //log.lv(JSON.stringify(j, null, 2))
        for(var i=0;i<10;i++){
            let f=j.filas['f'+parseInt(i + 1)]
            lm.append(lm.add(i+1,f[0], i+11, f[1]))
        }
    }
}
