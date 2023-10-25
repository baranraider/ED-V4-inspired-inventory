QBClothing = {}

var selectedTab = ".characterTab"
var lastCategory = "character"
var selectedCam = null;
var hasTracker = false;
var canChange = true;
var camValue = 0;

var clothingCategorys = [];

let sepetData = {
    "sapka": false,
    "gozluk": false,
    "maske": false,
    "govde": false,
    "czirh": false,
    "ckolye": false,
    "cbilezik": false,
    "csaat": false,
    "canta": false,
    "eldiven": false,
    "pantolon": false,
    "ayakkabi": false,
    "cikartma": false,
}

let totalPrice = 0
let sepetPrice = {
    "sapka": 10,
    "gozluk": 10,
    "maske": 10,
    "govde": 10,
    "czirh": 10,
    "ckolye": 10,
    "cbilezik": 10,
    "csaat": 10,
    "canta": 10,
    "eldiven": 10,
    "pantolon": 10,
    "ayakkabi": 10,
    "cikartma": 10,
}

$(document).on('click', '.clothing-menu-header-btn', function(e){
    var category = $(this).data('category');

    $(selectedTab).removeClass("selected");
    $(this).addClass("selected");
    $(".clothing-menu-"+lastCategory+"-container").css({"display": "none"});

    lastCategory = category;
    selectedTab = this;

    $(".clothing-menu-"+category+"-container").css({"display": "block"});
    $.post('https://qb-clothing/PlaySound');
})

QBClothing.ResetItemTexture = function(obj, category) {
    var itemTexture = $(obj).parent().parent().parent().parent().find('[data-type="texture"]');
    var defaultTextureValue = clothingCategorys[category].defaultTexture;
    $(itemTexture).val(defaultTextureValue);
    $.post('https://qb-clothing/updateSkin', JSON.stringify({
        clothingType: category,
        articleNumber: defaultTextureValue,
        type: "texture",
    }));
}

$(document).on('click', '.clothing-menu-option-item-right', function(e){
    e.preventDefault();

    var clothingCategory = $(this).parent().parent().parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) + 1;

    if (canChange) {
        if (clothingCategory == "model") {
            $(inputElem).val(newValue);
            $.post('https://qb-clothing/setCurrentPed', JSON.stringify({ped: newValue}), function(model){
                $("#current-model").html("<p>"+model+"</p>")
            });
            canChange = false;
            QBClothing.ResetValues()
        } else {
            if (buttonType == "item") {
                var buttonMax = $(this).parent().parent().find('[data-headertype="item-header"]').data('maxItem');
                if (clothingCategory == "accessory" && newValue == 13) {
                    $(inputElem).val(14);
                    $.post('https://qb-clothing/updateSkin', JSON.stringify({
                        clothingType: clothingCategory,
                        articleNumber: 14,
                        type: buttonType,
                    }));
                } else {
                    if (newValue <= parseInt(buttonMax)) {
                        $(inputElem).val(newValue);
                        $.post('https://qb-clothing/updateSkin', JSON.stringify({
                            clothingType: clothingCategory,
                            articleNumber: newValue,
                            type: buttonType,
                        }));
                    }
                }
                QBClothing.ResetItemTexture(this, clothingCategory);
            } else {
                var buttonMax = $(this).parent().parent().find('[data-headertype="texture-header"]').data('maxTexture');
                if (newValue <= parseInt(buttonMax)) {
                    $(inputElem).val(newValue);
                    $.post('https://qb-clothing/updateSkin', JSON.stringify({
                        clothingType: clothingCategory,
                        articleNumber: newValue,
                        type: buttonType,
                    }));
                }
            }
        }
        $.post('https://qb-clothing/PlaySound');
    }
});

