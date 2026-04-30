var config = {
    startOnLoad:true,
    theme: 'dark',
    flowchart:{
            useMaxWidth:true,
            htmlLabels:true
        }
};

function createMermaidSourceToggle(codeBlock) {
    var source = codeBlock.textContent;
    if (!source || !source.trim()) {
        return;
    }

    var preBlock = codeBlock.parentElement;
    if (!preBlock || preBlock.dataset.mermaidSourceAttached === 'true') {
        return;
    }

    var toggle = document.createElement('a');
    toggle.href = '#';
    toggle.textContent = 'Show source';
    toggle.style.display = 'inline-block';
    toggle.style.marginTop = '0.75rem';

    var sourceBlock = document.createElement('pre');
    sourceBlock.hidden = true;
    sourceBlock.style.marginTop = '0.75rem';

    var sourceCode = document.createElement('code');
    sourceCode.textContent = source;
    sourceCode.className = 'language-mermaid';
    sourceBlock.appendChild(sourceCode);

    toggle.addEventListener('click', (event) => {
        event.preventDefault();
        sourceBlock.hidden = !sourceBlock.hidden;
        toggle.textContent = sourceBlock.hidden ? 'Show source' : 'Hide source';
    });

    preBlock.insertAdjacentElement('afterend', toggle);
    toggle.insertAdjacentElement('afterend', sourceBlock);
    preBlock.dataset.mermaidSourceAttached = 'true';
}

var mermaidBlocks = document.querySelectorAll('.language-mermaid');
mermaidBlocks.forEach(createMermaidSourceToggle);

mermaid.initialize(config);
window.mermaid.init(undefined, mermaidBlocks);
