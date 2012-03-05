var lastTrayY = 0;
var gameWidth = 1024;
var gameHeight = 768;
var trayHeight = 150;
var stage;
var bitsLayer;
var background;
var images = {};

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
    bits.push(new Bit("puppy_head.png",   10, 768-150+10, 130, 130, 343, 67));
    bits.push(new Bit("puppy_ball.png",  150, 768-150+10, 130, 130, 100, 20));
    bits.push(new Bit("puppy_legs.png",  290, 768-150+10, 130, 130, 100, 20));
    bits.push(new Bit("puppy_torso.png", 430, 768-150+10, 130, 130, 100, 20));
    bits.push(new Bit("puppy_back_leg.png",  570, 768-150+10, 130, 130, 100, 20));
    bits.push(new Bit("puppy_tail.png",  710, 768-150+10, 130, 130, 100, 20));
    bits.push(new Bit("puppy_leg.png",   850, 768-150+10, 130, 130, 100, 20));

    bitsLayer.setAlpha(0.1);

    drawBackground(images);

    stage.onFrame(function(frame) {
        animateTray(frame);
    });
    stage.start();
}

function Bit (imgsrc, ptx, pty, ptw, pth, pbx, pby) {
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
        kImage.on("dragstart", function() {
            console.log("dragstart")
            kImage.moveToTop();
            stage.onFrame(function(frame) {
                if (kImage.getWidth() !== bw) {
                    kImage.width = kImage.width + frame.timeDiff;
                    kImage.height = kImage.height + frame.timeDiff;
                    if (kImage.width > bw) {
                        kImage.width = bw;
                        kImage.height = bh;
                    }
                }
                bitsLayer.draw();
                stage.start();
            });
        });
        kImage.on("dragend", function() {
            console.log("dragend");
            if ((Math.abs(kImage.x - bx) + Math.abs(kImage.y - by)) < 100) {
                console.log("Close enough");
            } else {
                console.log("Too far, move back" + kImage.x + "," + kImage.y);
            }
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

