# shinycalculator

A calculator in a Shiny app

## Install

Install the app from GitHub using:

```r
# install.packages("remotes")
remotes::install_github("grddavies/shinycalculator")
```

## Run

Run the app using:

```r
shinycalculator::run_app()
```

## Why?

I developed this app as a resource for teaching how to test R code using `testthat` and shiny apps using `shinytest`.
Have a look [here](tests/testthat/test-interactivity.R) to see how the app is launched in a headless browser session using shinytest (and PhantomJS).
A session is then simulated using the methods associated with the `app` object, and the expected behaviour tested using `testthat`.

## Why else?

I'd like to point out some things (as well as the tests) which I think are cool about it:

* Modular code structure - the calculator is a shiny module itself, which consists of a screen and 20 instances of a `calc_button` module, which interact with the screen. 
If you want to update how all the buttons work, you only update the two functions in [`mod_calc_button.R`](R/mod_calc_button.R).
	
* Quasiquotation - to give each button different functionality, one of the arguments passed to `mod_calc_button_server()` is a callback function 
(kind of - its a _call_ rather than a _function_). The call is evaluated in the parent scope of the module server every time a button is pressed. 
When I first tried to do this, callback would only be evaluated once - it was being consumed by the first button press. 
I fixed that with [this commit](https://github.com/grddavies/shinycalculator/commit/ee36cb5a689f2e7c4afbc16bdef87ad5246ae0a2)
where `callback` is quoted when the module is first called, and then that call can be evaluated without being consumed.
	
* Safe evaluation of user input - rather than reinvent the wheel by constructing my own mathematical expression parser, the calculator uses the R interpreter to evaluate
user input on the server. It would be a pretty major security issue if the user could submit arbitrary instructions to run on our server so
I had a look at how to get around this. I found [this rstudio community question](https://community.rstudio.com/t/secure-way-to-accept-user-input-for-shiny-apps/13554)
which uses rlang to inspect the user input, step through the calls in the expression, and only evaluate the call if the function belongs to a list of whitelisted functions. 
That way the calculator can evaluate `(1 + 1) * 10` but not `system("sudo rm -rf /")` if the whitelist is set up correctly! 