$(document).on('click', '.clothing-menu-option-item-left', function(e) {
    e.preventDefault();

    var clothingCategory = $(this).parent().parent().parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) - 1;

    if (canChange) {
        if (hasTracker && clothingCategory == "accessory") {
            $.post('https://qb-clothing/TrackerError');
            return
        } else {
            if (buttonType == "item") {
                if (newValue >= clothingCategorys[clothingCategory].defaultItem) {
                    if (clothingCategory == "accessory" && newValue == 13) {
                        $(inputElem).val(12);
                        $.post('https://qb-clothing/updateSkin', JSON.stringify({
                            clothingType: clothingCategory,
                            articleNumber: 12,
                            type: buttonType,
                        }));
                    } else {
                        $(inputElem).val(newValue);
                        $.post('https://qb-clothing/updateSkin', JSON.stringify({
                            clothingType: clothingCategory,
                            articleNumber: newValue,
                            type: buttonType,
                        }));
                    }
                }
                QBClothing.ResetItemTexture(this, clothingCategory);
            } else {
                if (newValue >= clothingCategorys[clothingCategory].defaultTexture) {
                    if (clothingCategory == "accessory" && newValue == 13) {
                        $(inputElem).val(12);
                        $.post('https://qb-clothing/updateSkin', JSON.stringify({
                            clothingType: clothingCategory,
                            articleNumber: 12,
                            type: buttonType,
                        }));
                    } else {
                        $(inputElem).val(newValue);
                        $.post('https://qb-clothing/updateSkin', JSON.stringify({
                            clothingType: clothingCategory,
                            articleNumber: newValue,
                            type: buttonType,
                        }));
                    }
                }
            }
        }
        $.post('https://qb-clothing/PlaySound');
    }
});

$(".item-number").on("input", function(){
    var clothingCategory = $(this).parent().parent().parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputVal = $(this).val();

    if (buttonType == "item") {
        maxItem = $(this).parent().parent().parent().parent().find('[data-headertype="item-header"]').data('maxItem');
    } else {
        maxItem = $(this).parent().parent().parent().parent().find('[data-headertype="texture-header"]').data('maxTexture');
    }

    if (inputVal > maxItem) { 
        inputVal = maxItem
        $(this).val(maxItem);
    }
    $.post('https://qb-clothing/updateSkinOnInput', JSON.stringify({
        clothingType: clothingCategory,
        articleNumber: parseFloat(inputVal),
        type: buttonType,
    }));
});

$(document).on('click', '.clothing-menu-header-camera-btn', function(e){
    e.preventDefault();

    camValue = parseFloat($(this).data('value'));

    if (selectedCam == null) {
        $(this).addClass("selected-cam");
        $.post('https://qb-clothing/setupCam', JSON.stringify({
            value: camValue
        }));
        selectedCam = this;
    } else {
        if (selectedCam == this) {
            camValue = 0
            $(selectedCam).removeClass("selected-cam");
            $.post('https://qb-clothing/setupCam', JSON.stringify({
                value: camValue
            }));

            selectedCam = null;
        } else {
            $(selectedCam).removeClass("selected-cam");
            $(this).addClass("selected-cam");
            $.post('https://qb-clothing/setupCam', JSON.stringify({
                value: camValue
            }));

            selectedCam = this;
        }
    }
    $.post('https://qb-clothing/PlaySound');
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 68: // D
            $.post('https://qb-clothing/rotateRight');
            break;
        case 39: // ArrowRight
            $.post('https://qb-clothing/rotateRight');
            break;
        case 65: // A
            $.post('https://qb-clothing/rotateLeft');
            break;
        case 37: // ArrowLeft
            $.post('https://qb-clothing/rotateLeft');
            break;
        case 88: // KeyX
            $.post('https://qb-clothing/handsUp');
            break;
    }
});

