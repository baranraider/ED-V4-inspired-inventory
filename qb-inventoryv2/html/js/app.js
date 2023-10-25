let playerInvSlot = 60

function ra1derduzenleme(miktar, agirlik){
    return '<p><div class="item-ra1der-amount">'+miktar+'x</div><div class="item-ra1der-weight"><i class="agirlik fas fa-weight-hanging"></i> &nbsp;'+ ((agirlik * miktar) / 1000).toFixed(1) +'</div></p>'
}

var ItemStyles = {
    "pkelepce": "police",
    "weapon_stungun": "police",
    "weapon_glock": "police",
    "weapon_pumpshotgun_mk2": "police",
    "weapon_combatpdw": "police",
    "weapon_specialcarbine_mk2": "police",
    "weapon_m4": "police",
    "pkelepceanahtar": "police",
    "weapon_nightstick": "police",
    "ifak": "police",
    "gps": "police",
    "empty_evidence_bag": "police",
    "weapon_m4": "police",
    "govde": "kiyafet",
    "weapon_ltl": "police",
    "weapon_m14": "police",
    "weapon_carbinerifle_mk2": "police",
    "weapon_carbinerifle": "police",
    "empty_evidence_bag": "police",
    "weapon_taser": "police",
    "pkelepce": "police",
    "drone_flyer_7": "police",
    "mermikovani": "police",
    "walkie_lspd": "police",
    "polis_karti": "police",
    "bodycam": "police",
    "dashcam": "police",
    "weapon_stungun": "police",
    "taser_ammo": "police",
    "spikestrip": "police",
    // İllegaller
    "weapon_assaultrifle2": "illegal",
    "weapon_microsmg2": "illegal",
    "weapon_microsmg3": "illegal",
    "weapon_bats": "illegal",
    "weapon_shiv": "illegal",
    "thermite": "illegal",
    "weapon_dp9": "illegal",
    "weapon_dragunov": "illegal",
    "weapon_knife": "illegal",
    "weapon_pistol": "illegal",
    "weapon_pistol_mk2": "illegal",
    "weapon_combatpistol": "illegal",
    "weapon_appistol": "illegal",
    "weapon_pistol50": "illegal",
    "weapon_microsmg": "illegal",
    "weapon_smg": "illegal",
    "weapon_smg_mk2": "illegal",
    "weapon_assaultsmg": "illegal",
    "weapon_assaultrifle": "illegal",
    "weapon_assaultrifle_mk2": "illegal",
    "weapon_advancedrifle": "illegal",
    "weapon_pumpshotgun": "illegal",
    "weapon_assaultshotgun": "illegal",
    "weapon_molotov": "illegal",
    "weapon_snspistol": "illegal",
    "weapon_specialcarbine": "illegal",
    "weapon_heavypistol": "illegal",
    "weapon_vintagepistol": "illegal",
    "weapon_machete": "illegal",
    "weapon_machinepistol": "illegal",
    "weapon_switchblade": "illegal",
    "weapon_compactrifle": "illegal",
    "tunner_chip": "illegal",
    "dna": "illegal",
    "koko": "illegal",
    "lockpick3": "illegal",
    "weapon_minismg": "illegal",
    "lowgradefemaleseed": "illegal",
    "lowgrademaleseed": "illegal",
    "plakagovdesi": "illegal",
    "splaka": "illegal",
    "yakutelmas": "illegal",
    "hackv1": "illegal",
    "hackv2": "illegal",
    "hackv3": "illegal",
    "madde_x": "illegal",
    "nos": "illegal",
    "ot": "illegal",
    "hackcoin": "illegal",
    "weedplant_branch": "illegal",
    "weedplant_weed": "illegal",
    "weedplant_packedweed": "illegal",
    "weedplant_package": "illegal",
    "meth": "illegal",
    "lsd": "illegal",
    "coke": "illegal",
    "methkey": "illegal",
    "guvenlik_karti_a": "illegal",
    "guvenlik_karti_b": "illegal",
    "guvenlik_karti_c": "illegal",
    "guvenlik_karti_d": "illegal",
    "guvenlik_karti_e": "illegal",
    "guvenlik_karti_f": "illegal",
    "guvenlik_karti_g": "illegal",
    "guvenlik_karti_h": "illegal",
    "wet_weed": "illegal",
    "coca_leaf": "illegal",
    "islenmismeth": "illegal",
}

var totalWeight = 0;
var totalWeightOther = 0;

var playerMaxWeight = 0;
var otherMaxWeight = 0;
var success = false;
var weaponBrakeTime = 6048000000;
var yemekBrakeTime = 202800000;

var otherLabel = "";

var ClickedItemData = {};

var SelectedAttachment = null;
var AttachmentScreenActive = false;
var ControlPressed = false;
var disableRightMouse = false;
var selectedItem = null;
var inventoryOpen = false;
var IsDragging = false;

const clotheArry = ["eldiven","govde","maske","sapka","gozluk","canta","pantolon","ayakkabi","csaat","cbilezik", "czirh", "ckolye", "cikartma"]

window.onload = function(e) {
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                Inventory.Open(event.data);
                break;
            case "close":
                Inventory.Close();
                break;
            case "update":
                Inventory.Update(event.data);
                break;
            case "itemBox":
                Inventory.itemBox(event.data);
                break;
            case "requiredItem":
                Inventory.RequiredItem(event.data);
                break;
            case "toggleHotbar":
                Inventory.ToggleHotbar(event.data);
                break;
        }
    })
}


$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Inventory.Close();
            break;
        case 113: // F2
            Inventory.Close();
            break;
    }
});

$(document).on('keyup', function() {
    switch(event.keyCode) {
        case 17: // ctrl
            showClothe(false)
            break;
    }
});

let ctrlPressed = false
function showClothe(show, data, inventory) {
    if (show) {
        if (data.info && data.info.type == "clothe") {
            $.post("https://qb-inventoryv2/showClothe", JSON.stringify({ showInventory: true, clothData: data }));
            if (ctrlPressed) { return }
            ctrlPressed = true
            $('.inv-clothes').css('display', 'block');
            $('.inv-option-bg').css('display', 'none');
            
            if (inventory == "player") {
                $(".other-inventory").css("display", "none")
            } else {
                $(".player-inventory").css("display", "none")
                $(".inventory-info").css("flex-direction", "row-reverse")
                $(".inv-container").css("flex-direction", "row-reverse")
            }
            $(".inv-container").css("margin-left", "-35vh")
            $(".inv-options").css("opacity", "1.0")
            $(".ply-iteminfo-container").css("opacity", "0.0")
        }
    } else if (ctrlPressed && !show) {
        ctrlPressed = false
        $(".player-inventory").css("display", "block")
        $(".inv-options").css("opacity", "1.0")
        $(".other-inventory").css("display", "block")
        $(".ply-iteminfo-container").css("opacity", "1.0")
        $(".inventory-info").css("flex-direction", "row")
        $(".inv-container").css("flex-direction", "row")
        $(".inv-container").css("margin-left", "0")
        $.post("https://qb-inventoryv2/showClothe", JSON.stringify({ showInventory: false }));
    }
}



$(document).on("mouseenter", ".item-slot", function(e){
    e.preventDefault();
    $(".ply-iteminfo-container").css("opacity", "0.0");
    if ($(this).data("item") != null) {
        $(".ply-iteminfo-container").css("opacity", "1.0");
        FormatItemInfo($(this).data("item"), $(this));
    }
});

$(document).on("mouseleave", ".item-slot", function(e){
    $(".ply-iteminfo-container").css("opacity", "0.0");
});

$(document).on('dblclick', '.item-slot', function(event){
    switch(event.which) {
        case 1:
        item = $(this).data('item') 
        if (item != null) {
            if(item.useable) {
                fromInventory = $(this).parent();
                if ($(fromInventory).attr('data-inventory') == "player") {
                     if (item.shouldClose) {
                         Inventory.Close();
                     }
                    $.post("https://qb-inventoryv2/UseItem", JSON.stringify({
                        inventory: "player",
                        item: item,
                    }));
                    Inventory.Close();
                }
            }
        }
        break;
    }
});

