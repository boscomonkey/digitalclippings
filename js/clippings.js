// http://stackoverflow.com/a/5379408/5887609
//
function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
}

// http://stackoverflow.com/a/901144/5887609
//
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

// populate an input with the query param of the same name
//
function setElementWithQuery(id, useHtmlEntity) {
    var elt = $("#" + id);
    var param = getParameterByName(id);

    if (useHtmlEntity) {
        param = he.encode(param, {
            'useNamedReferences': true
        });
    }
    elt.val(param);
}

// select the option given its value
//
function selectOption(elementId, matchValue) {
    // cycle through newspaper options and found a match with the text
    var selection = $(elementId)[0];
    console.log("selection:", selection);
    console.log("selection.options:", selection.options);
    console.log("selection.options.length:", selection.options.length);
    for (var idx = 0; idx < selection.options.length ; idx++) {
        if (selection.options[idx].text == matchValue) {
            console.log("Found", elementId, "option:", matchValue, "index:", idx);

            selection.options[idx].selected = true;

            break;
        }
    }
}

$(function() {

    setElementWithQuery("url");
    setElementWithQuery("title", true);
    setElementWithQuery("description", true);

    // get current date
    var dated = $("#dated");
    dated.val(moment().format("YYYY-MM-DD"));

    // try to set newspaper and county by looking up host in url
    var host = getParameterByName("host");
    console.log("host:", host);
    $.get(
        document.location.origin + "/papers.json",
        function(table) {
            // lookup table maps hosts to url, newspaper, and county_id
            var found = table[host];
            if (found) {
                console.log("url:", found.url);
                console.log("newspaper:", found.newspaper);
                console.log("county_id:", found.county_id);

                // cycle through newspaper options and select if matches
                selectOption("#newspaper", found.newspaper);

                // cycle through county IDs
                selectOption("#county_id", found.county_id);
            }
        }
    );
});