QBClothing.ToggleChange = function(bool) {
    canChange = bool;
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                QBClothing.Open(event.data);
                break;
            case "close":
                QBClothing.Close();
                break;
            case "updateMax":
                QBClothing.SetMaxValues(event.data.maxValues);
                break;
            case "reloadMyOutfits":
                QBClothing.ReloadOutfits(event.data.outfits);
                break;
            case "toggleChange":
                QBClothing.ToggleChange(event.data.allow);
                break;
            case "ResetValues":
                QBClothing.ResetValues();
                break;
        }
    })
});

QBClothing.ReloadOutfits = function(outfits) {
    $(".clothing-menu-myOutfits-container").html("");
    $.each(outfits, function(index, outfit){
        var elem = '<div class="clothing-menu-option" data-myOutfit="'+(index + 1)+'"> <div class="clothing-menu-option-header"><p>'+outfit.outfitname+'</p></div><div class="clothing-menu-myOutfit-option-button"><p>Seç</p></div><div class="clothing-menu-myOutfit-option-button-remove"><p>Sil</p></div></div>'
        $(".clothing-menu-myOutfits-container").append(elem)
        
        $("[data-myOutfit='"+(index + 1)+"']").data('myOutfitData', outfit)
    });
}

$(document).on('click', "#save-menu", function(e){
    e.preventDefault();
    closeMenu()
    $.post('https://qb-clothing/buy', JSON.stringify({
        data: sepetData,
        price: totalPrice,
    }))
});

$(document).on('click', "#cancel-menu", function(e){
    e.preventDefault();
    QBClothing.Close();
    $.post('https://qb-clothing/PlaySound');
});

QBClothing.SetCurrentValues = function(clothingValues) {
    $.each(clothingValues, function(i, item){
        var itemCats = $(".clothing-menu-container").find('[data-type="'+i+'"]');
        var input = $(itemCats).find('input[data-type="item"]');
        var texture = $(itemCats).find('input[data-type="texture"]');

        $(input).val(item.item);
        $(texture).val(item.texture);
    });
}

QBClothing.Open = function(data) {
    totalPrice = 0
    $(".sepet-price").html("Sepet Tutarı: "+totalPrice+"$")    
    $.each(sepetData, function( key, value ) {
        if (sepetData[key]) {
            $("#"+key).removeClass("sepetaktif")
            sepetData[key] = false
        }
    });

    if (data.firstConnect || data.berberMenu) {
        $(".clothing-menu-sepet").css("display", "none")
        $("#save-menu").html("<p>Kaydet</p>")
    } else {
        $(".clothing-menu-sepet").css("display", "flex")
        $("#save-menu").html("<p>Satın Al</p>")
    }

    clothingCategorys = data.currentClothing;

    if (data.hasTracker) {
        hasTracker = true;
    } else {
        hasTracker = false;
    }

    $(".change-camera-buttons").fadeIn(150);

    $(".clothing-menu-roomOutfits-container").css("display", "none");
    $(".clothing-menu-myOutfits-container").css("display", "none");
    $(".clothing-menu-character-container").css("display", "none");
    $(".clothing-menu-clothing-container").css("display", "none");
    $(".clothing-menu-accessoires-container").css("display", "none");
    $(".clothing-menu-facefeature-container").css("display", "none");
    $(".clothing-menu-container").css({"display":"flex"}).animate({right: 0,}, 200);
    QBClothing.SetMaxValues(data.maxValues);
    $(".clothing-menu-header").html("");
    QBClothing.SetCurrentValues(data.currentClothing);
    $(".clothing-menu-roomOutfits-container").html("");
    $(".clothing-menu-myOutfits-container").html("");
    $.each(data.menus, function(i, menu){
        if (menu.selected) {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab selected" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
            $(".clothing-menu-"+menu.menu+"-container").css({"display":"block"});
            selectedTab = "." + menu.menu + "Tab";
            lastCategory = menu.menu;

        } else {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
        }

        if (menu.menu == "roomOutfits") {
            $.each(menu.outfits, function(index, outfit){
                var elem = `
                <div class="clothing-menu-option" data-outfit="`+(index + 1)+`"> 
                <div class="clothing-menu-option-header"><p>`+outfit.outfitLabel+`</p></div> 
                <div class="clothing-menu-outfit-option-button"><p>Seç</p></div> 
                </div>`
                $(".clothing-menu-roomOutfits-container").append(elem)
                
                $("[data-outfit='"+(index + 1)+"']").data('outfitData', outfit)
            });
        }

        if (menu.menu == "myOutfits") {
            $.each(menu.outfits, function(index, outfit){
                var elem = `
                <div class="clothing-menu-option" data-myOutfit="`+(index + 1)+`"> 
                    <div class="clothing-menu-option-header"><p>`+outfit.outfitname+`</p></div>
                    <div class="clothing-menu-myOutfit-option-button"><p>Seç</p></div>
                    <div class="clothing-menu-myOutfit-option-button-remove"><p>Sil</p></div>
                </div>`
                $(".clothing-menu-myOutfits-container").append(elem)
                
                $("[data-myOutfit='"+(index + 1)+"']").data('myOutfitData', outfit)
            });
        }
    });

    var menuWidth = (100 / data.menus.length)

    $(".clothing-menu-header-btn").css("width", menuWidth + "%");
}