$(document).on('mousedown', '.item-slot', function(event){
    if(event.shiftKey) {
        switch(event.which) {
            case 1:
            item = $(this).data('item') 
            if (item != null) {
                if(item.useable) {
                    fromInventory = $(this).parent();
                    if ($(fromInventory).attr('data-inventory') == "player") {
                        if (item.shouldClose) {
                            Inventory.Close();
                        }
                        $.post("https://qb-inventoryv2/UseItem", JSON.stringify({
                            inventory: "player",
                            item: item,
                        }));
                    }
                }
            }
            break;
        }
    } else if (event.ctrlKey) {
        showClothe(true, $(this).data('item'), $($(this).parent()).attr('data-inventory'))
    }
});

$(document).on('mousedown', '.item-slot', function(event){
    switch(event.which) {
        case 3:
        if(event.shiftKey) {
            fromSlot = $(this).attr("data-slot");
            fromInventory = $(this).parent();

            if ($(fromInventory).attr('data-inventory') == "player") {
                toInventory = $(".item-slots-other");
            } else {
                toInventory = $(".item-slots-player");
            }
            toSlot = GetFirstFreeSlot(toInventory, $(this));
            if ($(this).data('item') === undefined) {
                return;
            }
            toAmount = $(this).data('item').amount;

            if (toSlot === null) {
                InventoryError();
                return;
            }
            if (toSlot > playerInvSlot) {
                InventoryError();
                return;
            }
            if (fromSlot == toSlot && fromInventory == toInventory) {
                return;
            }
            if (toAmount >= 0) {
                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                }
            }
            
        }
        break;
    }
});

// Autostack Quickmove
function GetFirstFreeSlot($toInv, $fromSlot) {
    var retval = null;
    $.each($toInv.find('.item-slot'), function(i, slot){
        if ($(slot).data('item') === undefined) {
            if (retval === null) {
                retval = (i + 1);
            }
        }
    });
    return retval;
}

$(document).on("click", ".item-slot", function(e){
    e.preventDefault();
    var ItemData = $(this).data("item");

    if (ItemData !== null && ItemData !== undefined) {
        if (ItemData.name !== undefined) {
            if ((ItemData.name).split("_")[0] == "weapon") {
                if (!$("#weapon-attachments").length) {
                    // if (ItemData.info.attachments !== null && ItemData.info.attachments !== undefined && ItemData.info.attachments.length > 0) {
                    $(".inv-option-bg").append('<div class="inv-option-item" id="weapon-attachments"><p>EKLENTİLER</p></div>');
                    $("#weapon-attachments").hide().fadeIn(250);
                    ClickedItemData = ItemData;
                    // }
                } else if (ClickedItemData == ItemData) {
                    $("#weapon-attachments").fadeOut(250, function(){
                        $("#weapon-attachments").remove();
                    });
                    ClickedItemData = {};
                }else {
                    ClickedItemData = ItemData;
                }
            } else {
                ClickedItemData = {};
                if ($("#weapon-attachments").length) {
                    $("#weapon-attachments").fadeOut(250, function(){
                        $("#weapon-attachments").remove();
                    });
                }
            }
        } else {
            ClickedItemData = {};
            if ($("#weapon-attachments").length) {
                $("#weapon-attachments").fadeOut(250, function(){
                    $("#weapon-attachments").remove();
                });
            } 
        }
    } else {
        ClickedItemData = {};
        if ($("#weapon-attachments").length) {
            $("#weapon-attachments").fadeOut(250, function(){
                $("#weapon-attachments").remove();
            });
        } 
    }
});

$(document).on('click', '#craft-btn', function(e){
    $.post("https://qb-inventoryv2/OpenCraft", JSON.stringify({}));
});

$(document).on('click', '.weapon-attachments-back', function(e){
    e.preventDefault();
    $("#qbus-inventory").css({"display":"flex"});
    $(".weapon-attachments-container").css({"display":"none"});
    $("#weapon-attachments").remove();
    AttachmentScreenActive = false;
});

function FormatAttachmentInfo(data) {
    $.post("https://qb-inventoryv2/GetWeaponData", JSON.stringify({
        weapon: data.name,
        ItemData: ClickedItemData
    }), function(data){
        var AmmoLabel = "9mm";
        var Durability = 100;
        if (data.WeaponData.ammotype == "AMMO_RIFLE") {
            AmmoLabel = "5.56 & 7.62"
        } else if (data.WeaponData.ammotype == "AMMO_SHOTGUN") {
            AmmoLabel = "12 Saçma"
        }
  
        var durubalityData = durubalityControl(ClickedItemData)
        var Durability = durubalityData.durubality

        $(".weapon-attachments-container-title").html(data.WeaponData.label + " | " + AmmoLabel);
        $(".weapon-attachments-container-description").html(data.WeaponData.description);
        $(".weapon-attachments-container-details").html('<span style="font-weight: bold; letter-spacing: .1vh;">Seri Numarası</span><br> ' + ClickedItemData.info.serie + '<br><br><span style="font-weight: bold; letter-spacing: .1vh;">Dayanıklık - ' + Durability + '% </span> <div class="weapon-attachments-container-detail-durability"><div class="weapon-attachments-container-detail-durability-total"></div></div>')
        $(".weapon-attachments-container-detail-durability-total").css({
            width: Durability + "%"
        });
        $(".weapon-attachments-container-image").attr('src', './attachment_images/' + data.WeaponData.name + '.png');
        $(".weapon-attachments").html("");
        
        if (data.AttachmentData !== null && data.AttachmentData !== undefined) {
            if (data.AttachmentData.length > 0) {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Eklentiler</span>');
                $.each(data.AttachmentData, function(i, attachment){
                    var WeaponType = (data.WeaponData.ammotype).split("_")[1].toLowerCase();
                    $(".weapon-attachments").append('<div class="weapon-attachment" id="weapon-attachment-'+i+'"> <div class="weapon-attachment-label"><p>' + attachment.label + '</p></div> <div class="weapon-attachment-img"><img src="./images/' + attachment.attachment + '.png"></div> </div>')
                    attachment.id = i;
                    $("#weapon-attachment-"+i).data('AttachmentData', attachment)
                });
            } else {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Silah Üzerinde Eklenti Bulunmuyor</span>');
            }
        } else {
            $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Silah Üzerinde Eklenti Bulunmuyor</span>');
        }

        handleAttachmentDrag()
    });
}

var AttachmentDraggingData = {};

function handleAttachmentDrag() {
    $(".weapon-attachment").draggable({
        helper: 'clone',
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        start: function(event, ui) {
           var ItemData = $(this).data('AttachmentData');
           $(this).addClass('weapon-dragging-class');
           AttachmentDraggingData = ItemData
        },
        stop: function() {
            $(this).removeClass('weapon-dragging-class');
        },
    });
    $(".weapon-attachments-remove").droppable({
        accept: ".weapon-attachment",
        hoverClass: 'weapon-attachments-remove-hover',
        drop: function(event, ui) {
            $.post('https://qb-inventoryv2/RemoveAttachment', JSON.stringify({
                AttachmentData: AttachmentDraggingData,
                WeaponData: ClickedItemData,
            }), function(data){
                if (data.Attachments !== null && data.Attachments !== undefined) {
                    if (data.Attachments.length > 0) {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                        });
                    } else {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                            $(".weapon-attachments").html("");
                        });
                        $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Silah Üzerinde Eklenti Bulunmuyor</span>');
                    }
                } else {
                    $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function(){
                        $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                        AttachmentDraggingData = null;
                        $(".weapon-attachments").html("");
                    });
                    $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Silah Üzerinde Eklenti Bulunmuyor</span>');
                }
            });
        },
    });
}

$(document).on('click', '#weapon-attachments', function(e){
    e.preventDefault();
    if (!Inventory.IsWeaponBlockedA(ClickedItemData.name)) {
        $(".weapon-attachments-container").css({"display":"block"})
        $("#qbus-inventory").css({"display":"none"})
        AttachmentScreenActive = true;
        FormatAttachmentInfo(ClickedItemData);    
    } else {
        $.post('https://qb-inventoryv2/Notify', JSON.stringify({
            message: "Bu Silahın Eklentilerini Düzenleyemezsin",
            type: "error"
        }))
    }
});

