/* NOTE: check out requestAnimationFrame polyfill,
    care of Paul Irish, at
    http://paulirish.com/2011/requestanimationframe-for-smart-animating/ */

window.requestAnimationFrame || (window.requestAnimationFrame = 
  window.webkitRequestAnimationFrame || 
  window.mozRequestAnimationFrame    || 
  window.oRequestAnimationFrame      || 
  window.msRequestAnimationFrame     || 
  function(callback) {
    return window.setTimeout(function() {
      callback(+new Date());
  }, 1000 / 60);
});

Kinetic.Transition = function (config) {
    
    /* A simplification proxy for TransitionBlock.  See TransitionBlock below.*/
    
    // enforce new, as seen on slide 15 from
    // http://www.slideshare.net/stoyan/javascript-patterns
    var that = (this === window) ? {} : this; 
    
    that.config = config;
    return that;
}

Kinetic.TransitionBlock = function(target, config) {
    
    /* A Transition Block is exactly that: a block of scalar transitions.  Such
       transitions are defined by a 'config' - an object literal of the form:
     
       {
        scalar: {
              [from]: value (default=current scalar value)
            , to: value
            , [duration]: value (default=0.5)
            , [delay]: value (default=0) NOT IMPLEMENTED
            , [easing]: Kinetic.easings.* (default=undefined)
            , [completed]: function value (default=function () {})
            , [interrupted]: function value (default=function () {})
            }
        , [scalar] {...}
       }
      
     Each scalar that is defined by the config becomes a separate transition
     that runs against target.  These transitions all run concurrently.
     
     Transition blocks are put into a queue on target.  Target attempts to run
     each transition block to completion in sequence.  No two transition blocks
     run at the same time.     
    */
    
    this.target = target;
    this.config = config;
    this.queue = new Kinetic.Queue();
    
    // A TransitionBlock isn't a queue, but delegates to one beneath the
    // covers; it is useful to be able to treat the block as though it were a
    // queue itself.
    
    this.enqueue = function(item) {
        this.queue.enqueue(item);
    }        
    this.dequeue = function() {
        return this.queue.dequeue();
    }
    this.peek = function() {
        return this.queue.peek();            
    }
    this.getLength = function () {
        return this.queue.getLength();
    }
    this.isEmpty = function () {
        return this.queue.isEmpty();
    }
    this.toList = function () {
        return this.queue.toList();
    }
    
    this.evaluate = function () {
        
        /* The values in the config for a transition block aren't evaluated
         * until the transition block is about to be run. _runTransitionBlocks
         *  calls this to 'populate' the transition block with individual transitions.
         * 'Individual transitions' are transitions of a single scalar. */
        var conf = this.config.call(this.target);
        
        if ('defaults' in conf) {

            var defaults = conf.defaults;
            delete conf.defaults;
            
            for (var key in defaults) {
                for (var scalar in conf) {
                    if (!(key in conf[scalar])) {
                        conf[scalar][key] = defaults[key]
                    }
                }
            }
        }        
        
        // TODO: move this to a util namespace, don't define it here!
        function getPropByPath(o, s) {
  
            // Given an object literal o, and a string path s, find the value
            // located on o that maps to s:
            //
            //   o = {a: {one: 1, two: 2}, b: 3}
            //
            //   s = 'a.one' -> 1
            //   s = 'b'     -> 3
            //   s = 'a'     -> {one: 1, two: 2}
            
            var idx = s.indexOf('.');
            
            if (idx === -1) {
                return o[s];
            }            
  
            return getPropByPath(o[s.substring(0, idx)],
                                 s.substring(idx + 1, s.length));  
        }
        
        // TODO: move this to a util namespace, don't define it here!
        function setPropByPath(o, s, v) {
  
            // Given an object literal o, a string path s, and a value v, set
            // the value located on o that maps to s, to v:
            //
            //   o = {a: {one: 1, two: 2}, b: 3}
            //   v = 100
            //
            //   s = 'a.one' -> sets o.a.one to 100
            
            var idx = s.indexOf('.');
            
            if (idx === -1) {
                o[s] = v;
                return;
            }
            
            var head = s.substring(0, idx);
            var tail = s.substring(idx + 1, s.length);
            
            idx = tail.indexOf('.');
            
            if (idx === -1) {                
                o[head][tail] = v;
            }
            else {
                setPropByPath(o[head], tail, v);  
            }  
        }
        
        Object.keys(conf).forEach(function (key) {    
            
            var config = conf[key];            
            var from, to, duration, completed, interrupted, property, easing,
                me, delay
            
            var prop = getPropByPath(this.target, key);
            if (prop === undefined || prop === null)
            {
                // TODO: Throw an error here?
                return;
            }        
            
            from = config.from;
            if (from === undefined || from === null)
            {            
                from = prop;   
            }
            else
            {
                prop = from;
            }        
            
            property    = key;
            to          = config.to           || 0;
            delay       = config.delay        || 0; // TODO: NOT IMPLEMENTED
            duration    = config.duration     || 0.5;
            completed   = config.completed    || function () {};
            interrupted = config.interrupted  || function () {};
            easing      = config.easing 
            me          = this.target;    
            
            var transLoopWrapper = function (time)
            {
                if (transLoopWrapper._started === undefined) {
                  transLoopWrapper.start = new Date().getTime();
                  transLoopWrapper._started = true;
                  transLoopWrapper._lastCall = transLoopWrapper.start;
                }                                        
                
                //Main trans loop
                var transLoop = function (time) {                
                    
                    var elapsed = (time - transLoopWrapper.start) / 1000;                
                                        
                    // Check if we're paused and, if so, store how much of the
                    // transition has elapsed already                    
                    if (transLoopWrapper._pause !== undefined) {
                        
                        transLoopWrapper._elapsed = elapsed;
                        return;
                    }
    
                    // Check if we're flagged for removal; if so, splice us
                    // out of the current transition list and call our interrupt
                    // callback                    
                    if (transLoopWrapper._remove !== undefined) {
                        
                        var idx = me._currentTransitions.indexOf(transLoopWrapper);
                        if (idx != -1)
                        {
                            me._currentTransitions.splice(idx, 1);
                        }
                        interrupted.call(me); // calls interrupted with me as 'this' - cool!
                        return;
                    }                    
                    
                    if (elapsed <= delay) {
                        
                        // Decrement delay and continue the transition; the
                        // property is not actually transitioning at this point.
                        
                        delay = delay - elapsed;
                        transLoopWrapper.start = new Date().getTime();
                        window.requestAnimationFrame(transLoop);
                        return;
                    }
                    
                    // If the elapsed time is greater than or equal to the
                    // duration: 1. skip to fill, 2. splice us out of the
                    // current transition list, 3. call the completed callback
                    if (elapsed / duration >= 1.0) {
                        
                        setPropByPath(me, property, to);
                        me.getLayer().draw();                    
                        var idx = me._currentTransitions.indexOf(transLoopWrapper);
                        if (idx != -1)
                        {
                            me._currentTransitions.splice(idx, 1);
                        }
                        completed.call(me); // calls interrupted with me as 'this' - cool!
                        return;
                    }
            
                    // Get the current value, with easing, and update the scalar        
                    var value;            
                    if (easing !== undefined && easing !== null)
                    {
                        var percent = easing(elapsed, 0, 1, duration);
                        value = from + ((to - from) * percent);            
                    }
                    else
                    {
                        value = from + ((to - from) * (elapsed / duration));            
                    }                   
                    
                    //console.log("Time: " + time + ", Start: " + transLoopWrapper.start + ", Elapsed: " + elapsed + ", Value: " + value)
                    
                    setPropByPath(me, property, value);
                    
                    // This could be taken care of automatically by a library
                    // that has observables, such as Ember.js or Knockout.js.
                    // TODO: possible to let user decide when to redraw by
                    // adding in another callback? We could just indicate that
                    // the the transitioned object is 'dirty', and leave it up to
                    // the user to make the redraw decision.
                    me.getLayer().draw();
            
                    // Continue transition
                    window.requestAnimationFrame(transLoop);
                }
                
                // Start transition
                window.requestAnimationFrame(transLoop);
            }
            
            transLoopWrapper.duration = duration;
            transLoopWrapper.property = property;
            this.enqueue(transLoopWrapper);
        
        }, this);
    }
}
// t: current time
// b: beginning value
// c: change In value (start - finish position)
// d: duration
// Credit: jQuery source code (just ripped the easing functions out)

