window.addEventListener('message', function(event) {
    let data = event.data
    if (event.data.type == 'showui') {
        document.getElementById("coords-menu-one").style.display = "block"
    }
    if (event.data.type == 'hideui') {
        document.getElementById("coords-menu-one").style.display = "none"
    }
    if (event.data.type == 'showNotification') {
        const notificationContainer = document.getElementById('notificationContainer');
        notificationContainer.textContent = event.data.message;
        $("#notificationContainer").fadeIn()
        $("#notificationContainer").fadeOut()
    }
    if (event.data.type == 'copy') {
        const el = document.createElement('textarea');
        el.value = event.data.content;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    }
})

$(document).ready(function () {
    document.getElementById("close").addEventListener("click", () => {
        $.post("https://epyi_coords/exit", JSON.stringify({}));  
    });

    document.getElementById("c-vec3").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "c-vec3"
        }));
    });
    document.getElementById("c-table").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "c-table"
        }));
    });
    document.getElementById("c-tablei").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "c-tablei"
        }));
    });
    document.getElementById("c-X").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "c-X"
        }));
    });
    document.getElementById("c-Y").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "c-Y"
        }));
    });
    document.getElementById("c-Z").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "c-Z"
        }));
    });
    document.getElementById("h-W").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "h-W"
        }));
    });
    document.getElementById("ch-vec4").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "ch-vec4"
        }));
    });
    document.getElementById("ch-table").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "ch-table"
        }));
    });
    document.getElementById("ch-tablei").addEventListener("click", () => {
        $.post("https://epyi_coords/request-copy", JSON.stringify({
            type: "ch-tablei"
        }));
    });
})