function FormatItemInfo(itemData, dom) {
    let element = $('.ply-iteminfo-container');
    let itemOffset = $(dom).offset();

    element.css('top', itemOffset.top - element.height());

    let leftOffset = itemOffset.left + 92;
    if (leftOffset + element.width() > $(window).width()) {
        leftOffset = $(window).width() - element.width() - 20;
    }

    element.css('left', leftOffset);

    if (itemData != null && itemData.info != "") {
        if (itemData.type == "weapon") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')

            var durubalityData = durubalityControl(itemData)
            var durubality = durubalityData.durubality

            if (itemData.info.serie == undefined) {
                itemData.info.serie = "Bilinmiyor!"
            } 

            if (itemData.info.ammo == undefined) {
                itemData.info.ammo = 0;
            } else {
                itemData.info.ammo != null ? itemData.info.ammo : 0;
            }

            if (itemData.info.attachments != null) {
                var attachmentString = "";
                $.each(itemData.info.attachments, function (i, attachment) {
                    if (i == (itemData.info.attachments.length - 1)) {
                        attachmentString += attachment.label
                    } else {
                        attachmentString += attachment.label + ", "
                    }
                });
                $(".item-info-description").html('<p><strong>Toplam Ağırlık: </strong><span>' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + 'kg</span></p><p><strong>Seri Numarası: </strong><span>' + itemData.info.serie +  '</span></p><p><strong>Sağlamlık: </strong><span>' + durubality + '%</span></p><p><strong>Eklentiler: </strong><span>' + attachmentString + '</span></p><p>' + itemData.description + '</p>');
            } else{
                $(".item-info-description").html('<p><strong>Toplam Ağırlık: </strong><span>' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + 'kg</span></p><p><strong>Seri Numarası: </strong><span>' + itemData.info.serie + '</span></p><p><strong>Sağlamlık: </strong><span>' + durubality + '%</span></p><p>' + itemData.description + '</p>');
            }

            if (itemData.info.costs != undefined && itemData.info.costs != null) {
                $(".item-info-title").html('<p>'+itemData.label+'</p>')
                $(".item-info-description").html('<p><strong>Toplam Ağırlık: </strong><span>' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + 'kg</span></p><p>'+ itemData.info.costs + '</p>');
            }
        
        } else if (itemData.info.costs != undefined && itemData.info.costs != null) {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Toplam Ağırlık: </strong><span>' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + 'kg</span></p><p>'+ itemData.info.costs + '</p>');
        } else if (itemData.info.type == "menu") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            let first = true
            let descText = ""
            for(var key in itemData.info.items){
                if (first) {
                    first = false
                    descText = itemData.info.items[key].amount+"x "+itemData.info.items[key].label
                } else {
                    descText = descText + ", "+itemData.info.items[key].amount+"x "+itemData.info.items[key].label
                }
            };
    
            $(".item-info-description").html('<p> Paket İçeriği: '+ descText + '</p>');
        } else if (itemData.name == "id_card") {
             var gender = "Erkek";
            if (itemData.info.gender == 1) {
                gender = "Kadın";
            }
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>Kimlik Numarası: </strong><span>" +
                itemData.info.citizenid +
                "</span></p><p><strong>İsim: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Soyisim: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Doğum Tarihi: </strong><span>" +
                itemData.info.birthdate +
                "</span></p><p><strong>Cinsiyet: </strong><span>" +
                gender +
                "</span></p><p><strong>Ulus: </strong><span>" +
                itemData.info.nationality +
                "</span></p>"
            );
       } else if (itemData.name == "wallet") {
        $(".item-info-title").html("<p>" + itemData.label + "</p>");
        $(".item-info-description").html(
            "<p><strong>Sahip: </strong><span>" + itemData.info.owner + "</span></p>"
        );
        } else if (itemData.name == "driver_license") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>İsim: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Soyisim: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Doğum Tarihi: </strong><span>" +
                itemData.info.birthdate +
                "</span></p><p><strong>Lisans Tipi: </strong><span>" +
                "C Sürücü Lisansı" +
                "</span></p>"
            );
        } else if (itemData.name == "weaponlicense") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>İsim: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Soyisim: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Doğum Tarihi: </strong><span>" +
                itemData.info.birthdate +
                "</span></p>"
            );
        } else if (itemData.name == "bag") {
        $(".item-info-title").html("<p>" + itemData.label + "</p>");
        $(".item-info-description").html(
            "</span></p><p><strong>Çanta Etiketi: </strong><span>" +
            itemData.info.stashName +
            "</span></p>"
        );
       }
        else if (itemData.name == "polis_karti") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "</span></p><p><strong>İsim: </strong><span>" +
                itemData.info.charName +
                "</span></p><p><strong>Rütbe: </strong><span>" +
                itemData.info.jobGrade +
                "</span></p>"
            );
        } else if (itemData.info.type == "note") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p>'+ itemData.description + '</p><p>'+itemData.info.info+'</p>');
        } else if (itemData.name == "cigpacket") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html("</span></p><p><strong>Kalan sigara: </strong><span>"+itemData.info.sigara+"</span></p>");
        } else if (itemData.name == "game_ticket") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Numaran: </strong><span>' + itemData.info.cardnumber + '</span></p><p>'+ itemData.description + '</p>');
        } else if (itemData.name == "evlilikyuzugu") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Toplam Ağırlık: </strong><span>' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + 'kg</span></p><p><strong>Aile: </strong><span>' + itemData.info.aile + '</span></p><p><strong>Nişan Tarihi: </strong><span>' + itemData.info.tarih + '</span></p>');
        } else if (itemData.info.type == "yemek") {
            if (itemData.info.durubality) {
                var durubalityData = durubalityControl(itemData)
                var durubality = durubalityData.durubality
            }

            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong>Toplam Ağırlık: </strong><span>' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + 'kg</span></p><p><strong>Tazelik: </strong><span>' + durubality + '%</span></p><p>' + itemData.description + '</p>')
        } 
        else {
            defaultDescription(itemData)
        }
    } else {
        defaultDescription(itemData)
    }
 }

function defaultDescription(itemData) {
    $(".item-info-title").html('<p>'+itemData.label+'</p>')
    if (itemData.description.length == 0) {
        itemData.description = "Açıklama Yok!"
    }
    $(".item-info-description").html('<p><strong>Toplam Ağırlık: </strong><span>' + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + 'kg</span></p><p>' + itemData.description + '</p>')
}

