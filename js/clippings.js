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
function setElementWithQuery(id) {
    var elt = $("#" + id);
    var param = getParameterByName(id);
    elt.val(param);
}

$(function() {

    console.log("Hi, Hils!");

    setElementWithQuery("url")
    setElementWithQuery("title")
    setElementWithQuery("description")

    // get current date
    var dated = $("#dated");
    dated.val(moment().format("YYYY-MM-DD"));
});
