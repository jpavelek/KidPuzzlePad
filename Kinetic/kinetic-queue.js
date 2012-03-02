Kinetic.Queue = function Queue(){
  
  /*

  Queue.js
  
  A function to represent a queue
  
  Created by Stephen Morley - http://code.stephenmorley.org/ - and released under
  the terms of the CC0 1.0 Universal legal code:
  
  http://creativecommons.org/publicdomain/zero/1.0/legalcode
  
  Extended by Jonathan Dobson, Feb 2012 to include toList() method
  
  */
  
  var _1=[];
  var _2=0;
  
  this.getLength=function(){
    return (_1.length-_2);
  };
  
  this.isEmpty=function(){
    return (_1.length==0);
  };
  
  this.enqueue=function(item){
    _1.push(item);
  };
  
  this.dequeue=function(){
  
    if(_1.length==0){
      return undefined;
    }
    
    var _4=_1[_2];
    
    if(++_2*2>=_1.length){
      _1=_1.slice(_2);
      _2=0;
    }
    
    return _4;
  
  };
  
  this.peek=function(){
    return (_1.length>0?_1[_2]:undefined);
  };
  
  this.toList = function(){
    return _1.slice(_2);
  }
  
};