function handleDragDrop() {
    $(".item-drag").draggable({
        helper: 'clone',
        appendTo: "body",
        scroll: false,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".item-nodrag",
        start: function(event, ui) {
            IsDragging = true;
            success = true;
            $(this).find("img").css("filter", "brightness(50%)");

            var itemData = $(this).data("item");
            var dragAmount = $("#item-amount").val();
            if (!itemData.useable) {
                $("#item-use").css("opacity", "0.3");
            }
            if (dragAmount == 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html("0");
                    $(".ui-draggable-dragging")
                        .find(".item-slot-amount p")
                        .html(" " + itemData.amount + " $" + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this).find(".item-slot-amount p").html("0");
                    $(".ui-draggable-dragging")
                        .find(".item-slot-amount p")
                        .html(
                            itemData.amount +
                            " " +
                            
                            " "
                        );
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
            } else if (dragAmount > itemData.amount) {
                if (itemData.price != null) {
                    $(this)
                        .find(".item-slot-amount p")
                        .html(" " + itemData.amount + " $" + itemData.price);
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this)
                        .find(".item-slot-amount p")
                        .html(
                            itemData.amount +
                            " " +
                            
                            " "
                        );
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            } else if (dragAmount > 0) {
                if (itemData.price != null) {
                    $(this)
                        .find(".item-slot-amount p")
                        .html(" " + itemData.amount + " $" + itemData.price);
                    $(".ui-draggable-dragging")
                        .find(".item-slot-amount p")
                        .html(" " + itemData.amount + " $" + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                } else {
                    $(this)
                        .find(".item-slot-amount p")
                        .html(
                            itemData.amount -
                            dragAmount +
                            " " +
                            (
                                (itemData.weight * (itemData.amount - dragAmount)) /
                                1000
                            ).toFixed(1) +
                            " "
                        );
                    $(".ui-draggable-dragging")
                        .find(".item-slot-amount p")
                        .html(
                            dragAmount +
                            " " +
                            
                            " "
                        );
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    if ($(this).parent().attr("data-inventory") == "hotbar") {
                        // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                    }
                }
            } else {
                if ($(this).parent().attr("data-inventory") == "hotbar") {
                    // $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
                $(".ui-draggable-dragging").find(".item-slot-key").remove();
                $(this)
                    .find(".item-slot-amount p")
                    .html(
                        itemData.amount +
                        " " +
                        
                        " "
                    );
                InventoryError($(this).parent(), $(this).attr("data-slot"));
            }
        },
        stop: function() {
            setTimeout(function() {
                IsDragging = false;
            }, 300);
            var itemData = $(this).data("item");
            if (itemData) { fixWeight($(this), itemData) }
            $(this).find("img").css("filter", "brightness(100%)");
            $("#item-use").css("opacity", "1.0");
        },
    });

    $(".item-slot").droppable({
        hoverClass: 'item-slot-hoverClass',
        drop: function(event, ui) {
            setTimeout(function() {
                IsDragging = false;
            }, 300)
            fromSlot = ui.draggable.attr("data-slot");
            fromInventory = ui.draggable.parent();
            toSlot = $(this).attr("data-slot");
            toInventory = $(this).parent();
            toAmount = $("#item-amount").val();
            if (!success) {
                return;
            }
            if (fromSlot == toSlot && fromInventory == toInventory) {
                return;
            }
            if (toAmount >= 0) {
                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                }
            }
        },
    });

    $("#item-use").droppable({
        hoverClass: 'button-hover',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            if(fromData.useable) {
                if (fromData.shouldClose) {
                    Inventory.Close();
                }
                $.post("https://qb-inventoryv2/UseItem", JSON.stringify({
                    inventory: fromInventory,
                    item: fromData,
                }));
                Inventory.Close();
            }
        }
    });

    $("#item-drop").droppable({
        hoverClass: 'item-slot-hoverClass',
        drop: function(event, ui) {
            setTimeout(function(){
                IsDragging = false;
            }, 300)
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            amount = $("#item-amount").val();
            if (amount == 0) {amount=fromData.amount}
            $(this).css("background", "rgba(35,35,35, 0.7");
            $.post("https://qb-inventoryv2/DropItem", JSON.stringify({
                inventory: fromInventory,
                item: fromData,
                amount: parseInt(amount),
            }));
            Inventory.Close();
        }
    })
}

function fixWeight(data, itemData) {
    setItemSlot(data.parent(), data.attr("data-slot"), itemData)
    // data.css("background", "var(--item-slot-color)");
}


function updateweights($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {

    if ($toInv.attr("data-inventory") == undefined || $fromInv.attr("data-inventory") == undefined) { return InventoryError(); }
    
    if ($toInv.attr("data-inventory") != $fromInv.attr("data-inventory")) { // 2. envanter ile swap kapatma
        if ($toInv.find("[data-slot=" + $toSlot + "]").data("item")) {
            if ($toInv.find("[data-slot=" + $toSlot + "]").data("item").label != $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").label || $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").name.includes("weapon")) {
                if ($toInv.find("[data-slot=" + $toSlot + "]").data("item")) {
                    itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
                    setItemSlot($fromInv, $fromSlot, itemData)
                    InventoryError();
                    return false;
                }
            }
        }
    }
    
    if (($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "hotbar") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "hotbar")) {
        return true;
    }

    if ($fromInv.find("[data-slot=" + $fromSlot + "]").data("item").amount <= $toAmount) {
        $toAmount= $fromInv.find("[data-slot=" + $fromSlot + "]").data("item").amount
    }

    if (($fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory").split("-")[0] == "itemshop") || ($fromInv.attr("data-inventory") == "crafting" && $toInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            setShopItemSlot($fromInv, $fromSlot, itemData)
        } else {
            setItemSlot($fromInv, $fromSlot, itemData)
        }
        InventoryError();
        return false;
    }

    $("#player-inv-weight").html((parseInt(totalWeight) / 1000).toFixed(1) +"/" +(playerMaxWeight / 1000).toFixed(1));
    var per =(totalWeight/1000)/(playerMaxWeight/100000)
    $(".player-weight").css("width",per+"%")

    if ($toAmount == 0 && ($fromInv.attr("data-inventory").split("-")[0] == "itemshop" || $fromInv.attr("data-inventory") == "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            setShopItemSlot($fromInv, $fromSlot, itemData)
        } else {
            setItemSlot($fromInv, $fromSlot, itemData)
        }
        InventoryError();
        return false;
    }

    if ($toInv.attr("data-inventory").split("-")[0] == "itemshop" || $toInv.attr("data-inventory") == "crafting") {
        itemData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toInv.attr("data-inventory").split("-")[0] == "itemshop") {
            setShopItemSlot($toInv, $toSlot, itemData)
        } else {
            setItemSlot($toInv, toSlot, itemData)
        }
        InventoryError();
        return false;
    }

    if ($fromInv.attr("data-inventory") != $toInv.attr("data-inventory")) {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toAmount == 0) {$toAmount=fromData.amount}
        if (toData == null || fromData.name == toData.name) {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
            }
        } else {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - (fromData.weight * $toAmount);
                totalWeight = totalWeight + (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther + (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther - (toData.weight * toData.amount);
            } else {
                totalWeight = totalWeight + (fromData.weight * $toAmount);
                totalWeight = totalWeight - (toData.weight * toData.amount)

                totalWeightOther = totalWeightOther - (fromData.weight * $toAmount);
                totalWeightOther = totalWeightOther + (toData.weight * toData.amount);
            }
        }
    }

    if (totalWeight > playerMaxWeight || (totalWeightOther > otherMaxWeight && $fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting")) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        setItemSlot($fromInv, $fromSlot, itemData)
        InventoryError();
        return false;
    }
    
    Inventory.SetWeight("player", totalWeight, playerMaxWeight)

    if ($fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $toInv.attr("data-inventory").split("-")[0] != "itemshop" && $fromInv.attr("data-inventory") != "crafting" && $toInv.attr("data-inventory") != "crafting") {
        $("#other-inv-label").html(otherLabel)
        Inventory.SetWeight("other", totalWeightOther, otherMaxWeight)
    }

    $("#other-inv-weight").html((parseInt(totalWeightOther) / 1000).toFixed(1) +"/" +(otherMaxWeight / 1000).toFixed(1));
    var per1 =(totalWeightOther/1000)/(otherMaxWeight/100000)
    $(".other-weight").css("width",per1+"%");

    return true;
}

var combineslotData = null;
$(document).on('click', '.CombineItem', function(e){
    e.preventDefault();
    if (combineslotData.toData.combinable.anim != null) {
        $.post('https://qb-inventoryv2/combineWithAnim', JSON.stringify({
            combineData: combineslotData.toData.combinable,
            usedItem: combineslotData.toData.name,
            requiredItem: combineslotData.fromData.name
        }))
    } else {
        $.post('https://qb-inventoryv2/combineItem', JSON.stringify({
            reward: combineslotData.toData.combinable.reward,
            toItem: combineslotData.toData.name,
            fromItem: combineslotData.fromData.name
        }))
    }
    Inventory.Close();
});

$(document).on('click', '.save-settings', function(e){
    emoteChat = $('input[name="emoteChat"]').prop('checked');

    $.post(
        'https://qb-inventoryv2/UpdateSettings',
        JSON.stringify({
            emoteChat: emoteChat,
            blackBar: blackBar,
            intMenu: intMenu,
        }),
    );
});

