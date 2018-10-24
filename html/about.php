<!DOCTYPE html>
<html lang="en">
<head>
  <title>Zerto zPlanner</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="bootstrap.min.css">
  <script src="jquery.min.js"></script>
  <script src="popper.min.js"></script>
  <script src="bootstrap.min.js"></script>
  <style>
  .fakeimg {
      height: 200px;
      background: #aaa;
  }
  </style>
</head>
<body>

<div class="jumbotron text-center" style="margin-bottom:0">
  <h1 class="text-danger">zPlanner</h1>
  <p>VM Storage analytics monitoring for public cloud and WAN connectivity sizing</p> 
</div>

<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="collapsibleNavbar">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" href="/">Home</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" title="Graphical View of Stat Data" href="http://<?php echo $server; ?>:3000/" >Grafana</a>
      </li>
    <!-- Dropdown -->
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
        VM Monitoring
      </a>
      <div class="dropdown-menu">
        <a class="dropdown-item" title="Select VMs to monitor" href="monitor.php">Add VMs</a>
        <a class="dropdown-item" title="Remove VMs from monitoring" href="unmonitor.php">Remove VMs</a>
      </div>
    </li>
 <li class="nav-item">
      <a class="nav-link disabled" title="Future Functionality" href="#">VPG Planning</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" title="PHPMyAdmin Control Panel for Exporting SQL data" href="/phpmyadmin/">DB Administration</a>
    </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Documentation</a>
      </li>
        <li class="nav-item">
          <a class="nav-link" href="about.php">About</a>
        </li>
    </ul>
  </div>  
</nav>

<div class="container" style="margin-top:30px">
  <div class="row">
    <div class="col-sm-4">
      <h2>Project Info</h2>
      <h5>GitHub Repository</h5>
      <img src="img/github.png" class="rounded" alt="GitHub">
      <p>All zPlanner code is available on <a href="https://github.com/Zerto-TA-Public/zplanner">Github</a>. Updates are downloaded from Github when you run the update process from the console.</p>
      <h3>Open Source Components</h3>
      <p>Besides the custom code developed specifically for zPlanner, there are other open source components used. Below are links to those projects.</p>
      <ul class="nav nav-pills flex-column">
        <li class="nav-item">
        </li>
        <li class="nav-item">
          <a class="nav-link" href="http://ubuntu.com">Ubuntu</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="https://docs.microsoft.com/en-us/powershell/">PowerShell Core</a>
        </li>
        <li class="nav-item">
          <a class="nav-link disabled" href="https://www.powershellgallery.com/packages/VMware.PowerCLI/10.2.0.9372002">VMware PowerCLI</a>
        </li>
      </ul>
      <hr class="d-sm-none">
    </div>
    <div class="col-sm-8">
      <h2>DISCLAIMER</h2>
      <h5>Updated, Sep 15, 2018</h5>
      <p>IN NO EVENT SHALL ZERTO OR ZPLANNER DEVELOPERS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR 
	CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS 
	DOCUMENTATION, EVEN IF ZERTO HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

      <p>ZERTO SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
	OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, 
        IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". ZERTO HAS NO OBLIGATION TO PROVIDE MAINTENANCE, 
	SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.</p>
      <br>
    </div>
  </div>
</div>

<div class="jumbotron text-center" style="margin-bottom:0">
  <p>Please direct any questions to your local Zerto account manager and sales engineer.</p>
</div>

</body>
</html>
