document.addEventListener("DOMContentLoaded", function() {
    function checkScreenSize() {
        if (window.innerWidth < 1024) {  // Adjust threshold as needed (1024px is common for tablets)
            document.getElementById("app-content").style.display = "none";
            document.getElementById("mobile-warning").style.display = "block";
        } else {
            document.getElementById("app-content").style.display = "block";
            document.getElementById("mobile-warning").style.display = "none";
        }
    }

    checkScreenSize();
    window.addEventListener("resize", checkScreenSize);
});

// Citation copy functionality
function copyToClipboard(elementId, button) {
    var element = document.getElementById(elementId);
    var text = element.innerText || element.textContent;
    
    // Clean up the text for BibTeX format
    if (elementId === 'bibtex_citation') {
        text = `@article{ptce2025,
    title={Pediatric Thyroid Cancer Explorer: An interactive web resource for genomic and transcriptomic analysis},
    author={Author names to be updated},
    journal={Journal Name},
    year={2025},
    doi={TO BE UPDATED},
    url={https://github.com/uab-cgds-worthey/ptc-explorer}
}`;
    }
    
    // Try modern clipboard API first
    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(function() {
            showCopyNotification(button, "Citation copied!");
        }).catch(function(err) {
            console.error('Failed to copy text: ', err);
            fallbackCopy(text, button);
        });
    } else {
        // Fallback for older browsers or non-secure contexts
        fallbackCopy(text, button);
    }
}

function fallbackCopy(text, button) {
    var textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.position = "fixed";
    textArea.style.left = "-999999px";
    textArea.style.top = "-999999px";
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
        document.execCommand('copy');
        showCopyNotification(button, "Citation copied!");
    } catch (err) {
        console.error('Fallback: Could not copy text: ', err);
        showCopyNotification(button, "Copy failed - please select manually");
    }
    
    document.body.removeChild(textArea);
}

function showCopyNotification(button, message) {
    var originalText = button.innerText;
    var originalBg = button.style.backgroundColor;
    var originalBorder = button.style.borderColor;
    var originalColor = button.style.color;
    
    button.innerText = message;
    button.style.backgroundColor = '#28a745';
    button.style.borderColor = '#28a745';
    button.style.color = 'white';
    
    setTimeout(function() {
        button.innerText = originalText;
        button.style.backgroundColor = originalBg;
        button.style.borderColor = originalBorder;
        button.style.color = originalColor;
    }, 2000);
}
