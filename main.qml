import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.0
import Qt.labs.settings 1.0

import LogView 1.1
import ControlsTime 1.0
import ViewNums 1.0

ApplicationWindow{
    id: app
    visible: true
    visibility: "Maximized"
    color: c1
    width: Screen.width
    property int fs: width*0.02
    property color c1: 'black'
    property color c2: 'white'
    Settings{
        id: apps
        fileName:'./numqui.cfg'
        property int wp: 600
    }
    Item{
        id: xApp
        anchors.fill: parent
        Row{
            anchors.centerIn: parent
            Rectangle{
                id: xControls
                width: apps.wp
                height: app.height
                color: 'black'
                //border.width: 10
                //border.color: 'red'
                Column{
                    spacing: app.fs*0.5
                    anchors.centerIn: parent
                    ControlsTime{
                        id: ct
                        fs: xControls.width*0.07//app.fs
                        //width: app.width*0.4
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Row{
                        spacing: app.fs*0.5
                        anchors.horizontalCenter: parent.horizontalCenter
                        ComboBox{
                            id: cbQuiniela
                            width: font.pixelSize*16
                            height: font.pixelSize*2
                            font.pixelSize: xControls.width*0.04
                            model: ['Ciudad/Ex Nacional', 'Provincia Buenos Aires', 'Santa Fé', 'Córdoba']
                        }
                        ComboBox{
                            id: cbMomento
                            width: font.pixelSize*8
                            height: font.pixelSize*2
                            font.pixelSize: xControls.width*0.04
                            model: ['Previa', 'Primera', 'Matutina', 'Vespertina', 'Nocturna']
                        }
                    }
                    Button{
                        text: 'Ver Resultados'
                        font.pixelSize: xControls.width*0.04
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            //let diaSemana = ct.getDay();
                            let fecha=ct.currentDate
                            let sd=''+ct.currentDate.getDate()
                            let sm=''+parseInt(ct.currentDate.getMonth() + 1)
                            let sy=''+ct.currentDate.getFullYear()
                            if(sd.length===1){
                                sd='0'+sd
                            }
                            if(sm.length===1){
                                sm='0'+sm
                            }
                            let squiniela=''
                            if(cbQuiniela.currentIndex===0){
                                squiniela='quiniela-nacional'
                            }
                            if(cbQuiniela.currentIndex===1){
                                squiniela='quiniela_provincia_buenos_aires'
                            }
                            if(cbQuiniela.currentIndex===2){
                                squiniela='quiniela_santa_fe'
                            }
                            if(cbQuiniela.currentIndex===3){
                                squiniela='quiniela_cordoba'
                            }
                            let smomento=''
                            if(cbMomento.currentIndex===0){
                                smomento='previa'
                            }
                            if(cbMomento.currentIndex===1){
                                smomento='primera'
                            }
                            if(cbMomento.currentIndex===2){
                                smomento='matutina'
                            }
                            if(cbMomento.currentIndex===3){
                                smomento='vespertina'
                            }
                            if(cbMomento.currentIndex===4){
                                smomento='nocturna'
                            }
                            getDatos(squiniela, sd+'/'+sm+'/'+sy, smomento)
                        }
                    }
                    Button{
                        text: 'Ver Estadísticas'
                        font.pixelSize: app.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            let sd=''+ct.currentDate.getDate()
                            let sm=''+parseInt(ct.currentDate.getMonth() + 1)
                            let sy=''+ct.currentDate.getFullYear()
                            if(sd.length===1){
                                sd='0'+sd
                            }
                            if(sm.length===1){
                                sm='0'+sm
                            }
                            getDatosParaRevisar(sd+'/'+sm+'/'+sy)
                        }
                    }
                    Button{
                        text: 'Limpiar'
                        font.pixelSize: app.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: log.clear()
                    }
                    Button{
                        text: 'Copiar'
                        font.pixelSize: app.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            let datos=log.copy()
                            //log.lv('Copy: '+datos)
                            clipboard.setText(datos)
                        }
                    }
                }
            }
            Column{
            Rectangle{
                id: xViewNums
                width: log.width
                height: app.height*0.5
                color: 'black'
                border.width: 1
                border.color: 'white'
                ViewNums{id: vn}
            }
            LogView{
                id: log
                app: app
                fs: log.width*0.03
                width: Screen.width-xControls.width
                height: !xViewNums.visible?app.height:app.height*0.5
                onWidthChanged:{
                    fs=log.width*0.03
                }
            }
            }
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: app.close()
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            if(apps.wp>xApp.width*0.2){
                apps.wp-=app.fs*0.5
            }
            log.fs=(Screen.width-xControls.width)*0.03
            log.width=Screen.width-xControls.width
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            if(apps.wp<xApp.width*0.6){
                apps.wp+=app.fs*0.5
            }
            log.fs=(Screen.width-xControls.width)*0.03
            log.width=Screen.width-xControls.width
        }
    }
    Item{id: uqps}
    Component.onCompleted: {
        //unik.cd('/home/ns/nsp/numpit')
        app.requestActivate()
    }
    function getDatos(quiniela, fecha, momento){
        let pyargs=fecha
        pyargs+=' '+quiniela
        let f='python3 /home/ns/nsp/numqui/getNumsQuin.py '+pyargs
        let c=''
        //c+='log.lv(logData)'
        c+='mostrar(logData, \''+quiniela+'\',\''+fecha+'\', \''+momento+'\')'
        mkCmd(f, c, uqps)
    }
    function mostrar(sj, quiniela, fecha, momento){
        let j=JSON.parse(sj)
        let cual=momento
        let items=j[cual]
        //log.lv(JSON.stringify(items))
        let sq=''
        if(quiniela==='quiniela-nacional'){
            sq='Quiniela Nacional'
        }
        if(quiniela==='quiniela_provincia_buenos_aires'){
            sq='Quiniela de la Provincia de Buenos Aires'
        }
        if(quiniela==='quiniela_cordoba'){
            sq='Quiniela de Córboba'
        }
        if(quiniela==='quiniela_santa_fe'){
            sq='Quiniela de Santa Fé'
        }
        let mq=''
        if(momento==='previa'){
            mq='Previa'
        }
        if(momento==='primera'){
            mq='Primera'
        }
        if(momento==='matutina'){
            mq='Matutina'
        }
        if(momento==='vespertina'){
            mq='Vespertina'
        }
        if(momento==='nocturna'){
            mq='Nocturna'
        }
        log.lv('\nResultados de la '+sq+' '+fecha+' '+mq)
        vn.t='<b>Resultados de la '+sq+' '+fecha+' '+mq+'</b>'
        let sjl='{"filas":{"f1":[0, 0], "f2":[0, 0],"f3":[0, 0],"f4":[0, 0],"f5":[0, 0],"f6":[0, 0],"f7":[0, 0],"f8":[0, 0],"f9":[0, 0],"f10":[0, 0]}}'
        let jlist=JSON.parse(sjl)
        for(var i=0;i<Object.keys(items.nums).length;i++){
            let num='????'
            if(items.nums[i]!==0){
                num=''+items.nums[i]
            }
            if(i<=9){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            /*if(i===1){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===2){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===3){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===4){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===5){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===6){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===7){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===8){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }
            if(i===9){
              jlist.filas["f"+parseInt(i + 1)][0]=num
            }*/

            //Comienzan los mayores de 10
            if(i>9){
              jlist.filas["f"+parseInt(i + 1 - 10)][1]=num
            }
            log.lv('°'+parseInt(i + 1)+': '+num)
        }
        //log.lv('json: '+JSON.stringify(jlist, null, 2))
        vn.load(jlist)

    }
    function getDatosParaRevisar(fecha){
        log.lv('Recolectando datos de todas las quinielas!!\nEsperar...')
        let pyargs='"'+fecha+'"'
        let f='python3 /home/ns/nsp/numqui/getNumsQuinTodo.py '+pyargs
        //log.lv('cmd: '+f)
        let c='\n'
        c+='//log.lv(logData)\n'
        c+='recolectarDatos(""+logData)'
        c+='\n'
        mkCmd(f, c, uqps)
    }
    function recolectarDatos(sj){
        let aRes=[]
        let j={}
        try {
            j = JSON.parse(sj);
            log.lv("Los datos se han recibido correctamente.\nProcesando...");  // Si es válido, se imprime
        } catch (error) {
            //log.lv("Error al parsear el JSON:", error.message);
            //log.lv("sj: "+sj);
            log.lv("Hubo un error por problemas de red.\nSon muchos datos para procesar.\nReintentar.");
            return
        }
        //let j=JSON.parse(sj)
        //log.lv(sj)
        //log.lv(JSON.stringify(j, null, 2))

        let cantRes=j['resultados'].length
        //log.lv('cantRes: '+cantRes)
        //return

        let s=''
        for(var i=0;i<cantRes;i++){
            let res=j['resultados'][i]
            //if(!res || !res.previa)continue
            let resMom=res.previa
            for(var i2=0;i2<resMom.nums.length;i2++){
                let num=resMom.nums[i2]
                if(num!==0){
                    //log.lv('r'+i2+': '+num)
                    aRes.push(num)
                }
            }
            resMom=res.primera
            for(i2=0;i2<resMom.nums.length;i2++){
                let num=resMom.nums[i2]
                if(num!==0){
                    //log.lv('r'+i2+': '+num)
                    aRes.push(num)
                }
            }
            resMom=res.matutina
            for(i2=0;i2<resMom.nums.length;i2++){
                let num=resMom.nums[i2]
                if(num!==0){
                    //log.lv('r'+i2+': '+num)
                    aRes.push(num)
                }
            }
            resMom=res.vespertina
            for(i2=0;i2<resMom.nums.length;i2++){
                let num=resMom.nums[i2]
                if(num!==0){
                    //log.lv('r'+i2+': '+num)
                    aRes.push(num)
                }
            }
            resMom=res.nocturna
            for(i2=0;i2<resMom.nums.length;i2++){
                let num=resMom.nums[i2]
                if(num!==0){
                    //log.lv('r'+i2+': '+num)
                    aRes.push(num)
                }
            }
        }
        log.lv('Calculando...')
        calcularDatos(aRes)
    }
    function calcularDatos(aRes){
        log.lv('Recolectando datos de todas las quinielas!!\nEsperar...')
        let pyargs=''
        for(var i=0;i<aRes.length;i++){
            if(i===0){
                pyargs+=''+aRes[i]
            }else{
                pyargs+=' '+aRes[i]
            }

        }
        let f='python3 /home/ns/nsp/numqui/calc.py "'+pyargs+'"'
        //log.lv('cmd: '+f)
        let c='\n'
        c+='log.clear()\n'
        c+='log.lv(""+logData)\n'
        c+='\n'
        mkCmd(f, c, uqps)
    }
    function mkCmd(finalCmd, code, item){
        for(var i=0;i<item.children.length;i++){
            item.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        '+code+'\n'
        c+='        uqp'+ms+'.destroy(3000)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        log.ls(\'finalCmdRS: '+finalCmd+'\', 0, 500)\n'
        c+='        run(\''+finalCmd+'\')\n'
        c+='    }\n'
        c+='}\n'
        //console.log(c)
        //log.lv(c)
        let comp=Qt.createQmlObject(c, item, 'uqpcodecmdrslist')
    }

}
