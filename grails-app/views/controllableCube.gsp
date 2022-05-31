<%--
  Created by IntelliJ IDEA.
  User: Haowei Li
  Date: 5/30/2022
  Time: 4:10 PM
--%>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Controllable Cube</title>
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
    <asset:javascript src="tween.js"/>
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
    <!--Other Project-->
    <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Other projects<span class="caret"></span></a>
        <ul class="dropdown-menu"   style="background: #eac086">
            <li class="dropdown-item"><a href="<g:createLink action="controllableCube"/> " target="_blank">Controllable Cube</a></li>
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

<!--Content Displayer-->
<div class="center" style="background: black" >
    <button onclick="onOff()" style="position: absolute;">On/Off</button>
    <div id="three-container" >
    </div>
</div>
<!--Spinning sphere-->

<!--controllable cube-->
<script>

    // global variables
    let renderer;
    let scene;
    let camera;
    let control;
    let stats;

    let isTweening = false;

    function createCube() {

        const cubeGeometry = new THREE.BoxGeometry(4, 4, 4);
        const cubeMaterial = new THREE.MeshLambertMaterial({color: 0xff0000, transparent: true, opacity: 0.6});
        const cube = new THREE.Mesh(cubeGeometry, cubeMaterial);
        cube.castShadow = true;
        cube.name = 'cube';
        cube.position = new THREE.Vector3(2, 2, 0);
        scene.add(cube);
        return cube;
    }
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
        const planeGeometry = new THREE.PlaneGeometry(120, 120, 20, 20);
        const planeMaterial = new THREE.MeshLambertMaterial({color: 0xcccccc});
        const plane = new THREE.Mesh(planeGeometry, planeMaterial);
        plane.receiveShadow = true;

        // rotate and position the plane
        plane.rotation.x = -0.5 * Math.PI;
        plane.position.x = 0;
        plane.position.y = 0;
        plane.position.z = 0;

        // add the plane to the scene
        scene.add(plane);
        const cube = createCube();

        // position and point the camera to the center of the scene
        camera.position.x = 10;
        camera.position.y = 16;
        camera.position.z = 15;
        camera.lookAt(scene.position);

        // add spotlight for the shadows
        const spotLight = new THREE.SpotLight(0xffffff);
        spotLight.position.set(20, 40, 20);
        spotLight.shadowCameraNear = 20;
        spotLight.shadowCameraFar = 150;
        spotLight.castShadow = true;

        scene.add(spotLight);

        // setup the control object for the control gui
        control = new function () {
            this.rotationSpeed = 0.005;
            this.opacity = 0.6;
            this.color = cube.material.color.getHex();

            this.forward = function () {
                takeStepForward(scene.getObjectByName('cube'), 0, 0.5 * Math.PI, 2000);
            };
            this.back = function () {
                takeStepBackward(scene.getObjectByName('cube'), 0, 0.5 * Math.PI, 2000);
            };
            this.left = function () {
                takeStepLeft(scene.getObjectByName('cube'), 0, 0.5 * Math.PI, 2000);
            };
            this.right = function () {
                takeStepRight(scene.getObjectByName('cube'), 0, 0.5 * Math.PI, 2000);
            };
        };

        // add extras
        addControlGui(control);
        //addStatsObject();


        // add the output of the renderer to the html element
        document.body.appendChild(renderer.domElement);

        // call the render function, after the first render, interval is determined
        // by requestAnimationFrame
        render();
    }

    function takeStepRight(cube, start, end, time) {
        const cubeGeometry = cube.geometry;
        const width = 4;
        if (!isTweening) {
            const tween = new TWEEN.Tween({x: start, cube: cube, previous: 0})
                .to({x: end}, time)
                .easing(TWEEN.Easing.Linear.None)
                .onStart(function () {
                    cube.position.y += -width / 2;
                    cube.position.z += -width / 2;
                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, width / 2, width / 2));
                })
                .onUpdate(function () {
                    cube.geometry.applyMatrix(new THREE.Matrix4().makeRotationX(-(this.x - this.previous)));
                    cube.geometry.verticesNeedUpdate = true;
                    cube.geometry.normalsNeedUpdate = true;
                    this.previous = this.x;
                })
                .onComplete(function () {
                    cube.position.y += 2;
                    cube.position.z += -2;
                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, -width / 2, width / 2));
                    cube.position.x = Math.round(cube.position.x);
                    cube.position.y = Math.round(cube.position.y);
                    cube.position.z = Math.round(cube.position.z);
                    isTweening = false;
                })
                .start();
        }
    }

    function takeStepLeft(cube, start, end, time) {
        const cubeGeometry = cube.geometry;
        const width = 4;
        if (!isTweening) {
            const tween = new TWEEN.Tween({x: start, cube: cube, previous: 0})
                .to({x: end}, time)
                .easing(TWEEN.Easing.Linear.None)
                .onStart(function () {
                    isTweening = true;
                    cube.position.y += -width / 2;
                    cube.position.z += width / 2;
                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, width / 2, -width / 2));
                })
                .onUpdate(function () {
                    cube.geometry.applyMatrix(new THREE.Matrix4().makeRotationX(this.x - this.previous));
                    cube.geometry.verticesNeedUpdate = true;
                    cube.geometry.normalsNeedUpdate = true;
                    this.previous = this.x;
                })
                .onComplete(function () {
                    cube.position.y += 2;
                    cube.position.z += 2;
                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, -width / 2, -width / 2));
                    cube.position.x = Math.round(cube.position.x);
                    cube.position.y = Math.round(cube.position.y);
                    cube.position.z = Math.round(cube.position.z);
                    isTweening = false;
                })
                .start();
        }
    }

    function takeStepBackward(cube, start, end, time) {
        const width = 4;
        const cubeGeometry = cube.geometry;

        if (!isTweening) {
            const tween = new TWEEN.Tween({x: start, cube: cube, previous: 0})
                .to({x: end}, time)
                .easing(TWEEN.Easing.Linear.None)
                .onStart(function () {

                    isTweening = true;
                    cube.position.y += -width / 2;
                    cube.position.x += width / 2;
                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(-width / 2, width / 2, 0));
                })
                .onUpdate(function () {
                    cube.geometry.applyMatrix(new THREE.Matrix4().makeRotationZ(-(this.x - this.previous)));
                    cube.geometry.verticesNeedUpdate = true;
                    cube.geometry.normalsNeedUpdate = true;
                    cube.previous = this.x;
                    this.previous = this.x;
                })
                .onComplete(function () {
                    cube.position.y += 2;
                    cube.position.x += 2;

                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(-width / 2, -width / 2, 0));

                    cube.position.x = Math.round(cube.position.x);
                    cube.position.y = Math.round(cube.position.y);
                    cube.position.z = Math.round(cube.position.z);

                    isTweening = false;
                })
                .start();
        }
    }

    function takeStepForward(cube, start, end, time) {
        const width = 4;
        const cubeGeometry = cube.geometry;

        if (!isTweening) {
            const tween = new TWEEN.Tween({x: start, cube: cube, previous: 0})
                .to({x: end}, time)
                .easing(TWEEN.Easing.Linear.None)
                .onStart(function () {
                    isTweening = true;
                    cube.position.y += -width / 2;
                    cube.position.x += -width / 2;
                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(width / 2, width / 2, 0));
                })
                .onUpdate(function () {
                    cube.geometry.applyMatrix(new THREE.Matrix4().makeRotationZ((this.x - this.previous)));

                    cube.geometry.verticesNeedUpdate = true;
                    cube.geometry.normalsNeedUpdate = true;

                    cube.previous = this.x;
                    this.previous = this.x;
                })
                .onComplete(function () {
                    cube.position.y += width / 2;
                    cube.position.x += -width / 2;
                    cubeGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(width / 2, -width / 2, 0));

                    cube.position.x = Math.round(cube.position.x);
                    cube.position.y = Math.round(cube.position.y);
                    cube.position.z = Math.round(cube.position.z);

                    isTweening = false;
                })
                .start();
        }
    }


    function addControlGui(controlObject) {
        const gui = new dat.GUI();
        gui.add(controlObject,'forward');
        gui.add(controlObject,'back');
        gui.add(controlObject,'left');
        gui.add(controlObject,'right');

    }

    function addStatsObject() {
        stats = new Stats();
        stats.setMode(0);

        stats.domElement.style.position = 'absolute';
        stats.domElement.style.left = '0px';
        stats.domElement.style.top = '0px';

        document.body.appendChild( stats.domElement );
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
        TWEEN.update();

        // and render the scene
        renderer.render(scene, camera);

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

</script>

<!--Helper functions-->
<script>
    //Make 3 display disappear
    function onOff() {
        const x = document.getElementById("three-container");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
</script>

</body>
</html>
