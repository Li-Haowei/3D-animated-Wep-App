<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>My Web Tool</title>
    <asset:javascript src="three.js"/>
    <asset:javascript src="OrbitControls.js"/>
    <asset:javascript src="dat.gui.min.js.js"/>
    <asset:javascript src="stats.min.js"/>
    <asset:javascript src="EffectComposer.js"/>
    <asset:javascript src="RenderPass.js"/>
    <asset:javascript src="CopyShader.js"/>
    <asset:javascript src="ShaderPass.js"/>
    <asset:javascript src="MaskPass.js"/>
    <asset:javascript src="chroma.min.js"/>
    <style>
        .center {
            display: flex;
            justify-content: center;
            height: 70%
        }
        #three-container{
            border-radius: 50%;
            height: 100%;
            width: 60%
        }
        #gui{
            position:absolute;
            top: 85px;
            left: 80%
        }
    </style>
</head>
<body>
<!--Top toolbar-->
<content tag="nav" >
    <!--Communication dropdown list-->
    <li class="dropdown allYellow">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" >Communication<span class="caret"></span></a>
        <ul class="dropdown-menu"   style="background: #eac086">
            <li class="dropdown-item"><a href="https://mail.google.com/mail/u/0/#inbox" target="_blank">My School Gmail</a></li>
            <li class="dropdown-item"><a href="https://mail.google.com/mail/u/1/#inbox" target="_blank">My Personal Gmail</a></li>
            <li class="dropdown-item"><a href="https://www.linkedin.com/in/haowei-li-084614164/" target="_blank">My LinkedIn</a></li>
            <li class="dropdown-item"><a href="https://github.com/Li-Haowei" target="_blank">My GitHub</a></li>
            <li class="dropdown-item"><a href="https://dev-haowei.pantheonsite.io/" target="_blank">My Personal Website</a></li>
        </ul>
    </li>
    <!--Helpful Software dropdown list-->
    <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Helpful Links<span class="caret"></span></a>
        <ul class="dropdown-menu"   style="background: #eac086">
            <li class="dropdown-item"><a href="https://learn.bu.edu/ultra/course" target="_blank">BlackBoard</a></li>
            <li class="dropdown-item"><a href="https://www.bu.edu/link/bin/uiscgi_studentlink.pl/1598588346?applpath=menu.pl&NewMenu=Home" target="_blank">Student Link</a></li>
            <li class="dropdown-item"><a href="https://www.youtube.com/" target="_blank">YouTube</a></li>
            <li class="dropdown-item"><a href="https://www.amazon.com/" target="_blank">Amazon</a></li>
            <li class="dropdown-item"><a href="https://www.gradescope.com/" target="_blank">GradeScope</a></li>
        </ul>
    </li>
    <!--Information about the web app-->
    <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">About <span class="caret"></span></a>
        <ul class="dropdown-menu dropdown-menu-right"   style="background: #eac086">
            <li class="dropdown-item"><a href="#">Controllers: ${grailsApplication.controllerClasses.size()}</a></li>
            <li class="dropdown-item"><a href="#">Domains: ${grailsApplication.domainClasses.size()}</a></li>
            <li class="dropdown-item"><a href="#">Services: ${grailsApplication.serviceClasses.size()}</a></li>
            <li class="dropdown-item"><a href="#">Tag Libraries: ${grailsApplication.tagLibClasses.size()}</a></li>
            <g:each var="plugin" in="${applicationContext.getBean('pluginManager').allPlugins}">
                <li class="dropdown-item"><a href="#">${plugin.name} - ${plugin.version}</a></li>
            </g:each>
        </ul>
    </li>
</content>



<div class="center" style="background: black" >
    <div id="three-container">
        <%--<asset:image src="grails-cupsonly-logo-white.svg" class="grails-logo"/>--%>
    </div>
