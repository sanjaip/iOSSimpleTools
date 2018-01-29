

simpeTools.service('naitveService', function() {
       this.CallNative= function(modName, nativeMethod, callbackMethod, arguments){
                   var dictionary = {
                      module:modName,
                      method:nativeMethod,
                      callback:callbackMethod,
                      args:arguments
                   }

                   try {
                        webkit.messageHandlers.messageBox.postMessage(dictionary);
                   } catch(err) {
                        console.log(err);
                   }
      }
});