Kinetic.easings = {

    swing: function (t, b, c, d) {
        return (b + c) / (t / d);
    },
    easeInQuad: function (t, b, c, d) {
      return c*(t/=d)*t + b;
    },
    easeOutQuad: function (t, b, c, d) {
      return -c *(t/=d)*(t-2) + b;
    },
    easeInOutQuad: function (t, b, c, d) {
      if ((t/=d/2) < 1) return c/2*t*t + b;
      return -c/2 * ((--t)*(t-2) - 1) + b;
    },
    easeInCubic: function (t, b, c, d) {
      return c*(t/=d)*t*t + b;
    },
    easeOutCubic: function (t, b, c, d) {
      return c*((t=t/d-1)*t*t + 1) + b;
    },
    easeInOutCubic: function (t, b, c, d) {
      if ((t/=d/2) < 1) return c/2*t*t*t + b;
      return c/2*((t-=2)*t*t + 2) + b;
    },
    easeInQuart: function (t, b, c, d) {
      return c*(t/=d)*t*t*t + b;
    },
    easeOutQuart: function (t, b, c, d) {
      return -c * ((t=t/d-1)*t*t*t - 1) + b;
    },
    easeInOutQuart: function (t, b, c, d) {
      if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
      return -c/2 * ((t-=2)*t*t*t - 2) + b;
    },
    easeInQuint: function (t, b, c, d) {
      return c*(t/=d)*t*t*t*t + b;
    },
    easeOutQuint: function (t, b, c, d) {
      return c*((t=t/d-1)*t*t*t*t + 1) + b;
    },
    easeInOutQuint: function (t, b, c, d) {
      if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
      return c/2*((t-=2)*t*t*t*t + 2) + b;
    },
    easeInSine: function (t, b, c, d) {
      return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
    },
    easeOutSine: function (t, b, c, d) {
      return c * Math.sin(t/d * (Math.PI/2)) + b;
    },
    easeInOutSine: function (t, b, c, d) {
      return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
    },
    easeInExpo: function (t, b, c, d) {
      return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
    },
    easeOutExpo: function (t, b, c, d) {
      return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
    },
    easeInOutExpo: function (t, b, c, d) {
      if (t==0) return b;
      if (t==d) return b+c;
      if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
      return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
    },
    easeInCirc: function (t, b, c, d) {
      return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
    },
    easeOutCirc: function (t, b, c, d) {
      return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
    },
    easeInOutCirc: function (t, b, c, d) {
      if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
      return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
    },
    easeInElastic: function (t, b, c, d) {
      var s=1.70158;var p=0;var a=c;
      if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
      if (a < Math.abs(c)) { a=c; var s=p/4; }
      else var s = p/(2*Math.PI) * Math.asin (c/a);
      return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
    },
    easeOutElastic: function (t, b, c, d) {
      var s=1.70158;var p=0;var a=c;
      if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
      if (a < Math.abs(c)) { a=c; var s=p/4; }
      else var s = p/(2*Math.PI) * Math.asin (c/a);
      return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
    },
    easeInOutElastic: function (t, b, c, d) {
      var s=1.70158;var p=0;var a=c;
      if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
      if (a < Math.abs(c)) { a=c; var s=p/4; }
      else var s = p/(2*Math.PI) * Math.asin (c/a);
      if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
      return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
    },
    easeInBack: function (t, b, c, d, s) {
      if (s == undefined) s = 1.70158;
      return c*(t/=d)*t*((s+1)*t - s) + b;
    },
    easeOutBack: function (t, b, c, d, s) {
      if (s == undefined) s = 1.70158;
      return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
    },
    easeInOutBack: function (t, b, c, d, s) {
      if (s == undefined) s = 1.70158; 
      if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
      return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
    },
    easeInBounce: function (t, b, c, d) {
      return c - easings.easeOutBounce (d-t, 0, c, d) + b;
    },
    easeOutBounce: function (t, b, c, d) {            
      if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
      } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
      } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
      } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
      }
    },
    easeInOutBounce: function (t, b, c, d) {
      if (t < d/2) return easings.easeInBounce (t*2, 0, c, d) * .5 + b;
      return easings.easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
    }
};

