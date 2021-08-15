function togglePassword() {
    var input = $("#password")
    var eye = $("#eye")
    
    if (input.attr("type") === "password") {
        input.attr("type", "text")
        eye.removeClass("slash")
    } else {
        input.attr("type", "password")
        eye.addClass("slash")
    }
}


$(document).ready(function () {
    /*$('.cookie.nag').nag('show')*/

    $('#rules-link').on('click', function () {
        $('#rules-modal').modal('show')
    })

    $('#flash i.close.icon').on('click', function () {
        $('#flash').remove()
    })
    setTimeout(function () {
        $('#flash').fadeOut(function () {
            $(this).remove()
        })
    }, 10000)
    
    $("#tabs .item").tab({
    })
    
    $('#search-games').search({
	type: 'category',
	minCharacters : 1,
	apiSettings: {
	    url: '/search/games/{query}',
	    cache: true
	}
    })
    
    $('#menu-dropdown').dropdown({
	on: 'hover'
    })
    
    $('.account-dropdown').dropdown({
	on: 'hover'
    })

})
