<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>My Web Tool</title>
    <asset:javascript src="three.js"/>
    <asset:javascript src="OrbitControls.js"/>
    <asset:javascript src="stats.min.js"/>
    <asset:javascript src="dat.gui.min.js.js"/>
    <asset:javascript src="EffectComposer.js"/>
    <asset:javascript src="RenderPass.js"/>
    <asset:javascript src="CopyShader.js"/>
    <asset:javascript src="ShaderPass.js"/>
    <asset:javascript src="MaskPass.js"/>
    <style>
        .center {
            display: flex;
            justify-content: center;
        }
    </style>
</head>
<body>
<!--Top tool bar-->
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
<div id="bgImg" hidden><asset:image src="starry_background.jpg" /></div>

<div id="content" role="main">
    <div class="container">
        <section class="row colset-2-its">
            <h1>Welcome to Haowei's Web Tool</h1>
        </section>
    </div>
</div>
<div class="svg center" role="presentation" style="height: 46.3%">
    <div id="three-container" style="height: 60%; width: 50%">
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
        var sphereGeometry = new THREE.SphereGeometry(15, 30, 30);
        var sphereMaterial = new THREE.MeshNormalMaterial();
        var earthMesh = new THREE.Mesh(sphereGeometry, sphereMaterial);
        earthMesh.name = 'earth';
        scene.add(earthMesh);

        // position and point the camera to the center of the scene
        camera.position.x = 35;
        camera.position.y = 36;
        camera.position.z = 33;
        camera.lookAt(scene.position);

        // add controls
        cameraControl = new THREE.OrbitControls(camera);

        // add background
        cameraBG = new THREE.OrthographicCamera(-window.innerWidth, window.innerWidth, window.innerHeight, -window.innerHeight, -10000, 10000);
        cameraBG.position.z = 50;
        sceneBG = new THREE.Scene();
        let backgroundImg = document.getElementById('bgImg').getAttribute('url');

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

        // setup the control object for the control gui
        control = new function () {
            this.rotationSpeed = 0.005;
            this.opacity = 0.6;
        };

        // add extras
        //addControlGui(control); removed controls
        //addStatsObject(); //removed stats


        // add the output of the renderer to the html element
        document.body.appendChild(renderer.domElement);

        // call the render function, after the first render, interval is determined
        // by requestAnimationFrame
        render();
    }


    function addControlGui(controlObject) {
        var gui = new dat.GUI();
        gui.domElement.style.left = '0px';
        gui.domElement.style.top = '0px';
        gui.add(controlObject, 'rotationSpeed', -0.01, 0.01);
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
        //imbed into selected item
        let container = document.getElementById('three-container');
        renderer.setSize($(container).width(), $(container).height());
        container.appendChild(renderer.domElement);

        // update stats
        //stats.update();

        resizeCanvasToDisplaySize();
        // update the camera

        cameraControl.update();

        scene.getObjectByName('earth').rotation.y+=control.rotationSpeed;

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

    // calls the init function when the window is done loading.
    window.onload = init;
    // calls the handleResize function when the window is resized
    window.addEventListener('resize', handleResize, false);

</script>

<%--
            <script>

                // global variables
                var renderer;
                var scene;
                var camera;
                var control;
                var stats;
                var cameraControl;

                // background stuff
                var cameraBG;
                var sceneBG;
                var composer;
                var clock;
                var canvas;

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
                    var sphereGeometry = new THREE.SphereGeometry(15, 60, 60);
                    var sphereMaterial = createEarthMaterial();
                    var earthMesh = new THREE.Mesh(sphereGeometry, sphereMaterial);
                    earthMesh.name = 'earth';
                    scene.add(earthMesh);

                    //console.log(sphereGeometry);

                    // create a cloudGeometry, slighly bigger than the original sphere
                    var cloudGeometry = new THREE.SphereGeometry(15.2, 60, 60);
                    var cloudMaterial = createCloudMaterial();
                    var cloudMesh = new THREE.Mesh(cloudGeometry, cloudMaterial);
                    cloudMesh.name = 'clouds';
                    scene.add(cloudMesh);




                    // now add some better lighting
                    var ambientLight = new THREE.AmbientLight(0x111111);
                    ambientLight.name = 'ambient';
                    scene.add(ambientLight);

                    // add sunlight (light
                    var directionalLight = new THREE.DirectionalLight(0xffffff, 1);
                    directionalLight.position = new THREE.Vector3(200, 10, -50);
                    directionalLight.name = 'directional';
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
                        this.rotationSpeed = 0.001;
                        this.ambientLightColor = ambientLight.color.getHex();
                        this.directionalLightColor = directionalLight.color.getHex();
                    };

                    // add extras
                    addControlGui(control);
                    addStatsObject();


                    // add background using a camera
                    cameraBG = new THREE.OrthographicCamera(-window.innerWidth, window.innerWidth, window.innerHeight, -window.innerHeight, -10000, 10000);
                    cameraBG.position.z = 50;
                    sceneBG = new THREE.Scene();
                    //src="textures/planets/starry_background.jpg"
                    var materialColor = new THREE.MeshBasicMaterial({ map: THREE.ImageUtils.loadTexture(), depthTest: false });

                    var bgPlane = new THREE.Mesh(new THREE.PlaneGeometry(1, 1), materialColor);
                    bgPlane.position.z = -100;
                    bgPlane.scale.set(window.innerWidth * 2, window.innerHeight * 2, 1);
                    sceneBG.add(bgPlane);

                    // setup the composer steps
                    // first render the background
                    var bgPass = new THREE.RenderPass(sceneBG, cameraBG);
                    // next render the scene (rotating earth), without clearing the current output
                    var renderPass = new THREE.RenderPass(scene, camera);
                    renderPass.clear = false;
                    // finally copy the result to the screen
                    var effectCopy = new THREE.ShaderPass(THREE.CopyShader);
                    effectCopy.renderToScreen = true;

                    // add these passes to the composer
                    composer = new THREE.EffectComposer(renderer);
                    composer.addPass(bgPass);
                    composer.addPass(renderPass);
                    composer.addPass(effectCopy);

                    // add the output of the renderer to the html element
                    document.body.appendChild(renderer.domElement);

                    // call the render function, after the first render, interval is determined
                    // by requestAnimationFrame
                    render();
                }


                function createEarthMaterial() {
                    // 4096 is the maximum width for maps
                    var earthTexture = THREE.ImageUtils.loadTexture("textures/planets/earthmap4k.jpg");
                    var bumpMap = THREE.ImageUtils.loadTexture("textures/planets/earthbump4k.jpg");
                    var specularMap = THREE.ImageUtils.loadTexture("textures/planets/earthspec4k.jpg");
                    var normalMap = THREE.ImageUtils.loadTexture("textures/planets/earth_normalmap_flat4k.jpg");

                    var earthMaterial = new THREE.MeshPhongMaterial();
                    earthMaterial.map = earthTexture;

                    // specular defines the reflection of the surface
                    earthMaterial.specularMap = specularMap;
                    earthMaterial.specular = new THREE.Color(0x262626);

                    // normalmap
                    earthMaterial.normalMap = normalMap;
                    earthMaterial.normalScale = new THREE.Vector2(0.5, 0.7);


                    return earthMaterial;
                }

                function createOverlayMaterial() {
                    var olMaterial = new THREE.MeshPhongMaterial();
                    olMaterial.map = new THREE.Texture(addCanvas());
                    olMaterial.map.needsUpdate = true;
                    olMaterial.transparent = true;
                    olMaterial.opacity = 0.6;
                    return olMaterial;
                }

                function addCanvas() {
                    canvas = document.createElement("canvas");
                    canvas.width=4096;
                    canvas.height=2048;

                    var context = canvas.getContext('2d');

                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {

                            var ports = CSVToArray(xmlhttp.responseText,";");
//            console.log(ports[0]);
                            // 4 and 5 combined are x together with 6 for sign
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


                            // 7 and 8 combined are y together with 9 for sign
                        }
                    }

                    xmlhttp.open("GET", "../assets/data/wpi.csv", true);
                    xmlhttp.send();

                    //get the data, and set the offset, we need to do this since the x,y coordinates
                    //from the data aren't in the correct format