// TODO: The following 'patch' methods should be executed within a self-executing
// function, and then patched onto Kinetic.  That way we don't pollute the global
// namespace.

/* METHOD PATCH
 *
 * This function is patched on to Kinetic.* classes, such that 'this'
 * represents an instance of one of these classes. In other words, this function
 * is supposed to be a method; don't call it without an instance context.
 */
var transition = function(trans) {

    var transitionBlock = new Kinetic.TransitionBlock(this, trans.config);       
    this._transBlocks.enqueue(transitionBlock);
    this._runTransitionBlocks();
    
    return this;
}

/* METHOD PATCH as removeTransitions()
 */
var remove = function () {
    
    /* Removes all transition blocks on this instance, including the transition
       block that is currently running.  All transitions stop, and cannot be
       resumed.      
    */
    
    var transBlock = this._transBlocks.dequeue();
    
    while (transBlock !== undefined) {        
        
        var trans = transBlock.dequeue();
        
        while (trans !== undefined) {
            trans._remove = true;
            trans = transBlock.dequeue();            
        }
        
        transBlock = this._transBlocks.dequeue();
    }
    
    for (var i = 0, l = this._currentTransitions.length; l > i; i++)
    {
        this._currentTransitions[i]._remove = true;
    }
}

/* METHOD PATCH as pauseTransitions()
 */
