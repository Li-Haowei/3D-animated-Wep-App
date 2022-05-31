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
    <title>AR Text</title>
    <asset:javascript src="three.js"/>
    <asset:javascript src="OrbitControls.js"/>
    <asset:javascript src="dat.gui.min.js.js"/>
    <asset:javascript src="stats.min.js"/>
    <asset:javascript src="CSS3DRenderer.js"/>
    <style>
    .center {
        display: flex;
        justify-content: center;
        height: 70%
    }
    #three-container{
        border-radius: 50%;
        height: 100%;
        width: 60%;
    }
    .container1{
        display: grid;
        place-items: center;
    }
    .large {
        font-size: xx-large;
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
            <li class="dropdown-item"><a href="/" target="_blank">Earth Population</a></li>
            <li class="dropdown-item"><a href="controllableCube" target="_blank">Controllable Cube</a></li>
            <li class="dropdown-item"><a href="maze" target="_blank">Maze</a></li>
            <li class="dropdown-item"><a href="textCube" target="_blank">Text Cube</a></li>
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
<%--
<div class="center" style="background: black" >
    <button onclick="onOff()" style="position: absolute;">On/Off</button>
    <div id="three-container" >
    </div>

</div>--%>

<script>

    const string =
        '<div class="container1 large">' +
        '<h1>Auther: Haowei Li</h1>' +
        '<span class="large">AR text viewer</span>' +
        '<textarea> Refresh the page to get different color combination (This is editable)</textarea>' +
        '</div>';

    // global variables
    let renderer;
    let scene;
    let camera;
    let control;
    let controls;
    let stats;

    const cube = new THREE.BoxGeometry(4, 4, 4);
    const objects = [];
    const divCount = 0;

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


        renderer = new THREE.CSS3DRenderer();
        renderer.setSize(window.innerWidth, window.innerHeight);
        /*
        renderer.domElement.style.position = 'absolute';
        renderer.domElement.style.top = 0;
         */

        // position and point the camera to the center of the scene
        camera.position.x = 500;
        camera.position.y = 500;
        camera.position.z = 500;
        camera.lookAt(scene.position);


        // setup the control object for the control gui
        control = new function () {
        };

        // add extras

        //addStatsObject();


        // add the output of the renderer to the html element
        document.body.appendChild(renderer.domElement);
        const clone = createCSS3DObject(string);

        clone.position.set(100,100,100);
        clone.rotation.y = 0.2*Math.PI;

        scene.add(clone);


        // call the render function, after the first render, interval is determined
        // by requestAnimationFrame
        render();
    }

    function createCSS3DObject(s) {
        // create outerdiv and set inner HTML from supplied string
        const div = document.createElement('div');
        div.innerHTML = s;

        // set some values on the div to style it, standard CSS
        div.style.width = '370px';
        div.style.height = '370px';
        div.style.opacity = 0.7;
        div.style.background = new THREE.Color(Math.random() * 0xffffff).getStyle();

        // create a CSS3Dobject and return it.
        const object = new THREE.CSS3DObject(div);
        return object;
    }



    function addControlGui(controlObject) {
        const gui = new dat.GUI();
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

        //imbed into selected item
        /*
        let container = document.getElementById('three-container');
        renderer.setSize($(container).width(), $(container).height());
        container.appendChild(renderer.domElement);*/

        // update stats
        //stats.update();
        resizeCanvasToDisplaySize();
        // and render the scene
        renderer.render(scene, camera);

        // render using requestAnimationFrame
        requestAnimationFrame(render);
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
