document.addEventListener("DOMContentLoaded", function (event) {
    previousPageValue = document.getElementsByName("page")[0].value
    if (previousPageValue < 0) {
        previousButton = document.getElementById("previous-button");
        previousButton.disabled = true;
    }
});