function swap($fromSlot, $toSlot, $fromInv, $toInv, $toAmount) {
    fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
    toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
    if (toData != undefined) {
        if (ItemStyles[toData.name]) {
            var miktar = $("#item-amount").val();
            if (toData.amount - miktar == 0 || miktar == 0) {
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass(ItemStyles[toData.name])
            }
            $fromInv.find("[data-slot=" + $fromSlot + "]").addClass(ItemStyles[toData.name])
        }
        if (toData != undefined && $toInv.attr("data-inventory") == "player") {
            for (let i = 0; i < clotheArry.length; i++) {
                if (toData.name == clotheArry[i] || fromData.name == clotheArry[i] ) {
                    InventoryError();
                    return;
                }
            }
        }
    
        if (fromData.unique) {
            if (fromData.name == toData.name) {
                InventoryError();
                return;
            }
        }
    }
    if (ItemStyles[fromData.name]) {
        var miktar = $("#item-amount").val();
        if (fromData.amount - miktar == 0 || miktar == 0) {
            $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass(ItemStyles[fromData.name])
        }
        $toInv.find("[data-slot=" + $toSlot + "]").addClass(ItemStyles[fromData.name])
    }

    if (fromData !== undefined) {    

        if (($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") && $toInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory") == "crafting") {
            InventoryError();
            return;
        }

        if ($toAmount == 0 && $fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $fromInv.attr("data-inventory") == "crafting") {
            InventoryError();
            return;
        } else if ($toAmount == 0) {
            $toAmount=fromData.amount
        }

        if (fromData.amount <= $toAmount) {
            $toAmount= fromData.amount
        }

        if((toData != undefined || toData != null) && toData.name == fromData.name && !fromData.unique) {
            var newData = [];
            newData.name = toData.name;
            newData.label = toData.label;
            newData.amount = (parseInt($toAmount) + parseInt(toData.amount));
            newData.type = toData.type;
            newData.description = toData.description;
            newData.image = toData.image+".png";
            newData.weight = toData.weight;
            newData.info = toData.info;
            newData.useable = toData.useable;
            newData.unique = toData.unique;
            newData.slot = parseInt($toSlot);

            if (fromData.amount == $toAmount) {
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label">' + newData.label + '</div>';
                if (newData.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + newData.label + '</div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    setItemSlot($toInv, $toSlot, newData, true, ItemLabel)
                } else {
                    setItemSlot($toInv, $toSlot, newData, false, ItemLabel)
                }
                
                if (newData.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        var durubalityData = durubalityControl(newData)
                        var qualityLabel = durubalityData.qualityLabel 
                        var QualityColor = durubalityData.QualityColor
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        });
                    }
                }

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");

                $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div>');
            } else if(fromData.amount > $toAmount) {
                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);

                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label">' + newData.label + '</div>';
                if (newDataFrom.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"100</div></div><div class="item-slot-label">' + newData.label + '</div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    setItemSlot($toInv, $toSlot, newData, true, ItemLabel)
                } else {
                    setItemSlot($toInv, $toSlot, newData, false, ItemLabel)
                }

                if (newDataFrom.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                        var durubalityData = durubalityControl(newDataFrom)
                        var qualityLabel = durubalityData.qualityLabel 
                        var QualityColor = durubalityData.QualityColor
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        });
                    }
                }
                
                // From Data zooi
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");

                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.name + '.png" alt="' + newDataFrom.name + '" /></div><div class="item-slot-price">$'+newDataFrom.price+'</div>' + newDataFrom.label);
                } else {
                    var ItemLabel = '<div class="item-slot-label"><p>' + newDataFrom.label + '</p></div>';
                    if (newDataFrom.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + newDataFrom.label + '</div>';                       
                        }
                    }
                
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        setItemSlot($fromInv, $fromSlot, newDataFrom, true, ItemLabel)
                    } else {
                        setItemSlot($fromInv, $fromSlot, newDataFrom, false, ItemLabel)
                    }


                    if (newDataFrom.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            var durubalityData = durubalityControl(newDataFrom)
                            var qualityLabel = durubalityData.qualityLabel 
                            var QualityColor = durubalityData.QualityColor
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            });
                        }
                    }
                }    
            }
            $.post("https://qb-inventoryv2/SetInventoryData", JSON.stringify({
                fromInventory: $fromInv.attr("data-inventory"),
                toInventory: $toInv.attr("data-inventory"),
                fromSlot: $fromSlot,
                toSlot: $toSlot,
                fromAmount: $toAmount,
                sound: true,
            }));
        } else {
            if (fromData.amount == $toAmount) {
                if ($toSlot > playerInvSlot && ($toInv.attr("data-inventory") == "player" || $toInv.attr("data-inventory").split("-")[0] == "otherplayer" )) {
                    let haveItem = false
                    $.each($toInv.find('.item-slot'), function(i, slot){
                        const itemData = $(slot).data('item')
                        if (itemData != undefined) {
                            if (itemData.slot > 30) {
                                if (itemData.name == fromData.name && $toSlot != itemData.slot) {
                                    haveItem = true
                                }
                            }
                        }
                    });

                    if (haveItem) {                 
                        InventoryError();
                        return;
                    }
                } 

                fromData.slot = parseInt($toSlot);
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label">' + fromData.label + '</div>';
                if (fromData.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + fromData.label + '</div>';                       
                    }
                }
                let itemClothe = false
 
                if ($fromSlot > 30 || $toSlot > 30) {
                    for (let i = 0; i < clotheArry.length; i++) {
                        if (fromData.name == clotheArry[i]  ) {
                            itemClothe = true
                            break;
                        }
                    }
                }
                
                if (itemClothe) {
                    setItemSlot($toInv, $toSlot, fromData, ItemLabel)
                    $.post("https://qb-inventoryv2/SetInventoryClotheData", JSON.stringify({
                        toSlot: $toSlot,
                        fromSlot: $fromSlot,
                        data: fromData,
                        toInventory: $toInv.attr("data-inventory"),
                        fromInventory: $fromInv.attr("data-inventory"),
                    }));

                } else {
                    setItemSlot($toInv, $toSlot, fromData, ItemLabel)
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    setItemSlot($toInv, $toSlot, fromData, true, ItemLabel)
                } else {
                    setItemSlot($toInv, $toSlot, fromData, false, ItemLabel)
                }

                if (fromData.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        var durubalityData = durubalityControl(fromData)
                        var qualityLabel = durubalityData.qualityLabel 
                        var QualityColor = durubalityData.QualityColor
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        });
                    }
                }
    
                if (toData != undefined) {
                    toData.slot = parseInt($fromSlot);
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
                    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);

                    var ItemLabel = '<div class="item-slot-label"><p>' + toData.label + '</p></div>';
                    if (toData.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + toData.label + '</div>';                       
                        }
                    }
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        setItemSlot($fromInv, $fromSlot, toData, true, ItemLabel)
                    } else {
                        setItemSlot($fromInv, $fromSlot, toData, false, ItemLabel)
                    }

                    if (toData.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            var durubalityData = durubalityControl(toData)
                            var qualityLabel = durubalityData.qualityLabel 
                            var QualityColor = durubalityData.QualityColor
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            });
                        }
                    }

                    $.post("https://qb-inventoryv2/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                        toAmount: toData.amount,
                        sound: true,
                    })); 
                    
                } else {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
    
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key">' + $fromSlot + '</div><div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div>');
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div>');
                    }

                    $.post("https://qb-inventoryv2/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                        sound: true,
                    }));
                }
            } else if(fromData.amount > $toAmount && (toData == undefined || toData == null)) {
                var newDataTo = [];
                newDataTo.name = fromData.name;
                newDataTo.label = fromData.label;
                newDataTo.amount = parseInt($toAmount);
                newDataTo.type = fromData.type;
                newDataTo.description = fromData.description;
                newDataTo.image = fromData.name + ".png";
                newDataTo.weight = fromData.weight;
                newDataTo.info = fromData.info;
                newDataTo.useable = fromData.useable;
                newDataTo.unique = fromData.unique;
                newDataTo.slot = parseInt($toSlot);
    
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newDataTo);
    
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label">' + newDataTo.label + '</div>';
                if (newDataTo.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + newDataTo.label + '</div>';                       
                    }
                }

                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    setItemSlot($toInv, $toSlot, newDataTo, true, ItemLabel)
                } else {
                    setItemSlot($toInv, $toSlot, newDataTo, false, ItemLabel)
                }

                if (newDataTo.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        var durubalityData = durubalityControl(newDataTo)
                        var qualityLabel = durubalityData.qualityLabel 
                        var QualityColor = durubalityData.QualityColor
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        });
                    }
                }

                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt((fromData.amount - $toAmount));
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.name + ".png";
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.useable = fromData.useable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
    
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    
                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + newDataFrom.name + '.png" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount">('+newDataFrom.amount+')</div><div class="item-slot-price" style="color: green;">$'+newDataFrom.price+'</div>' + newDataFrom.label);
                } else {

                    var ItemLabel = '<div class="item-slot-label">' + newDataFrom.label + '</div>';
                    if (newDataFrom.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + newDataFrom.label + '</div>';                       
                        }
                    }

                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        setItemSlot($fromInv, $fromSlot, newDataFrom, true, ItemLabel)
                    } else {
                        setItemSlot($fromInv, $fromSlot, newDataFrom, false, ItemLabel)
                    }

                    if (newDataFrom.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            var durubalityData = durubalityControl(newDataFrom)
                            var qualityLabel = durubalityData.qualityLabel 
                            var QualityColor = durubalityData.QualityColor
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                "width": qualityLabel + "%",
                                "background-color": QualityColor
                            });
                        }
                    }
                }
                $.post("https://qb-inventoryv2/SetInventoryData", JSON.stringify({
                    fromInventory: $fromInv.attr("data-inventory"),
                    toInventory: $toInv.attr("data-inventory"),
                    fromSlot: $fromSlot,
                    toSlot: $toSlot,
                    fromAmount: $toAmount,
                    sound: true,
                }));
            } else {
                InventoryError();
            }
        }
    }
    handleDragDrop();
}


