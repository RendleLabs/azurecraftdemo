# azurecraftdemo
Demo site and scripts created during presentation at http://azurecraft.uk/

## Building and running

Code should just be buildable and runnable on any [.NET Core supported platform](http://dot.net/).

To run in Docker on Windows or Mac, sign up for the Docker for [Windows/Mac] beta at http://beta.docker.com/

For Windows, you need to go into Settings and share the Drive your project is on (I just put my code on C: to make life easy now).

If you get that working on Windows, try installing the Docker Tools for Visual Studio extension into VS2015 (from Tools > Extensions and Updates).

Set configuration to Release first, and run without debugging, it should launch at http://docker/ (give it a few seconds if it can't connect).

Once that's worked, try setting the config back to Debug and then Start Debugging.

The [Terraform](http://terraform.io/) script I used to spin up a Linux environment in Azure is included, minus my credentials.

[The slides from the talk are on SlideShare.](http://www.slideshare.net/markrendle/aspnet-core-in-docker-on-linux-in-azure)
