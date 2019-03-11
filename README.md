
# ZillowR

Zillow, an online real estate company, provides real estate and mortgage data
for the United States through a REST API. The ZillowR package provides an R
function for each API service, making it easy to make API calls and process the
response into convenient, R-friendly data structures. See
<http://www.zillow.com/howto/api/APIOverview.htm> for the Zillow API
Documentation.

## Installation and setup

Install the latest stable version from CRAN as follows.

```r
install.packages('ZillowR')
```

Alternatively, if you've installed the devtools package, you can install the
latest development version directly from Github.

```r
devtools::install_github('fascinatingfingers/ZillowR')
```

Each subscriber to Zillow Web Services is uniquely identified by an ID sequence,
and every request to Web Services requires this ID. After loading the ZillowR
package, you should set the "ZillowR-zws_id" option as shown below. This
facilitates API calls without needing to specify your Zillow Web Services ID
every time.

```r
library(ZillowR)
set_zillow_web_service_id('YOUR ZWS-ID')
```

Click [here](http://www.zillow.com/webservice/Registration.htm) to register with
Zillow and receive your own Web Services ID.

## Basic usage

ZillowR provides an eponymous function for each Zillow API service, with API
parameters as function arguments. For example:

```r
GetMonthlyPayments(price = 300000L)
```

    #> $request
    #> $request$price
    #> [1] "300000"
    #> 
    #> 
    #> $message
    #> $message$text
    #> [1] "Request successfully processed"
    #> 
    #> $message$code
    #> [1] "0"
    #> 
    #> 
    #> $response
    #> <response>
    #>  <payment loanType="thirtyYearFixed">
    #>   <rate>3.537</rate>
    #>   <monthlyPrincipalAndInterest>1082</monthlyPrincipalAndInterest>
    #>  </payment>
    #>  <payment loanType="fifteenYearFixed">
    #>   <rate>2.709</rate>
    #>   <monthlyPrincipalAndInterest>1624</monthlyPrincipalAndInterest>
    #>  </payment>
    #>  <payment loanType="fiveOneARM">
    #>   <rate>2.913</rate>
    #>   <monthlyPrincipalAndInterest>1000</monthlyPrincipalAndInterest>
    #>  </payment>
    #>  <downPayment>60000</downPayment>
    #> </response>

Each function returns a named list with the following elements:

 - **"request"** a list with the request parameters
 - **"message"** a list of status code(s) and message(s) returned by the API
 - **"response"** an XMLNode with the API-specific response values. At this
   time, no further coercion is performed, so you may have to use functions from
   the `XML` package to extract the desired output.

Be sure to check out the
[API documentation](http://www.zillow.com/howto/api/APIOverview.htm) to learn
more about the available services
