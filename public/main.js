function select(fontname) {
    // Update active class
    var el = $(`.sidenav a:contains('${fontname}')`)
    $('.sidenav a').removeClass('active');
    $(el).addClass('active');

    // Ensure visible
    $(el).get(0).scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' })

    // Update font description
    $('#font_name').html(fontname)
    $('#font_version').html(font_data[fontname])

    // Update sample URLs
    var rx = /^(samples\/([A-Za-z0-9_ ]*\/){4})[A-Za-z0-9_ ]*\//
    $("img[src*='samples/']").each(function() {
        var newsrc = $(this).attr('src').replace(rx, `$1${fontname}/`)
        $(this).attr('src', newsrc)
    })
}

function currentFontName() {
    return decodeURIComponent(window.location.hash).substring(1)
}

$(document).ready(function(){
    // Initially selected font
    select(currentFontName() || "JuliaMono")

    window.onhashchange = function() {
        var fontname = decodeURIComponent(window.location.hash).substring(1)
        select(fontname)
    }
});