var pause = function () {    
    
    /* Pauses the current transition block on this instance. */
    
    this._pause = true;
    for (var i = 0, l = this._currentTransitions.length; l > i; i++)
    {
        this._currentTransitions[i]._pause = true;
    }
}

/* METHOD PATCH as resumeTransitions()
 */
var resume = function () {    
    
    /* Resumes the current transition block on this instance. */
    
    this._pause = undefined;
    for (var i = 0, l = this._currentTransitions.length; l > i; i++)
    {
        var trans = this._currentTransitions[i];
        
        trans._pause = undefined;
        var time = new Date().getTime();
        trans.start = time - trans._elapsed * 1000;
        trans._elapsed = 0.0;
        window.requestAnimationFrame(trans);
    }
}

/* METHOD PATCH as _runTransitionBlocks()
 */
var _runTransitionBlocks = function () {
    
    /* Attempts to run each transition block on this instance sequentially.
       If no transition blocks are left, this function ceases to request
       transition frames.
    */
     
    if (this._isEnqueing)
        return;

    this._isEnqueing = true;
    var me = this;
    
    var transitionBlockEnqueuer = function () {        
    
        if (me._currentTransitions.length != 0) {
            window.requestAnimationFrame(transitionBlockEnqueuer);
            return;
        }
        
        var transBlock = me._transBlocks.dequeue();            
        if (transBlock !== undefined)
        {
            transBlock.evaluate();
            me._currentTransitions = transBlock.toList();            
            var trans = transBlock.dequeue();
            while (trans !== undefined) {
                window.requestAnimationFrame(trans);
                trans = transBlock.dequeue();
                // Note: transs remove themselves from _currentTransitions on
                // their own, when they finish
            }
            window.requestAnimationFrame(transitionBlockEnqueuer);
            return;
        }
        else
        {
            me._isEnqueing = false;
        }
    }
    
    window.requestAnimationFrame(transitionBlockEnqueuer);
}

/* METHOD PATCH as transitioningProperties()
 */
