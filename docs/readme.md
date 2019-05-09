# zPlanner Documentation

## What is zPlanner

zPlanner is a tool that is designed to monitor disk change rates to VMware virtual machines. zPlanner leverages the PowerCLI interface to get data from vCenter and store it in a local MySQL database. This data is then manipulated and presented using Grafana.

The intended purpose of zPlanner is to help architect the number of Zerto Cloud Appliances that are required as well as how much bandwidth is needed to replicate a workload.

zPlanner is a combination of two parts, there is code that makes zPlanner work (which comes from this GitHub Repo), as well as a virtual machine that has the required packages to run the code from GitHub. In order to deploy zPlanner you should download the zPlanner appliance and it will download the latest zPlanner updates during configuration.

## zPlanner Support

It should be noted that zPlanner is not supported by Zerto Support. It is a free tool created by Justin Paul, and supported on a best effort basis. To request support support you have two options:

1. [Open GitHub Issue here](https://github.com/zerto-ta-Public/zplanner/issues)
    - Recommended for feature requests, bugs, and larger asks.
2. [JPaul.me Drift Chat](http://jpaul.me)
    - For shorter requests or quick questions please use the Drift chat box on my blog.

## zPlanner Requirements

zPlanner will require several things in order to do its job. A place to run, and credentials to talk to vCenter, as well as an IP address are the basics.

- At least 2 vCPU and 2GB of ram, for more than 500vms use 4vCPU and 4GB of RAM
- IP address (Static or DHCP), main requirement is that it has to be able to talk to vCenter
- vCenter username and password (can be a read only account), preferably in user@domain format

## Downloading the zPlanner Appliance

As stated before, zPlanner is deployed via a virtual appliance. The OVA file that you can download will run on ESXi 4.0 or newer, it has not been tested on non-esxi platforms.

To download the zPlanner Virtual Appliance go to https://www.jpaul.me/getzplanner

## Deploying zPlanner

To deploy zPlanner after you have downloaded the OVA file, login to vCenter or ESXi, and follow the standard OVF/OVA Template deployment procedures for the version you are running. (This is a VMware procedure, if you need more details please refer to VMware documentation on how to deploy an OVA template.)

## Configuration of zPlanner

Once the virtual appliance has been deployed configuration is very straightforward. There is a console based menu available via the virtual machine console or via an SSH terminal. It is recommended that for initial configuration you use the virtual machine console.

### Setup networking

Open the VM console and wait for the VM to fully boot. Once you see the VM console check to see if the machine received an IP address via DHCP. If it has not, run the static network configuration wizard by typing "2" and pressing enter.

### Updating zPlanner

Once the VM has a valid IP address, make a note of it, then run the update wizard by pressing "1" then enter. This proceedure will download the latest zPlanner code from the zPlanner repo, apply the latest Grafana Dashboards, and then reboot the appliance.

### Configure vCenter information

Once the appliance has rebooted continue the configuration process by pressing "3" followed by enter. In this step we will configure the vCenter credentials. Enter the following information:
- vCenter FQDN or IP
- vCenter username either user@domain or domain\\\user (note the double \\)
- vCenter user's password

### Test vCenter information

Next, at the main menu press option "4" followed by enter. a PowerCLI script will run and test the vCenter information that you entered. There will be error messages displayed if there are issues with the connection information. If you see any error messages re-run option 3 at the main menu to re-enter your connection information.

Once there are no error messages return to the main menu and proceed to the next section

### Generate the list of virtual machines

Before we can select which VMs to monitor in the GUI we need to get the list of VMs from vCenter. To do this type "5" at the main menu and press enter. This step can take a little time depending on how many virtual machines you have in your vCenter inventory.

Once it is complete return to the main menu.

### Start the Job Scheduler

zPlanner uses cron to schedule PowerShell jobs. By default no jobs are running and no stats will be collected until you start the job scheduler. Simply running option "6" will install the required Cronjobs.

If for whatever reason you need to stop the scheduled jobs, run option "7" and all of the cronjobs will be removed.

### Selecting vms to Monitor

From this point forward we can proceed to the Web UI of zPlanner. simply go to http://zPlanner_IP_Address_in a web browser

From here we will need to select the VMs to monitor. In the main menu ribbon select "Monitor VMs" and then pick "Add VMs"

From the web page select which VMs you wish to monitor and click the "Monitor" button, you can repeat this step as many times as needed.

## Viewing Stats

It can take up to 5 minutes for Grafana to start displaying stats that have been collected.

Once you have selected VMs to monitor, return to the zPlanner homepage (http://zPlanner_IP_Address) and click "Grafana" in the main menu ribbon

The login credentials for Grafana are "admin" with the passsword "Zertodata1!"

From Grafana you can view the default dashboards, or create your own.

## Accessing SSH / MySQL / PHPMyAdmin

The credentials for accessing zPlanner via SSH are "zerto" / "Zertodata1!"

The credentials for accessing MySQL and PHPMyAdmin are "root" / "Zertodata1!"