</div>
<!--Spinning sphere-->
<script>

    // global variables
    let renderer;
    let scene;
    let camera;
    let control;
    let stats;
    let cameraControl;

    //background variable

    let cameraBG;
    let sceneBG;
    let composer;
    let clock;
    let canvas;

    /**
     * Initializes the scene, camera and objects. Called when the window is
     * loaded by using window.onload (see below)
     */
    function init() {
        clock = new THREE.Clock();

        // create a scene, that will hold all our elements such as objects, cameras and lights.
        scene = new THREE.Scene();

        // create a camera, which defines where we're looking at.
        camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);

        // create a render, sets the background color and the size
        renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(0x000000, 1.0);
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.shadowMapEnabled = true;

        // create a sphere
        const sphereGeometry = new THREE.SphereGeometry(15, 30, 30);
        const sphereMaterial = createEarthMaterial(); //new THREE.MeshNormalMaterial();
        const earthMesh = new THREE.Mesh(sphereGeometry, sphereMaterial);
        earthMesh.name = 'earth';
        scene.add(earthMesh);

        // create overlay

        const overlayGeometry = new THREE.SphereGeometry(15, 60, 60);
        const overlayMaterial = createOverlayMaterial();
        const overlayMesh = new THREE.Mesh(overlayGeometry, overlayMaterial);
        overlayMesh.name= 'overlay';
        scene.add(overlayMesh);

        // create a cloudGeometry, slighly bigger than the original sphere
        const cloudGeometry = new THREE.SphereGeometry(15.3, 60, 60);
        const cloudMaterial = createCloudMaterial();
        const cloudMesh = new THREE.Mesh(cloudGeometry, cloudMaterial);
        cloudMesh.name = 'clouds';
        scene.add(cloudMesh);

        //addCanvas()

        // now add some better lighting
        const ambientLight = new THREE.AmbientLight(0x111111);
        ambientLight.name='ambient';
        scene.add(ambientLight);

        // add sunlight (light
        const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
        directionalLight.position = new THREE.Vector3(100,10,-50);
        directionalLight.name='directional';
        scene.add(directionalLight);


        // position and point the camera to the center of the scene
        camera.position.x = 25;
        camera.position.y = 10;
        camera.position.z = 63;
        camera.lookAt(scene.position);

        // add controls
        cameraControl = new THREE.OrbitControls(camera);

        // setup the control object for the control gui
        control = new function () {
            this.earthRotationSpeed = 0.005;
            this.cloudRotationSpeed = 0.01;
            //this.opacity = 0.6;
            this.ambientLightColor = ambientLight.color.getHex();
            this.directionalLightColor = directionalLight.color.getHex();
        };

        // add extras
        addControlGui(control);
        //addStatsObject(); //removed stats

        // add background
        cameraBG = new THREE.OrthographicCamera(-window.innerWidth, window.innerWidth, window.innerHeight, -window.innerHeight, -10000, 10000);
        cameraBG.position.z = 50;
        sceneBG = new THREE.Scene();


        const materialColor = new THREE.MeshBasicMaterial({
            map: THREE.ImageUtils.loadTexture('/assets/starry_background.jpg'),
            depthTest: false
        });
        const bgPlane = new THREE.Mesh(new THREE.PlaneGeometry(1, 1), materialColor);
        bgPlane.position.z = -100;
        bgPlane.scale.set(window.innerWidth * 2, window.innerHeight * 2, 1);
        sceneBG.add(bgPlane);

        const bgPass = new THREE.RenderPass(sceneBG, cameraBG);
        // next render the scene (rotating earth), without clearing the current output
        const renderPass = new THREE.RenderPass(scene, camera);
        renderPass.clear = false;
        // finally copy the result to the screen
        const effectCopy = new THREE.ShaderPass(THREE.CopyShader);
        effectCopy.renderToScreen = true;
        // add these passes to the composer
        composer = new THREE.EffectComposer(renderer);
        composer.addPass(bgPass);
        composer.addPass(renderPass);
        composer.addPass(effectCopy);
        // add the output of the renderer to the html element
        document.body.appendChild(renderer.domElement);



        // add the output of the renderer to the html element
        document.body.appendChild(renderer.domElement);

        // call the render function, after the first render, interval is determined
        // by requestAnimationFrame
        render();
    }

    function createEarthMaterial() {
        // 4096 is the maximum width for maps
        const earthTexture = THREE.ImageUtils.loadTexture("/assets/earthmap4k.jpg");
        const bumpMap = THREE.ImageUtils.loadTexture("/assets/earthbump4k.jpg");
        const specularMap = THREE.ImageUtils.loadTexture("/assets/earthspec4k.jpg");
        const normalMap = THREE.ImageUtils.loadTexture("/assets/earth_normalmap_flat4k.jpg");

        //RGB information
        const earthMaterial = new THREE.MeshPhongMaterial();
        earthMaterial.map = earthTexture;

        // specular defines the reflection of the surface
        earthMaterial.specularMap = specularMap;
        earthMaterial.specular = new THREE.Color(0x262626);

        // normalmap
        earthMaterial.normalMap = normalMap;
        earthMaterial.normalScale = new THREE.Vector2(0.5, 0.7);

        return earthMaterial;
    }


    function createCloudMaterial() {
        const cloudTexture = THREE.ImageUtils.loadTexture("/assets/fair_clouds_4k.png");

        const cloudMaterial = new THREE.MeshPhongMaterial();
        cloudMaterial.map = cloudTexture;
        cloudMaterial.transparent = true;

        return cloudMaterial;
    }

    function addControlGui(controlObject) {
        const gui = new dat.GUI();
        //const gui = new dat.GUI( { autoPlace: false } );
        gui.add(controlObject, 'earthRotationSpeed', -0.01, 0.01);
        gui.add(controlObject, 'cloudRotationSpeed', -0.01, 0.01);
        gui.addColor(controlObject, 'ambientLightColor');
        gui.addColor(controlObject, 'directionalLightColor');
        //gui.domElement.id = 'gui';
    }

    function addStatsObject() {
        stats = new Stats();
        stats.setMode(0);

        //stats.domElement.style.position = 'absolute';
        stats.domElement.style.left = '0px';
        stats.domElement.style.top = '0px';

        document.body.appendChild(stats.domElement);
    }


    /**
     * Called when the scene needs to be rendered. Delegates to requestAnimationFrame
     * for future renders
     */
    function render() {
        scene.getObjectByName('overlay').material.map.needsUpdate = true;

        //imbed into selected item
        let container = document.getElementById('three-container');
        renderer.setSize($(container).width(), $(container).height());
        container.appendChild(renderer.domElement);

        // update stats
        //stats.update();

        resizeCanvasToDisplaySize();
        // update the camera

        cameraControl.update();

        //rotation
        scene.getObjectByName('earth').rotation.y+=control.earthRotationSpeed;
        scene.getObjectByName('overlay').rotation.y += control.earthRotationSpeed;
        scene.getObjectByName('clouds').rotation.y+=control.cloudRotationSpeed;

        // update light colors
        scene.getObjectByName('ambient').color = new THREE.Color(control.ambientLightColor);
        scene.getObjectByName('directional').color = new THREE.Color(control.directionalLightColor);


        // and render the scene
        renderer.render(scene, camera);

        renderer.autoClear = false;
        composer.render();
        // render using requestAnimationFrame
        requestAnimationFrame(render);
    }


    /**
     * Function handles the resize event. This make sure the camera and the renderer
     * are updated at the correct moment.
     */
    function handleResize() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    function resizeCanvasToDisplaySize() {
        const canvas = renderer.domElement;
        // look up the size the canvas is being displayed
        const width = canvas.clientWidth;
        const height = canvas.clientHeight;

        // adjust displayBuffer size to match
        if (canvas.width !== width || canvas.height !== height) {
            // you must pass false here or three.js sadly fights the browser
            renderer.setSize(width, height, false);
            camera.aspect = width / height;
            camera.updateProjectionMatrix();

            // update any render target sizes here
        }
    }

    function createOverlayMaterial() {
        const olMaterial = new THREE.MeshPhongMaterial();
        olMaterial.map = new THREE.Texture(addCanvas());
        olMaterial.transparent = true;
        olMaterial.opacity = 0.6;
        return olMaterial;
    }

    function addCanvas() {
        canvas = document.createElement("canvas");
        canvas.width=4096;
        canvas.height=2048;

        const context = canvas.getContext('2d');

        const xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                var ports = CSVToArray(xmlhttp.responseText,";");
                ports.forEach(function(e) {

                    if (e[25] === 'L') {
                        var posY = parseFloat( e[4] + "." + e[5]);
                        var sign = e[6];
                        if (sign === 'S') posY = posY*-1;


                        var posX = parseFloat( e[7] + "." + e[8]);
                        var sign = e[9];
                        if (sign === 'W') posX = posX*-1;

                        var x2 =   ((4096/360.0) * (180 + posX));
                        var y2 =   ((2048/180.0) * (90 - posY));

                        context.beginPath();
                        context.arc(x2, y2, 4, 0, 2 * Math.PI, false);
                        context.fillStyle = 'red';
                        context.fill();

                        context.fill();
                        context.lineWidth = 2;
                        context.strokeStyle = '#003300';
                        context.stroke();
                    }
                });
            }
        }

        xmlhttp.open("GET", "/assets/wpi.csv", true);
        xmlhttp.send();

        return canvas;
    }
    function CSVToArray( strData, strDelimiter ){
        // Check to see if the delimiter is defined. If not,
        let strMatchedValue;
        // then default to comma.
        strDelimiter = (strDelimiter || ",");

        // Create a regular expression to parse the CSV values.
        const objPattern = new RegExp(
            (
                // Delimiters.
                "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +

                // Quoted fields.
                "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +

                // Standard fields.
                "([^\"\\" + strDelimiter + "\\r\\n]*))"
            ),
            "gi"
        );


        // Create an array to hold our data. Give the array
        // a default empty first row.
        const arrData = [[]];

        // Create an array to hold our individual pattern
        // matching groups.
        let arrMatches = null;


        // Keep looping over the regular expression matches
        // until we can no longer find a match.
        while (arrMatches = objPattern.exec( strData )){

            // Get the delimiter that was found.
            const strMatchedDelimiter = arrMatches[1];

            // Check to see if the given delimiter has a length
            // (is not the start of string) and if it matches
            // field delimiter. If id does not, then we know
            // that this delimiter is a row delimiter.
            if (
                strMatchedDelimiter.length &&
                (strMatchedDelimiter != strDelimiter)
            ){

                // Since we have reached a new row of data,
                // add an empty row to our data array.
                arrData.push( [] );

            }


            // Now that we have our delimiter out of the way,
            // let's check to see which kind of value we
            // captured (quoted or unquoted).
            if (arrMatches[ 2 ]){

                // We found a quoted value. When we capture
                // this value, unescape any double quotes.
                strMatchedValue = arrMatches[2].replace(
                    new RegExp("\"\"", "g"),
                    "\""
                );

            } else {

                // We found a non-quoted value.
                strMatchedValue = arrMatches[3];

            }


            // Now that we have our value string, let's add
            // it to the data array.
            arrData[ arrData.length - 1 ].push( strMatchedValue );
        }

        // Return the parsed data.
        return( arrData );
    }


    // calls the init function when the window is done loading.
    window.onload = init;
    // calls the handleResize function when the window is resized
    //window.addEventListener('resize', handleResize, false);

</script>

</body>
</html>