$(document).on('click', '.clothing-menu-outfit-option-button', function(e){
    e.preventDefault();

    var oData = $(this).parent().data('outfitData');

    $.post('https://qb-clothing/selectOutfit', JSON.stringify({
        outfitData: oData.outfitData,
        outfitName: oData.outfitLabel
    }))
    $.post('https://qb-clothing/PlaySound');
});

$(document).on('click', '.clothing-menu-myOutfit-option-button', function(e){
    e.preventDefault();

    var outfitData = $(this).parent().data('myOutfitData');

    $.post('https://qb-clothing/selectOutfit', JSON.stringify({
        outfitData: outfitData.skin,
        outfitName: outfitData.outfitname,
        outfitId: outfitData.outfitId,
    }))
    $.post('https://qb-clothing/PlaySound');
});

$(document).on('click', '.clothing-menu-myOutfit-option-button-remove', function(e){
    e.preventDefault();

    var outfitData = $(this).parent().data('myOutfitData');

    $.post('https://qb-clothing/removeOutfit', JSON.stringify({
        outfitData: outfitData.skin,
        outfitName: outfitData.outfitname,
        outfitId: outfitData.outfitId,
    }));
    $.post('https://qb-clothing/PlaySound');
});

QBClothing.Close = function() {
    $.post('https://qb-clothing/close');
    closeMenu()
}

function closeMenu() {
    $(".change-camera-buttons").fadeOut(150);
    $(".clothing-menu-roomOutfits-container").css("display", "none");
    $(".clothing-menu-myOutfits-container").css("display", "none");
    $(".clothing-menu-character-container").css("display", "none");
    $(".clothing-menu-clothing-container").css("display", "none");
    $(".clothing-menu-accessoires-container").css("display", "none");
    $(".clothing-menu-facefeature-container").css("display", "none");
    $(".clothing-menu-header").html("");

    $(selectedCam).removeClass('selected-cam');
    $(selectedTab).removeClass("selected");
    selectedCam = null;
    selectedTab = null;
    lastCategory = null;
    $.post('https://qb-clothing/PlaySound');
    $(".clothing-menu-container").css({"display":"flex"}).animate({right: "-25vw",}, 200, function(){
        $(".clothing-menu-container").css({"display":"none"});
    });
}