function InventoryError() {
    success = false;
    $.post("https://qb-inventoryv2/PlayDropFail", JSON.stringify({}));
}

function durubalityControl(item) {
    var durubality = 100
    var QualityColor = "rgb(39, 174, 96)";
    if (item.info.durubality) {
        let itemType = weaponBrakeTime
        if (item.info.type == "yemek") { itemType = yemekBrakeTime };

        var date = parseInt(item.info.durubality+"000.0") + itemType
        var durubality_frist = (date - new Date()) / 86400000 //(1000 * 60 * 60 * 24)
        if (item.info.type == "yemek") {
            durubality = (100 - ((itemType / 86400000 - durubality_frist)*50)).toFixed(2)
        } else {
            durubality = (100 - ((itemType / 86400000 - durubality_frist)*20)).toFixed(2)
        }
        if (durubality < 0) {
            durubality = 0;
        } else if (durubality > 100) {
            durubality = 100;
        }
    }

    if (durubality == undefined) { 
        durubality = 100; 
    }
    
    if (durubality < 25) {
        QualityColor = "rgb(107, 216, 85)";
    } else if (durubality > 25 && durubality < 50) {
        QualityColor = "rgb(107, 216, 85)";
    } else if (durubality >= 50) {
        QualityColor = "rgb(107, 216, 85))";
    }

    if (durubality !== undefined) {
        qualityLabel = durubality;
    } else {
        qualityLabel = durubality;
    }

    return {durubality: durubality, qualityLabel: qualityLabel, QualityColor: QualityColor}
}

var requiredItemOpen = false;


Inventory = {};
Inventory.slots = 40;
Inventory.dropslots = 30;
Inventory.dropmaxweight = 100000

Inventory.Error = function() {
    $.post("https://qb-inventoryv2/PlayDropFail", JSON.stringify({}));
    Inventory.Close();
}

Inventory.IsWeaponBlocked = function(WeaponName) {
    var DurabilityBlockedWeapons = [ 
        "weapon_unarmed",
    ]

    var retval = false;
    $.each(DurabilityBlockedWeapons, function(i, name) {
        if (name == WeaponName) {
            retval = true;
        }
    });
    return retval;
}

Inventory.IsWeaponBlockedA = function(WeaponName) {
    var DurabilityBlockedWeapons = [ 
        "weapon_unarmed",
    ]

    var retval = false;
    $.each(DurabilityBlockedWeapons, function(i, name) {
        if (name == WeaponName) {
            retval = true;
        }
    });
    return retval;
}

Inventory.QualityCheck = function(item, IsHotbar, IsOtherInventory) {
    if (!Inventory.IsWeaponBlocked(item.name)) {
        if (item.info.durubality)  {
            var durubalityData = durubalityControl(item)
            var durubality = durubalityData.durubality
            var qualityLabel = durubalityData.qualityLabel 
            var QualityColor = durubalityData.QualityColor
            if (durubality == 0) {
                qualityLabel = "KIRIK";
                if (item.info.type == "yemek") {
                    qualityLabel = "BOZULMUŞ"
                }
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".item-slots-player").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": "100%",
                            "background-color": QualityColor
                        });
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": "100%",
                            "background-color": QualityColor
                        });
                    }
                } else {
                    $(".item-slots-other").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        "width": "100%",
                        "background-color": QualityColor
                    });
                }
            } else {
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".item-slots-player").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        });
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            "width": qualityLabel + "%",
                            "background-color": QualityColor
                        });
                    }
                } else {
                    $(".item-slots-other").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        "width": qualityLabel + "%",
                        "background-color": QualityColor
                    });
                }
            }
        }
    }
}

Inventory.SetWeight = function(type, weight, maxW) {
    let calPercent = (weight/maxW)*100
    if (calPercent < 6) calPercent = 6
    
    if (type == "player") {
        $("#player-weight").html((maxW / 1000).toFixed(1))
        $("#weight-bar-ic-player").html((weight / 1000).toFixed(1))
        $("#weight-bar-ic-player").css("width", calPercent+"%");
    } else {
        $("#other-weight").html((maxW / 1000).toFixed(1))
        $("#weight-bar-ic-other").html((weight / 1000).toFixed(1))
        $("#weight-bar-ic-other").css("width", calPercent+"%");
    }
}

// $(document).on('keyup', function() {
//     switch(event.keyCode) {
//         case 17: // ctrl
//             showClothe(false)
//             break;
//     }
// });
$(document).on('click', '#craft-btn', function(e){
    $.post("https://qb-inventoryv2/OpenCraft", JSON.stringify({}));
});