var transitioningProperties = function () {
    
    /* Returns a list of the properties that are currently being transitioned on
       an instance.  Transitions with delays may not be visibly transitioning
       the instance yet, but will still count as transitions.
    */
    
    var propertiesTransitioning = [];
    for (var i = 0, l = this._currentTransitions.length; l > i; i++) {
        propertiesTransitioning.push(this._currentTransitions[i].property)
    }
    return propertiesTransitioning;
}

/* METHOD PATCH as isTransitioning()
 */
var isTransitioning = function () {
    
    /* Does the Kinetic.* instance have transitions requesting frames? */
    
    return this.transitioningProperties().length > 0;
}

/* METHOD PATCH as isPaused()
 */
var isPaused = function () {
    
    /* Are the transitions on this Kinetic.* instance paused? */
    
    return this._pause === true;
}


// FUTURE DEV
//function cutHex(h) { return (h.charAt(0)=="#") ? h.substring(1,7) : h}
//
//var redFill = function (h) {
//    return parseInt((cutHex(h)).substring(0,2),16)    
//}
//var greenFill = function (h) {
//    return parseInt((cutHex(h)).substring(2,4),16)
//}
//var blueFill = function (h) {
//    return parseInt((cutHex(h)).substring(4,6),16)
//}

// BEGIN UGLY PATCH PROCESS
Kinetic.Shape.prototype.transition = transition;
Kinetic.Shape.prototype._runTransitionBlocks = _runTransitionBlocks;
Kinetic.Shape.prototype.transitioningProperties = transitioningProperties;
Kinetic.Shape.prototype._currentTransitions = [];
Kinetic.Shape.prototype._transBlocks = new Kinetic.Queue();
Kinetic.Shape.prototype.isTransitioning = isTransitioning;
Kinetic.Shape.prototype.isPaused = isPaused;
Kinetic.Shape.prototype.removeTransitions = remove;
Kinetic.Shape.prototype.pauseTransitions = pause;
Kinetic.Shape.prototype.resumeTransitions = resume;

Kinetic.Group.prototype.transition = transition;
Kinetic.Group.prototype._runTransitionBlocks = _runTransitionBlocks;
Kinetic.Group.prototype.transitioningProperties = transitioningProperties;
Kinetic.Group.prototype._currentTransitions = [];
Kinetic.Group.prototype._transBlocks = new Kinetic.Queue();
Kinetic.Group.prototype.isTransitioning = isTransitioning;
Kinetic.Group.prototype.isPaused = isPaused;
Kinetic.Group.prototype.removeTransitions = remove;
Kinetic.Group.prototype.pauseTransitions = pause;
Kinetic.Group.prototype.resumeTransitions = resume;

Kinetic.Circle.prototype.transition = transition;
Kinetic.Circle.prototype._runTransitionBlocks = _runTransitionBlocks;
Kinetic.Circle.prototype.transitioningProperties = transitioningProperties;
Kinetic.Circle.prototype._currentTransitions = [];
Kinetic.Circle.prototype._transBlocks = new Kinetic.Queue();
Kinetic.Circle.prototype.isTransitioning = isTransitioning;
Kinetic.Circle.prototype.isPaused = isPaused;
Kinetic.Circle.prototype.removeTransitions = remove;
Kinetic.Circle.prototype.pauseTransitions = pause;
Kinetic.Circle.prototype.resumeTransitions = resume;

Kinetic.Image.prototype.transition = transition;
Kinetic.Image.prototype._runTransitionBlocks = _runTransitionBlocks;
Kinetic.Image.prototype.transitioningProperties = transitioningProperties;
Kinetic.Image.prototype._currentTransitions = [];
Kinetic.Image.prototype._transBlocks = new Kinetic.Queue();
Kinetic.Image.prototype.isTransitioning = isTransitioning;
Kinetic.Image.prototype.isPaused = isPaused;
Kinetic.Image.prototype.removeTransitions = remove;
Kinetic.Image.prototype.pauseTransitions = pause;
Kinetic.Image.prototype.resumeTransitions = resume;
// END UGLY PATCH PROCESS