QBClothing.SetMaxValues = function(maxValues) {
    $.each(maxValues, function(i, cat){
        if (cat.type == "character") {
            var containers = $(".clothing-menu-character-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');

            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        } else if (cat.type == "hair") {
            var containers = $(".clothing-menu-clothing-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
    
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        } else if (cat.type == "accessoires") {
            var containers = $(".clothing-menu-accessoires-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        } else if (cat.type == "facefeature") {
            var containers = $(".clothing-menu-facefeature-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
      
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")

        }
    })
}

QBClothing.ResetValues = function() {
    $.each(clothingCategorys, function(i, cat){
        var itemCats = $(".clothing-menu-container").find('[data-type="'+i+'"]');
        var input = $(itemCats).find('input[data-type="item"]');
        var texture = $(itemCats).find('input[data-type="texture"]');
        
        $(input).val(cat.defaultItem);
        $(texture).val(cat.defaultTexture);

        $.post('https://qb-clothing/updateSkin', JSON.stringify({
            clothingType: i,
            articleNumber: cat.defaultItem,
            type: "item",
        }));

        $.post('https://qb-clothing/updateSkin', JSON.stringify({
            clothingType: i,
            articleNumber: cat.defaultTexture,
            type: "texture",
        }));
    })
}

$(document).on('click', '#save-outfit', function(e){
    e.preventDefault();

    $(".clothing-menu-container").css({"display":"flex"}).animate({right: "-25vw",}, 200, function(){
        $(".clothing-menu-container").css({"display":"none"});
    });

    $(".clothing-menu-save-outfit-name").fadeIn(150);
    $.post('https://qb-clothing/PlaySound');
});

$(document).on('click', '#save-outfit-save', function(e){
    e.preventDefault();

    $(".clothing-menu-container").css({"display":"flex"}).animate({right: 0,}, 200);
    $(".clothing-menu-save-outfit-name").fadeOut(150);

    $.post('https://qb-clothing/saveOutfit', JSON.stringify({
        outfitName: $("#outfit-name").val()
    }));
    $.post('https://qb-clothing/PlaySound');
});

$(document).on('click', '#cancel-outfit-save', function(e){
    e.preventDefault();

    $(".clothing-menu-container").css({"display":"flex"}).animate({right: 0,}, 200);
    $(".clothing-menu-save-outfit-name").fadeOut(150);
    $.post('https://qb-clothing/PlaySound');
});

$(document).on('click', '.change-camera-button', function(e){
    e.preventDefault();

    var rotationType = $(this).data('rotation');

    $.post('https://qb-clothing/rotateCam', JSON.stringify({
        type: rotationType,
        camValue: camValue
    }))
});

// QBClothing.Open()


$(document).on('click', '#sapka', function(e) {
    setSepetData("sapka")
})

$(document).on('click', '#gozluk', function(e) {
    setSepetData("gozluk")
})

$(document).on('click', '#maske', function(e) {
    setSepetData("maske")
})

$(document).on('click', '#govde', function(e) {
    setSepetData("govde")
})

$(document).on('click', '#czirh', function(e) {
    setSepetData("czirh")
})

$(document).on('click', '#ckolye', function(e) {
    setSepetData("ckolye")
})

$(document).on('click', '#cbilezik', function(e) {
    setSepetData("cbilezik")
})

$(document).on('click', '#csaat', function(e) {
    setSepetData("csaat")
})

$(document).on('click', '#canta', function(e) {
    setSepetData("canta")
})

$(document).on('click', '#eldiven', function(e) {
    setSepetData("eldiven")
})

$(document).on('click', '#pantolon', function(e) {
    setSepetData("pantolon")
})

$(document).on('click', '#ayakkabi', function(e) {
    setSepetData("ayakkabi")
})

$(document).on('click', '#cikartma', function(e) {
    setSepetData("cikartma")
})

function setSepetData(item) {
    sepetData[item] = !sepetData[item]
    if (sepetData[item]) {
        totalPrice = totalPrice + sepetPrice[item]
        $("#"+item).addClass("sepetaktif")
    } else {
        totalPrice = totalPrice - sepetPrice[item]
        $("#"+item).removeClass("sepetaktif")
    }
    $(".sepet-price").html("Sepet Tutarı: "+totalPrice+"$")    
}