Inventory.Open = function(data) {
    totalWeight = 0;
    totalWeightOther = 0;
    inventoryOpen = true;
    $('.inv-clothes').css('display', 'none');
    $('.inv-option-bg').css('display', 'block');


    if (requiredItemOpen) { $(".requiredItem-container").hide();  requiredItemOpen = false; }

    $("#qbus-inventory").css("display", "flex");
    if(data.other != null && data.other != "") {
        $(".item-slots-other").attr("data-inventory", data.other.name);
        var name = data.other.name.toString()
        if (name != null && name.split("-")[0] == "otherplayer") {
            $(".clothe-items").attr("data-inventory", data.other.name);
            $("#clothes").html("KIYAFETLERİ")
            $(".clothe-label").html("Kıyafetleri")
        } else {
            $(".clothe-items").attr("data-inventory", "player");
            $("#clothes").html("KIYAFETLERİM")
            $(".clothe-label").html("Kıyafetlerim")
        }
    } else {
        $("#clothes").html("KIYAFETLERİM")
        $(".clothe-label").html("Kıyafetlerim")
        $(".clothe-items").attr("data-inventory", "player");
        $(".item-slots-other").attr("data-inventory", 0);
    }

    // First 5 Slots
      let slots = ""
    for(i = 1; i < 6; i++) {
        slots = slots + '<div class="item-slot" data-slot="' + 
        i +
         '"><div class="item-slot-key">' + 
        i +
         '</div><div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div></div>'
    }
    $(".item-slots-player").html(slots);

    // Inventory
    const clotheSlots = 12
    slots = ""
    for(i = 6; i < (playerInvSlot + 1); i++) {
        slots = slots + '<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div></div>'
    }
    $(".item-slots-player").append(slots);

    //Clothe Slot
    slots = ""
    for (let i = 1; i < clotheSlots+1; i++) {
        // $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="'+ ItemStyles[item.name] +'"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p><div class="item-ra1der-amount">'+item.amount+'x</div><div class="item-ra1der-weight"><i class="agirlik fas fa-weight-hanging"></i> &nbsp;'+ ((item.weight * item.amount) / 1000).toFixed(1) +'</div></p></div>' + ItemLabel);
        slots = slots + '<div class="item-slot clothe-item-slot" data-slot="' + (playerInvSlot + i) + '"><div class="item-slot-img"></div><div class="item-slot-label"></div></div>'
    }
    $(".clothe-items").html(slots);

    slots = ""
    if (data.other != null && data.other != "") {
        var name = data.other.name.toString()
        if (name != null && name.split("-")[0] == "otherplayer") {
            for(i = 1; i < (playerInvSlot + 1); i++) {
                slots = slots + '<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div></div>'
            }
            $(".item-slots-other").html(slots);
            slots = ""
            for (let i = 1; i < clotheSlots+1; i++) {
                slots = slots + '<div class="item-slot clothe-item-slot" data-slot="' + (playerInvSlot + i) + '"><div class="item-slot-img"></div><div class="item-slot-label"></div></div>'
            }
            $(".clothe-items").html(slots);
        } else { 
            for(i = 1; i < (data.other.slots + 1); i++) {
                slots = slots + '<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div></div>'
            }
            $(".item-slots-other").html(slots);
        }

    } else {
        for(i = 1; i < (Inventory.dropslots + 1); i++) {
            slots = slots + '<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div></div>'
        }
        $(".item-slots-other").html(slots);
    }

    if (data.inventory !== null) {
        $.each(data.inventory, function (i, item) {
            if (item != null) {
                totalWeight += item.weight * item.amount;
                var ItemLabel = '<div class="item-slot-label">' + item.label + '</div>';
                if (item.info.durubality) {
                    if (!Inventory.IsWeaponBlocked(item.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + item.label + '</div>';                       
                    }
                } else if (item.info.type && item.info.type == "card") {
                    ItemLabel = `<div class="item-slot-label">${item.info.name}</div>`
                }
                if (item.slot < 6) {
                    $(".item-slots-player").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".item-slots-player").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>' + item.slot + '</p></div><div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p><div class="item-ra1der-amount">'+item.amount+'x</div><div class="item-ra1der-weight"><i class="agirlik fas fa-weight-hanging"></i> &nbsp;'+ ((item.weight * item.amount) / 1000).toFixed(1) +'</div></p></div>' + ItemLabel);
                    $(".item-slots-player").find("[data-slot=" + item.slot + "]").data("item", item);
                } else if (item.slot > playerInvSlot) {
                    let otherInv = false
                    if (data.other != null && data.other != "") {
                        var name = data.other.name.toString()
                        if (name != null && name.split("-")[0] == "otherplayer") { otherInv = true }
                    }
                    if (!otherInv) {
                        $(".clothe-items").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".clothe-items").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png" /></div>');
                        $(".clothe-items").find("[data-slot=" + item.slot + "]").data("item", item);
                    }
                } else {
                    $(".item-slots-player").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    $(".item-slots-player").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p><div class="item-ra1der-amount">'+item.amount+'x</div><div class="item-ra1der-weight"><i class="agirlik fas fa-weight-hanging"></i> &nbsp;'+ ((item.weight * item.amount) / 1000).toFixed(1) +'</div></p></div>' + ItemLabel);
                    $(".item-slots-player").find("[data-slot=" + item.slot + "]").data("item", item);
                }
                if (ItemStyles[item.name]) {
                    $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass(ItemStyles[item.name])
                }
                Inventory.QualityCheck(item, false, false);
            }
        });
    }

    if ((data.other != null && data.other != "") && data.other.inventory != null) {
        var name = data.other.name.toString()

        if (name != null && name.split("-")[0] == "otherplayer") {
            $.each(data.other.inventory, function (i, item) {
                if (item != null) {
                    totalWeightOther += item.weight * item.amount;
                    var ItemLabel = '<div class="item-slot-label">' + item.label + '</div>';
                    if (item.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + item.label + '</div>';                       
                        }
                    } else if (item.info.type && item.info.type == "card") {
                        ItemLabel = `<div class="item-slot-label">${item.info.name}</div>`
                    }
                    if (item.slot > playerInvSlot ) {
                        $(".clothe-items").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".clothe-items").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png" /></div><div class="item-slot-amount">' + ra1derduzenleme(item.amount, item.weight) + '</div>' + ItemLabel);
                        $(".clothe-items").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else {
                        $(".item-slots-other").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".item-slots-other").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png" /></div><div class="item-slot-amount">' + ra1derduzenleme(item.amount, item.weight) + '</div>' + ItemLabel);
                        $(".item-slots-other").find("[data-slot=" + item.slot + "]").data("item", item);
                    }
                    if (ItemStyles[item.name]) {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").addClass(ItemStyles[item.name])
                    }
                    Inventory.QualityCheck(item, false, true);
                }
            });

        } else {
            $.each(data.other.inventory, function (i, item) {
                if (item != null) {
                    totalWeightOther += (item.weight * item.amount);
                    var ItemLabel = '<div class="item-slot-label">' + item.label + '</div>';
                    if (item.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + item.label + '</div>';                       
                        }
                    } else if (item.info.type && item.info.type == "card") {
                        ItemLabel = `<div class="item-slot-label">${item.info.name}</div>`
                    }
                    $(".item-slots-other").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    if (item.price != null) {
                        $(".item-slots-other").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png" /></div><div class="item-slot-amount">'+ item.amount +'</div><div class="item-slot-price">'+item.price+'$</div>' + ItemLabel);
                    } else {
                        $(".item-slots-other").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png" /></div><div class="item-slot-amount">' + ra1derduzenleme(item.amount, item.weight) + '</div>' + ItemLabel);
                    }
                    $(".item-slots-other").find("[data-slot=" + item.slot + "]").data("item", item);
                    if (ItemStyles[item.name]) {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").addClass(ItemStyles[item.name])
                    }
                    Inventory.QualityCheck(item, false, true);
                }
            });
        }
    }

    Inventory.SetWeight("player", totalWeight, data.maxweight)

    $("#player-inv-weight").html((totalWeight / 1000).toFixed(1) + "/" +(data.maxweight / 1000).toFixed(1));
    var per =(totalWeight/1000)/(data.maxweight/100000)
    $(".player-weight").css("width",per+"%");

    playerMaxWeight = data.maxweight;
    if (data.other != null) 
    {
        var name = data.other.name.toString()
        if (name != null && (name.split("-")[0] == "itemshop" || name == "crafting")) {
            $("#other-inv-label").html(data.other.label);
        } else {
            $("#other-inv-label").html(data.other.label)
            $("#other-inv-weight").html((totalWeightOther / 1000).toFixed(1) +"/" +(data.other.maxweight / 1000).toFixed(1));
            Inventory.SetWeight("other", totalWeightOther, data.other.maxweight)
        }
        otherMaxWeight = data.other.maxweight;
        otherLabel = data.other.label;
        var per1 =(totalWeightOther/1000)/(otherMaxWeight/100000)
        $(".other-weight").css("width",per1+"%");
    } else {
        $("#other-inv-label").html('Yer')
        $("#other-inv-weight").html((totalWeightOther / 1000).toFixed(1) +"/" +(Inventory.dropmaxweight / 1000).toFixed(1));
        Inventory.SetWeight("other", totalWeightOther, Inventory.dropmaxweight)

        otherMaxWeight = Inventory.dropmaxweight;
        otherLabel = 'Yer';
        var per1 =(totalWeightOther/1000)/(otherMaxWeight/100000)
        $(".other-weight").css("width",per1+"%");
    }

    handleDragDrop();
};

$(document).on("click", "#inv-close", function(e) {
    e.preventDefault();
    Inventory.Close();
});

Inventory.Close = function() {
    $(document).trigger("mouseup")
    inventoryOpen = false;
    $(".ply-iteminfo-container").css("opacity", "0.0");
    $("#qbus-inventory").fadeOut(300);
    $(".help-menu").fadeOut(300);
    $(".settings-menu").fadeOut(300);
    $(".GiveItembox").fadeOut(300)

    $.post("https://qb-inventoryv2/CloseInventory", JSON.stringify({label: otherLabel}));

    if (AttachmentScreenActive) {
        $(".weapon-attachments-container").css({"display": "none"});
        AttachmentScreenActive = false;
    }

    if (ClickedItemData !== null) {
        $("#weapon-attachments").fadeOut(250, function(){
            $("#weapon-attachments").remove();
            ClickedItemData = {};
        });
    }
};

Inventory.Update = function(data) {
    totalWeight = 0;
    totalWeightOther = 0;
    $(".item-slots-player").find(".item-slot").remove();
    if (data.error) { Inventory.Error(); }
    let slots = ""
    for(i = 1; i < (data.slots + 1); i++) {
        slots = slots + '<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label">&nbsp;</div></div>'
    }
    $(".item-slots-player").html(slots)

    $.each(data.inventory, function (i, item) {
        if (item != null) {
            totalWeight += (item.weight * item.amount);
            var ItemLabel = '<div class="item-slot-label">' + item.label + '</div>';
            if (item.info && item.info.durubality) {//** */
                if (!Inventory.IsWeaponBlocked(item.name)) {
                    ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + item.label + '</div>';                       
                }
            }
            if (item.slot < 6) {
                $(".item-slots-player").find("[data-slot=" + item.slot + "]").addClass("item-drag"); 
                $(".item-slots-player").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.image + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p><div class="item-ra1der-amount">'+item.amount+'x</div><div class="item-ra1der-weight"><i class="agirlik fas fa-weight-hanging"></i> &nbsp;'+ ((item.weight * item.amount) / 1000).toFixed(1) +'</div></p></div>' + ItemLabel);
                $(".item-slots-player").find("[data-slot=" + item.slot + "]").data("item", item);
            } else {
                $(".item-slots-player").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                $(".item-slots-player").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png" /></div><div class="item-slot-amount">' + ra1derduzenleme(item.amount, item.weight) + '</div>' + ItemLabel);
                $(".item-slots-player").find("[data-slot=" + item.slot + "]").data("item", item);
            }
        }
    });

    Inventory.SetWeight("player", totalWeight, data.maxweight)

    $("#player-inv-weight").html((totalWeight / 1000).toFixed(1) + "/" + (data.maxweight / 1000).toFixed(1));
    var per =(totalWeight/1000)/(data.maxweight/100000)
    $(".player-weight").css("width",per+"%");
    handleDragDrop();
};