//    var x = 4.29;
//    var y = 51.54;


//    document.body.appendChild(canvas);


                    return canvas;
                }

                function createCloudMaterial() {
                    var cloudTexture = THREE.ImageUtils.loadTexture("../assets/textures/planets/fair_clouds_4k.png");

                    var cloudMaterial = new THREE.MeshPhongMaterial();
                    cloudMaterial.map = cloudTexture;
                    cloudMaterial.transparent = true;
                    cloudMaterial.opacity = 0.5;
                    cloudMaterial.blending = THREE.AdditiveBlending;

                    return cloudMaterial;
                }

                function addControlGui(controlObject) {
                    var gui = new dat.GUI();
                    gui.add(controlObject, 'rotationSpeed', -0.01, 0.01);
                    gui.addColor(controlObject, 'ambientLightColor');
                    gui.addColor(controlObject, 'directionalLightColor');
                }

                function addStatsObject() {
                    stats = new Stats();
                    stats.setMode(0);

                    stats.domElement.style.position = 'absolute';
                    stats.domElement.style.left = '0px';
                    stats.domElement.style.top = '0px';

                    document.body.appendChild(stats.domElement);
                }


                /**
                 * Called when the scene needs to be rendered. Delegates to requestAnimationFrame
                 * for future renders
                 */
                function render() {

//    scene.getObjectByName('overlay').material.map.needsUpdate = true;

                    // update stats
                    stats.update();

                    // update the camera
                    cameraControl.update();

                    scene.getObjectByName('earth').rotation.y += control.rotationSpeed;
//    scene.getObjectByName('overlay').rotation.y += control.rotationSpeed;
                    scene.getObjectByName('clouds').rotation.y += control.rotationSpeed * 1.1;

                    // update light colors
                    scene.getObjectByName('ambient').color = new THREE.Color(control.ambientLightColor);
                    scene.getObjectByName('directional').color = new THREE.Color(control.directionalLightColor);

                    // and render the scene, renderer shouldn't autoclear, we let the composer steps do that themselves
                    // rendering is now done through the composer, which executes the render steps
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

                // calls the init function when the window is done loading.
                window.onload = init;
                // calls the handleResize function when the window is resized
                window.addEventListener('resize', handleResize, false);


                // This will parse a delimited string into an array of
                // arrays. The default delimiter is the comma, but this
                // can be overriden in the second argument.
                // via http://stackoverflow.com/questions/1293147/javascript-code-to-parse-csv-data
                function CSVToArray( strData, strDelimiter ){
                    // Check to see if the delimiter is defined. If not,
                    // then default to comma.
                    strDelimiter = (strDelimiter || ",");

                    // Create a regular expression to parse the CSV values.
                    var objPattern = new RegExp(
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
                    var arrData = [[]];

                    // Create an array to hold our individual pattern
                    // matching groups.
                    var arrMatches = null;


                    // Keep looping over the regular expression matches
                    // until we can no longer find a match.
                    while (arrMatches = objPattern.exec( strData )){

                        // Get the delimiter that was found.
                        var strMatchedDelimiter = arrMatches[ 1 ];

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
                            var strMatchedValue = arrMatches[ 2 ].replace(
                                new RegExp( "\"\"", "g" ),
                                "\""
                            );

                        } else {

                            // We found a non-quoted value.
                            var strMatchedValue = arrMatches[ 3 ];

                        }


                        // Now that we have our value string, let's add
                        // it to the data array.
                        arrData[ arrData.length - 1 ].push( strMatchedValue );
                    }

                    // Return the parsed data.
                    return( arrData );
                }
            </script>
--%>
<%--
            <script>

                // global variables
                var renderer;
                var scene;
                var camera;

                /**
                 * Initializes the scene, camera and objects. Called when the window is
                 * loaded by using window.onload (see below)
                 */
                function init() {

                    // create a scene, that will hold all our elements such as objects, cameras and lights.
                    scene = new THREE.Scene();

                    // create a camera, which defines where we're looking at.
                    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);

                    // create a render, sets the background color and the size
                    renderer = new THREE.WebGLRenderer();
                    renderer.setClearColor(0x000000, 1.0);
                    renderer.setSize(window.innerWidth, window.innerHeight);
                    renderer.shadowMapEnabled = true;

                    // create the ground plane
                    var planeGeometry = new THREE.PlaneGeometry(20, 20);
                    var planeMaterial = new THREE.MeshLambertMaterial({color: 0xcccccc});
                    var plane = new THREE.Mesh(planeGeometry, planeMaterial);
                    plane.receiveShadow = true;

                    // rotate and position the plane
                    plane.rotation.x = -0.5 * Math.PI;
                    plane.position.x = 0;
                    plane.position.y = -3;
                    plane.position.z = 0;

                    // add the plane to the scene
                    scene.add(plane);
                    const texture = new THREE.TextureLoader().load( '/assets/textures/birch.jpg' );
                    // create a cube
                    var cubeGeometry = new THREE.BoxGeometry(6, 4, 6);
                    var cubeMaterial = new THREE.MeshPhongMaterial({
                        color:0xffffff
                    });
                    var cube = new THREE.Mesh(cubeGeometry, cubeMaterial);

                    cube.castShadow = true;

                    // add the cube to the scene
                    scene.add(cube);

                    // position and point the camera to the center of the scene
                    camera.position.x = 15;
                    camera.position.y = 15;
                    camera.position.z = 15;
                    camera.lookAt(scene.position);

                    // add spotlight for the shadows
                    var spotLight = new THREE.SpotLight(0xffffff);
                    spotLight.position.set(15, 20, 20);
                    spotLight.shadowCameraNear = 20;
                    spotLight.shadowCameraFar = 50;
                    spotLight.castShadow = true;

                    scene.add(spotLight);


                    // add the output of the renderer to the html element
                    document.body.appendChild(renderer.domElement);

                    // call the render function, after the first render, interval is determined
                    // by requestAnimationFrame
                    render();
                }

                /**
                 * Called when the scene needs to be rendered. Delegates to requestAnimationFrame
                 * for future renders
                 */
                function render() {
                    // render using requestAnimationFrame
                    requestAnimationFrame(render);
                    renderer.render(scene, camera);
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

                // calls the init function when the window is done loading.
                window.onload = init;
                // calls the handleResize function when the window is resized
                window.addEventListener('resize', handleResize, false);

            </script>
--%>
</body>
</html>
