(() => {
    const init = () => {
        if (document.getElementById("navbars-toggle") === null) {
            const body = document.querySelector("body");
            const newElement = document.createElement("input");
            newElement.type = "checkbox";
            newElement.id = "navbars-toggle";
            body.prepend(newElement);

            document.querySelectorAll(".toc-list a").forEach(link => {
                link.addEventListener('click', () => {
                    document.getElementById('navbars-toggle').checked = false;
                });
            });
        }
    };
    if (document.readyState !== 'loading') {
        init();
    } else {
        document.addEventListener('DOMContentLoaded', init);
    }
})();
