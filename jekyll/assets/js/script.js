(() => {
    document.querySelectorAll("main pre").forEach(element => {
        const contents = element.textContent;
        element.insertAdjacentHTML('afterbegin', '<button class="copy"><span>Copy</span></button>');
        const button = element.querySelector("button");
        const buttonCopySpan = button.querySelector("span");
        button.onclick = async () => {
            await navigator.clipboard.writeText(contents);
            buttonCopySpan.innerHTML = "Copied!";
            setTimeout(function() {
                setTimeout(function() {
                    buttonCopySpan.innerHTML = "Copy";
                }, 100);
            }, 1900);
        }
    });


    const correctLinkTargets = (currentUrl) => {
        document.querySelectorAll('a').forEach(link => {
            link.classList.remove('to-current-target');
            if (link.href === currentUrl) {
                link.classList.add('to-current-target');
            }
        });
    };

    correctLinkTargets(window.location.href);
    document.querySelectorAll('a').forEach(link => {
        link.onclick = () => {
            correctLinkTargets(link.href);
            document.getElementById('navbars-toggle').checked = false;
        };
    });
})();
