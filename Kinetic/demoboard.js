var lastTrayY = 0;
var gameWidth = 1024;
var gameHeight = 768;
var trayHeight = 150;
var stage;
var bitsLayer;
var background;
var images = {};
var score;
var endgame;


function loadImages(sources, callback) {
    var loadedImages = 0;
    var numImages = 0;
    for (var src in sources) {
        numImages++;
    }
    for (var src in sources) {
        images[src] = new Image();
        images[src].onload = function() {
                    if (++loadedImages >= numImages) {
                        callback(images);
                    }
                };
        images[src].src = sources[src];
    }
}

function drawBackground() {
    var context = background.getContext();

    context.drawImage(images.board, 0, 0);
    context.drawImage(images.tray, 0, gameHeight);
    lastTrayY = gameHeight;
    console.log("BG drawn");
}

function initStage(){
    stage = new Kinetic.Stage("container", gameWidth, gameHeight);
    background = new Kinetic.Layer();
    bitsLayer = new Kinetic.Layer();

    stage.add(background);
    stage.add(bitsLayer);

    var bits = new Array();
    bits.push(new Bit("puppy_head.png",   10, 768-150+10, 130, 130, 343, 67, 5));
    bits.push(new Bit("puppy_ball.png",  150, 768-150+10, 130, 130, 203, 361, 6));
    bits.push(new Bit("puppy_legs.png",  290, 768-150+10, 130, 130, 430, 255, 3));
    bits.push(new Bit("puppy_torso.png", 430, 768-150+10, 130, 130, 486, 128, 2));
    bits.push(new Bit("puppy_back_leg.png",  570, 768-150+10, 130, 130, 624, 411, 0));
    bits.push(new Bit("puppy_tail.png",  710, 768-150+10, 130, 130, 868, 242, 1));
    bits.push(new Bit("puppy_leg.png",   850, 768-150+10, 130, 130, 832, 296, 4));
    endgame = 7;
    score = 0;

    bitsLayer.setAlpha(0.1);

    drawBackground(images);

    stage.onFrame(function(frame) {
        animateTray(frame);
    });
    stage.start();
}

function Bit (imgsrc, ptx, pty, ptw, pth, pbx, pby, pz) {
    var image = new Image();
    image.src = imgsrc
    var tx = ptx;
    var ty = pty;
    var tw = ptw;
    var th = pth;
    var bx = pbx;
    var by = pby;
    var bw = -1;
    var bh = -1;
    var kImage;
    var z = pz;

    var returnToTrayTransConfig = function () {
         return {
            x: { to: tx, duration: 0.2, easing: Kinetic.easings.easeOutQuart },
            y: { to: ty, duration: 0.2, easing: Kinetic.easings.easeOutQuart },
            width: { to: tw, duration: 0.2, easing: Kinetic.easings.easeOutQuart },
            height: { to: th, duration: 0.2, easing: Kinetic.easings.easeOutQuart }
         }
    }
    var returnToTrayTrans = new Kinetic.Transition(returnToTrayTransConfig);

    var takeFromTrayTransConfig = function () {
         return {
            width: { to: bw, duration: 0.2, easing: Kinetic.easings.easeOutQuart },
            height: { to: bh, duration: 0.2, easing: Kinetic.easings.easeOutQuart }
         }
    }
    var takeFromTrayTrans = new Kinetic.Transition(takeFromTrayTransConfig);

    image.onload = function() {
        bw = image.width;
        bh = image.height;
        kImage = new Kinetic.Image({
            image: image,
            x: tx,
            y: ty,
            width: tw,
            height: th,
            draggable: true            
        });
        bitsLayer.add(kImage);
        kImage.on("mousedown", function() { play_multi_sound("take") });
        kImage.on("dragstart", function() {
            kImage.moveToTop();
            kImage.transition(takeFromTrayTrans);
        });
        kImage.on("dragend", function() {
            kImage.setZIndex(z);
            if ((Math.abs(kImage.x - bx) + Math.abs(kImage.y - by)) < 100) {
                kImage.x = bx;
                kImage.y = by;
                bitsLayer.draw();
                //FRUSTRATION - why this does not work?
                    kImage.draggable = false;
                    kImage.off("dragstart, dragend, dragmove");
                    kImage.listen(false);
                //ENDFRUSTRATION
                play_multi_sound("place");
                score++;
                if (score === endgame) {
                    console.log("END GAME");
                    play_multi_sound("applause");
                    //TODO - baloons
                }
            } else {
                play_multi_sound("return");
                kImage.transition(returnToTrayTrans);
            }
            bitsLayer.draw();
            stage.start();
        });
    };
}

function animateTray(frame) {
    if (lastTrayY > gameHeight - trayHeight) {
        var newY = lastTrayY - frame.timeDiff;
        if (newY < gameHeight - trayHeight) {
            newY = gameHeight - trayHeight;
        }
        var context = background.getContext();
        context.drawImage(images.tray, 0, newY);
        lastTrayY = newY;
        if (newY === gameHeight - trayHeight) {
            console.log("Tray in place, now bits")
            stage.onFrame(function(frame){
                animateBits(images, frame);
            });
        }
    }
}

function animateBits(frame) {
    var alpha = bitsLayer.getAlpha();
    if (alpha < 1.0) {
        alpha = alpha + 3*frame.timeDiff/1000;
        if (alpha > 1.0) alpha = 1.0;
        bitsLayer.setAlpha(alpha);
        bitsLayer.draw();
        if (alpha === 1.0) {
            bitsLayer.getStage().stop();
            console.log("Bits done")
        }
    }
};


window.onload = function(){
    var sources = {
        board: "puppy_board.png",
        tray: "tray.png",
    };
    loadImages(sources, initStage);
}

