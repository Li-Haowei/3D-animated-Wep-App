<%--
  Created by IntelliJ IDEA.
  User: Haowei Li
  Date: 5/30/2022
  Time: 4:10 PM
--%>
<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="Grails"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="myHandsomePic.JPG" type="image/x-ico"/>

    <asset:stylesheet src="application.css"/>

    <g:layoutHead/>
    <style>
        .smallerPicture{
            width:50px;
            height: 70px;
        }
        #bottom {
            position: absolute;
            width: 100%;
            bottom: 0;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-static-top" role="navigation">
    <div class="container-fluid" >
        <a class="navbar-brand smallerPicture" ><asset:image src="myBeautifulWife.svg" /></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" aria-expanded="false" style="height: 0.8px;" id="navbarContent">

            <ul class="nav navbar-nav ml-auto">
                <g:pageProperty name="page.nav"/>
            </ul>
        </div>

    </div>
</nav>

<g:layoutBody/>

<div class="footer" role="contentinfo" id="bottom">
    <div class="container-fluid">
        <div class="row">
            <div class="col">
                <a href="http://guides.grails.org" target="_blank">
                    <asset:image src="calendar-modified.png" alt="Events" class="float-left"/>
                </a>
                <strong class="centered"><a href="http://guides.grails.org" target="_blank">Events</a></strong>
                <p>Coming up events</p>

            </div>
            <div class="col">
                <a href="http://docs.grails.org" target="_blank">
                    <asset:image src="documentation.svg" alt="Grails Documentation" class="float-left"/>
                </a>
                <strong class="centered"><a href="http://docs.grails.org" target="_blank">Documentation</a></strong>
                <p>Here is more information you can learn about Grails if you want a cool page like this: <a href="http://docs.grails.org" target="_blank">User Guide</a>.</p>

            </div>
            <div class="col">
                <a href="https://github.com/Li-Haowei/GrailsProject" target="_blank">
                    <asset:image src="github.png" alt="Github" class="float-left"/>
                </a>
                <strong class="centered"><a href="https://slack.grails.org" target="_blank">Source Code</a></strong>
                <p>Check out the source code and as well as my other open source projects: <a href="https://github.com/Li-Haowei/GrailsProject" target="_blank">GitHub</a>.</p>
            </div>
        </div>
    </div>
</div>

<div id="spinner" class="spinner" style="display:none;">
    <g:message code="spinner.alt" default="Loading&hellip;"/>
</div>

<asset:javascript src="application.js"/>

</body>
</html>
