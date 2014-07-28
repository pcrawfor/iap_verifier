###
  IAPVerifier wraps the calls necessary to verify In App Purchase receipts from iOS with Apple's servers.
  
  Using IAPVerifier you can verify typical IAP receipts and Auto-renewing receipts using the too functions available:
  
  verifyReceipt
  verifyAutoRenewReceipt

  PRODUCTION: https://buy.itunes.apple.com/verifyReceipt
  SANDBOX: https://sandbox.itunes.apple.com/verifyReceipt    

  Verify a receipt
  receipt = '{
    "signature" = "AluGxOuMy+RT1gkyFCoD1i1KT3KUZl+F5FAAW0ELBlCUbC9dW14876aW0OXBlNJ6pXbBBFB8K0LDy6LuoAS8iBiq3529aRbVRUSKCPeCDZ7apC2zqFYZ4N7bSFDMeb92wzN0X/dELxlkRH4bWjO67X7gnHcN47qHoVckSlGo/mpbAAADVzCCA1MwggI7oAMCAQICCGUUkU3ZWAS1MA0GCSqGSIb3DQEBBQUAMH8xCzAJBgNVBAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEzMDEGA1UEAwwqQXBwbGUgaVR1bmVzIFN0b3JlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA5MDYxNTIyMDU1NloXDTE0MDYxNDIyMDU1NlowZDEjMCEGA1UEAwwaUHVyY2hhc2VSZWNlaXB0Q2VydGlmaWNhdGUxGzAZBgNVBAsMEkFwcGxlIGlUdW5lcyBTdG9yZTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMrRjF2ct4IrSdiTChaI0g8pwv/cmHs8p/RwV/rt/91XKVhNl4XIBimKjQQNfgHsDs6yju++DrKJE7uKsphMddKYfFE5rGXsAdBEjBwRIxexTevx3HLEFGAt1moKx509dhxtiIdDgJv2YaVs49B0uJvNdy6SMqNNLHsDLzDS9oZHAgMBAAGjcjBwMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUNh3o4p2C0gEYtTJrDtdDC5FYQzowDgYDVR0PAQH/BAQDAgeAMB0GA1UdDgQWBBSpg4PyGUjFPhJXCBTMzaN+mV8k9TAQBgoqhkiG92NkBgUBBAIFADANBgkqhkiG9w0BAQUFAAOCAQEAEaSbPjtmN4C/IB3QEpK32RxacCDXdVXAeVReS5FaZxc+t88pQP93BiAxvdW/3eTSMGY5FbeAYL3etqP5gm8wrFojX0ikyVRStQ+/AQ0KEjtqB07kLs9QUe8czR8UGfdM1EumV/UgvDd4NwNYxLQMg4WTQfgkQQVy8GXZwVHgbE/UC6Y7053pGXBk51NPM3woxhd3gSRLvXj+loHsStcTEqe9pBDpmG5+sk4tw+GK3GMeEN5/+e1QT9np/Kl1nj+aBw7C0xsy0bFnaAd1cSS6xdory/CUvM6gtKsmnOOdqTesbp0bs8sn6Wqs0C9dgcxRHuOMZ2tm8npLUm7argOSzQ==";
    "purchase-info" = "ewoJInF1YW50aXR5IiA9ICIxIjsKCSJwdXJjaGFzZS1kYXRlIiA9ICIyMDExLTEwLTEyIDIwOjA1OjUwIEV0Yy9HTVQiOwoJIml0ZW0taWQiID0gIjQ3MjQxNTM1MyI7CgkiZXhwaXJlcy1kYXRlLWZvcm1hdHRlZCIgPSAiMjAxMS0xMC0xMiAyMDoxMDo1MCBFdGMvR01UIjsKCSJleHBpcmVzLWRhdGUiID0gIjEzMTg0NTAyNTAwMDAiOwoJInByb2R1Y3QtaWQiID0gImNvbS5kYWlseWJ1cm4ud29kMW1vbnRoIjsKCSJ0cmFuc2FjdGlvbi1pZCIgPSAiMTAwMDAwMDAwOTk1NzYwMiI7Cgkib3JpZ2luYWwtcHVyY2hhc2UtZGF0ZSIgPSAiMjAxMS0xMC0xMiAyMDowNTo1MiBFdGMvR01UIjsKCSJvcmlnaW5hbC10cmFuc2FjdGlvbi1pZCIgPSAiMTAwMDAwMDAwOTk1NzYwMiI7CgkiYmlkIiA9ICJjb20uZGFpbHlidXJuLndvZCI7CgkiYnZycyIgPSAiMC4wLjgiOwp9";
    "environment" = "Sandbox";
    "pod" = "100";
    "signing-status" = "0";
  }'

  client = new IAPVerifier('e9a418ff1b2d42a2bc5c4f9b294555df', true)
  client.verifyAutoRenewReceipt receipt, (valid, msg, data) ->
    if valid
      console.log("Valid receipt")
    else
      console.log("Invalid receipt")
  
    console.log("Callback: #{data.status} | #{msg}")
  
###

https = require 'https'