Inventory.ToggleHotbar = function(data) {
    if (data.open) {
        if (inventoryOpen == false) {
            let slots = ""
            for(i = 1; i < 6; i++) {
                slots = slots + '<div class="item-slot" data-zhotbarslot="' + i + '"><div class="item-slot-key">' + i + '</div><div class="item-slot-img31"></div><div class="item-slot-label">&nbsp;</div></div>'
            }
                $(".z-hotbar-inventory").html(slots);
            $.each(data.items, function(i, item){
                if (item != null) {
                    var ItemLabel = '<div class="item-slot-label">' + item.label + '</div>';
                    if (item.info.durubality) {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"></div></div><div class="item-slot-label">' + item.label + '</div>';                       
                        }
                    }
                    $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div id="deneme" class="'+ ItemStyles[item.name] +'"></div><img  id="deneme2" src="images/' + item.image + '" alt="' + item.name + '" /><div class="item-slot-amount"><p><div class="item-ra1der-amount">'+item.amount+'</div><div class="item-ra1der-weight"><i class="agirlik fas fa-weight-hanging"></i> &nbsp;'+ ((item.weight * item.amount) / 1000).toFixed(1) +'</div></p></div>' + ItemLabel);
                    Inventory.QualityCheck(item, true, false);
                }
            });

            $(".z-hotbar-inventory").animate({opacity: "1.0",}, 200);
        }
    } else {
        $(".z-hotbar-inventory").animate({opacity: "0.0",}, 200);
    }
}


Inventory.UseItem = function(data) {
    $(".itembox-container").hide();
    $(".itembox-container").fadeIn(250);
    $("#itembox-action").html("<p>Kullanıldı</p>");
    $("#itembox-label").html("<p>"+data.item.label+"</p>");
    $("#itembox-image").html('<div class="item-slot-img"><img src="images/' + data.item.name + '.png" alt="' + data.item.name + '" /></div>')

    setTimeout(function(){
        $(".itembox-container").fadeOut(250);
    }, 2000)
};

var itemBoxtimer = null;
var requiredTimeout = null;

    Inventory.itemBox = function(data) {
        if (itemBoxtimer !== null) {
            clearTimeout(itemBoxtimer)
        }
        var type = "Kullanıldı 1x"
        if (data.type == "add") {
            type = "Eklendi 1x";
        } else if (data.type == "remove") { 
            type = "Silindi 1x";
        } else if (data.type == "holster") { 
            type = "Cepte";
        } else if (data.type == "unholster") { 
            type = "Elde";
        }


    var $itembox = $(".itembox-container.template").clone();
    $itembox.removeClass('template');
    $itembox.html('<div id="itembox-action"><p>' + type + '</p></div><div id="itembox-label"><p>'+data.item.label+'</p></div><div class="item-slot-img31"><img src="images/' + data.item.name + '.png" alt="' + data.item.name + '" /></div>');
    $(".itemboxes-container").prepend($itembox);
    $itembox.fadeIn(250);
    setTimeout(function() {
        $.when($itembox.fadeOut(300)).done(function() {
            $itembox.remove()
        });
    }, 3000);
};

Inventory.RequiredItem = function(data) {
    if (requiredTimeout !== null) {
        clearTimeout(requiredTimeout)
    }
    if (data.toggle) {
        if (!requiredItemOpen) {
            $(".requiredItem-container").html("");
            $.each(data.items, function(index, item){
                var element = '<div class="requiredItem-box"><div id="requiredItem-action">[E] Kullan (Lazım)</div><div id="requiredItem-image"><div class="item-slot-img"><img src="images/' + item.image + '" /></div></div></div>'
                $(".requiredItem-container").hide();
                $(".requiredItem-container").append(element);
                $(".requiredItem-container").fadeIn(100);
            });
            requiredItemOpen = true;
        }
    } else {
        $(".requiredItem-container").fadeOut(100);
        requiredTimeout = setTimeout(function(){
            $(".requiredItem-container").html("");
            requiredItemOpen = false;
        }, 100)
    }
};

function setItemSlot(inv, slot, data, min6Slot, itemLabel) {
    if (min6Slot) {
        let label = `<div class="item-slot-amount">` + ra1derduzenleme(data.amount, data.weight) + `)</div><div class="item-slot-label">` + data.label + `</div>`
        if (itemLabel) {label = itemLabel}
        inv.find("[data-slot=" + slot + "]").html(`
            <div class="item-slot-key">` + slot + `</div>
            <div class="item-slot-img"><img src="images/` + data.name + `.png"/></div>
            `+label+`
        `);
    } else {
        let label = `<div class="item-slot-label">` + data.label + `</div>`
        if (itemLabel) {label = itemLabel}
        inv.find("[data-slot=" + slot + "]").html(`
            <div class="item-slot-img"><img src="images/` + data.name + `.png"/></div>
            <div class="item-slot-amount">` + ra1derduzenleme(data.amount, data.weight) + `</div>
            `+label+`
        `);
    }
}

function setShopItemSlot(inv, slot, data) {
    inv.find("[data-slot=" + slot + "]").html(`
        <div class="item-slot-img">
        <img src="images/` + data.name + `.png"/></div>
        <div class="item-slot-amount">(`+data.amount+`)</div><div class="item-slot-price" >`+data.price+`$</div>
        <div class="item-slot-label">` + data.label + `</div>
    `);
}
// function setShopItemSlot(inv, slot, data) {
//     inv.find("[data-slot=" + slot + "]").html(`
//         <div class="item-slot-img">
//         <img src="images/` + data.name + `.png"/></div>
//         <div class="item-slot-amount">(`+data.amount+`)</div><div class="item-slot-price" style="color: green;">$`+data.price+`</div>
//         <div class="item-slot-label">` + data.label + `</div>
//     `);
// }



$("#item-give").droppable({hoverClass: "button-hover",
    drop: function(event, ui) {
        setTimeout(function() { IsDragging = false; }, 300);
        fromData = ui.draggable.data("item");
        fromInventory = ui.draggable.parent().attr("data-inventory");
        amount = $("#item-amount").val();
        if (amount == 0) {
            return;
        } else {
            amount = fromData.amount;
            $.post(`https://${GetParentResourceName()}/GiveItem0`, JSON.stringify({ inventory: fromInventory, item: fromData, amount: parseInt(amount)
            }), function(state) { $('.GiveItemPlayers').html("")
                state.Players.map(dt => $(".GiveItemPlayers").append('<div class="GiveItemPlayersButton" data-player="' + dt.id + '">' + dt.props + ' (' + dt.id + ')</div>'))
                $(".GiveItembox").css({'display': 'block'});
                $(".GiveItemPlayersButton").click(function () { $(".GiveItembox").css({'display': 'none'});
                    player = $(this).data("player");
                    new Promise(function () {
                        const https = new XMLHttpRequest();
                        https.open("POST", `https://${GetParentResourceName()}/GiveItem1`);
                        https.send(JSON.stringify({
                            player: player,
                            item: state.Item,
                            amount: parseInt($("#item-amount").val())
                        }));
                    });
                });
            });
        }
    },
});
function setClothesItemSlot(inv, slot, data) {
    inv.find("[data-slot=" + slot + "]").html(`
        <div class="item-slot-img">
        <img src="images/` + data.name + `.png"/></div>
        <div class="item-slot-amount">(`+data.amount+`) $`+data.price+`</div>
        <div class="item-slot-label">` + data.label + `</div>
    `);
}