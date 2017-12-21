var _eeue56$mountain_path$Native_LocalStorage = function()
{
    function isStorageAvailable() {
        if (typeof window === "undefined"){
            return false;
        } else if (typeof window.localStorage === "undefined"){
            return false;
        }
        return true;
    }

    // shorthand for native APIs
    var unit = {ctor: '_Tuple0'};
    var nativeBinding = _elm_lang$core$Native_Scheduler.nativeBinding;
    var succeed = _elm_lang$core$Native_Scheduler.succeed;
    var fail = _elm_lang$core$Native_Scheduler.fail;
    var Nothing = _elm_lang$core$Maybe$Nothing;
    var Just = _elm_lang$core$Maybe$Just;
    

    function set(key, value) {
        return nativeBinding(function(callback) {
            try {
                localStorage.setItem(key, value);
                return callback(succeed(unit));
            } catch (e) {
                return callback(fail( {'ctor': 'Overflow'} ));
            }
        });
    }


    function get(key) {
        return nativeBinding(function(callback) {
            var value = localStorage.getItem(key);
            
            if (value === null) {
                return callback(succeed(Nothing));
            } else {
                return callback(succeed(Just(value)));
            }
        });
    }
    

    function remove(key) {
        return nativeBinding(function(callback) {
            localStorage.removeItem(key);
            return callback(succeed(unit));
        });
    }
    

    var keys = nativeBinding(function(callback) {
        var knownKeys = Object.keys(localStorage);
        return callback(succeed(_elm_lang$core$Native_List.fromArray(knownKeys)));
    });


    var clear = nativeBinding(function(callback) {
        localStorage.clear();
        return callback(succeed(unit));
    });


    var storageFailShim = nativeBinding(function(callback) {
        return callback(fail( {ctor: 'NoStorage'} ));
    });
    

    if (!isStorageAvailable()) {
        return {
            get: storageFailShim,
            set: storageFailShim,
            remove: storageFailShim,
            clear: storageFailShim,
            keys: storageFailShim
        };
    }

    return {
        get: get,
        set: F2(set),
        remove: remove,
        clear: clear,
        keys: keys
    };
}();