class IAPVerifier
  productionHost: "buy.itunes.apple.com"
  sandboxHost: "sandbox.itunes.apple.com"

  responseCodes:
    0:     { message:"Active", valid: true, error: false }
    21000: { message:"App store could not read", valid: false, error: true }
    21002: { message:"Data was malformed", valid: false, error: true }
    21003: { message:"Receipt not authenticated", valid: false, error: true }
    21004: { message:"Shared secret does not match", valid: false, error: true }
    21005: { message:"Receipt server unavailable", valid: false, error: true }
    21006: { message:"Receipt valid but sub expired", valid: false, error: false }
    21007: { message:"Sandbox receipt sent to Production environment", valid: false, error: true, redirect: true } # special case for app review handling - forward any request that is intended for the Sandbox but was sent to Production, this is what the app review team does
    21008: { message:"Production receipt sent to Sandbox environment", valid: false, error: true }    
  
  constructor: (@password, @production=true, @debug=false) ->    
    @host = if @production then @productionHost else @sandboxHost          
    @port = 443
    @path = '/verifyReceipt'
    @method = 'POST'
  
  ###
    verifyAutoRenewReceipt
  
    Verifies an In App Purchase receipt string for an auto-renewing subscription against Apple's servers
  
    Auto-renewing subscriptions can return a larger number of responses, in the event that the response is 21007
    the function will auto-retry to process the receipt against the Sandbox environment.
    
    The 21007 status code is indicative of what will happen when the App Store Review team is trying to test a subscription while reviewing an application
  
    params:
      receipt   - the receipt string
      isBase64  - Is the receipt already encoded in base64? Optional, defaults to false.
      cb        - callback function that will return the status code and results for the verification call
  ###
  verifyAutoRenewReceipt: (receipt, isBase64, cb) ->
    if cb is undefined
      cb = isBase64
      isBase64 = false
    data =
      'receipt-data': "",
      password: @password
          
    @verifyWithRetry(data, receipt, isBase64, cb)
    
    
  ###
    verifyReceipt
    
    Verifies an In App Purchase receipt string against Apple's servers
    
    params:
      receipt   - the receipt string
      isBase64  - Is the receipt already encoded in base64? Optional, defaults to false.
      cb        - callback function that will return the status code and results for the verification call
  ###
  verifyReceipt: (receipt, isBase64, cb) ->
    if cb is undefined
      cb = isBase64
      isBase64 = false
    data = 
      'receipt-data': ""
  
    @verifyWithRetry(data, receipt, isBase64, cb)
  
  ###
    verifyWithRetry
    
    Verify with retry will automatically call the Apple Sandbox verification server in the event that a 21007 error code is returned.
    This error code is an indication that the app may be receiving app store review requests.    
  ###
  
  verifyWithRetry: (receiptData, receipt, isBase64, cb) ->      
    encoded = null
    if isBase64
      encoded = receipt
    else
       buffer = new Buffer(receipt)
       encoded = buffer.toString('base64')
       
    receiptData['receipt-data'] = encoded
    @verify receiptData, @requestOptions(), (valid, msg, data) =>
      # on a 21007 error retry the request for the Sandbox environment (if the current environment is Production)
      if (21007 == data?.status) && (@productionHost == @host)
        # retry...
        if @debug then console.log("Retry on Sandbox")        
        options = @requestOptions()
        options.host = @sandboxHost
          
        @verify receiptData, options, (valid, msg, data) ->
          if @debug then console.log("STATUS #{data?.status}")
          cb(valid, msg, data)
      else
        if @debug then console.log "else"
        cb(valid, msg, data)
  
  ###
    verify the receipt data
  ###
  verify: (data, options, cb) ->
    if @debug then console.log("verify!")
    
    post_data = JSON.stringify(data)
        
    options.headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Length': post_data.length
    }    
            
    request = https.request options, (response) =>      
      if @debug then console.log("statusCode: #{response.statusCode}")
      if @debug then console.log("headers: #{response.headers}")
         
      apple_response_arr = []

      response.on 'data', (data) =>
        if @debug then console.log("data #{data}")
        if response.statusCode != 200
          if @debug then console.log("error: " + data)
          return cb(false, "error", null)          
        
        apple_response_arr.push(data)        
              
      response.on 'end', () =>            
        totalData = apple_response_arr.join('')
        if @debug then console.log "end: apple response: #{totalData}"
        try
          responseData = JSON.parse(totalData)
        catch err
          if @debug then console.log("error: " + err)
          return cb(false, "error", err)
        @processStatus(responseData, cb)

      
    request.write(post_data)
    request.end()

    request.on 'error', (err) ->
      if @debug then console.log("In App purchase verification error: #{err}")
      
  
  processStatus: (data, cb) ->
    # evaluate status code and take an action, write any new receipts to the database
    if @debug then console.log("Process status #{data.status}")
    #todo: check status code and react appropriately
    response = @responseCodes[data.status]
    # Try not to blow up if we encounter an unknown/unexepected status code
    unless response
      response =
        valid: false
        error: true
        message: "Unknown status code: " + data.status       
    cb(response.valid, response.message, data)
  
  requestOptions: ->
    options =
      host: @host
      port: @port
      path: @path
      method: @method
  
module.exports = IAPVerifier
