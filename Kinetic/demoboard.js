var lastTrayY = 0;
var gameWidth = 1024;
var gameHeight = 768;
var trayHeight = 150;

function loadImages(sources, callback) {
    var images = {};
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

function isNearOutline(animal, outline) {
    var a = animal;
    var o = outline;
    if (a.x > o.x - 20 && a.x < o.x + 20 && a.y > o.y - 20 && a.y < o.y + 20) {
        return true;
    } else {
        return false;
    }
}

function drawBackground(background, images) {
    var canvas = background.getCanvas();
    var context = background.getContext();

    context.drawImage(images.board, 0, 0);
    context.drawImage(images.tray, 0, gameHeight);
    lastTrayY = gameHeight;
}

function initStage(images){
    var stage = new Kinetic.Stage("container", gameWidth, gameHeight);
    var background = new Kinetic.Layer();
    var bitsLayer = new Kinetic.Layer();

    // Bits data - positions, sizes, etc.

    var bits = new Array();
    bits.push(new Bit("puppy_head.png",  10, 768-150+10, 130, 130, 100, 20, bitsLayer));
    bits.push(new Bit("puppy_ball.png", 150, 768-150+10, 130, 130, 100, 20, bitsLayer));
    bits.push(new Bit("puppy_legs.png", 280, 768-150+10, 130, 130, 100, 20, bitsLayer));

    bitsLayer.setAlpha(0.1);

    stage.add(background);
    stage.add(bitsLayer);

    drawBackground(background, images);

    stage.onFrame(function(frame) {
        animateTray(background, images, frame, stage, bitsLayer);
    });
    stage.start();
}

function Bit (imgsrc, tx, ty, tw, th, bx, by, layer) {
    this.image = new Image();
    this.image.src = imgsrc
    this.tx = tx;
    this.ty = ty;
    this.tw = tw;
    this.th = th;
    this.bx = bx;
    this.by = by;
    this.layer = layer;
    this.image.onload = this.onMyLoad();
}

Bit.prototype.scaleUpTrans = function() {
    return {
        width: { from: this.tw, to: this.bw, duration: 1.0, easing: Kinetic.easings.easeOutCubic }
    }
};

Bit.prototype.onMyLoad = function() {
    //take real image sizes from the image, no need to pass
    this.bw = this.image.width;
    this.bh = this.image.height;
    this.kImage = new Kinetic.Image({
        image: this.image,
        x: this.tx,
        y: this.ty,
        width: this.tw,
        height: this.th,
        draggable: true
    });
    this.kImage.on("dragstart", function() {
        this.kImage.moveToTop();
        this.transition(this.scaleUpTrans);
        this.layer.draw();
    });
    this.layer.add(this.kImage);
}


function animateTray (layer, images, frame, stage, bitsLayer) {
    if (lastTrayY > gameHeight - trayHeight) {
        var newY = lastTrayY - frame.timeDiff;
        if (newY < gameHeight - trayHeight) {
            newY = gameHeight - trayHeight;
        }
        var context = layer.getContext();
        context.drawImage(images.tray, 0, newY);
        lastTrayY = newY;
        layer.draw;
        if (newY == gameHeight - trayHeight) {
            stage.onFrame(function(frame){
                animateBits(bitsLayer, images, frame);
            });
        }
    }
}

function animateBits(bitsLayer, images, frame) {
    var alpha = bitsLayer.getAlpha();
    if (alpha < 1.0) {
        alpha = alpha + 3*frame.timeDiff/1000;
        if (alpha > 1.0) alpha = 1.0;
        bitsLayer.setAlpha(alpha);
        bitsLayer.draw();
        if (alpha === 1.0) bitsLayer.getStage().stop();
    }
}


window.onload = function(){
    var sources = {
        board: "puppy_board.png",
        tray: "tray.png",
    };
    loadImages(sources, initStage);
};


