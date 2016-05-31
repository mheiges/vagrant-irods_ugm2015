acSetRescSchemeForCreate { 
  on ($objPath like "/$rodsZoneClient/manualDelivery/*") {
    msiSetDefaultResc("replResc","null");
  }
} 

