var config = {
    startOnLoad:true,
    theme: 'dark',
    flowchart:{
            useMaxWidth:true,
            htmlLabels:true
        }
};

function getMermaidBlockContainer(preBlock) {
    var parent = preBlock.parentElement;
    if (!parent) {
        return null;
    }

    if (parent.classList.contains('mermaid-block')) {
        return parent;
    }

    var wrapper = document.createElement('div');
    wrapper.className = 'mermaid-block';
    parent.insertBefore(wrapper, preBlock);
    wrapper.appendChild(preBlock);
    return wrapper;
}

function createMermaidSourceToggle(codeBlock) {
    var source = codeBlock.textContent;
    if (!source || !source.trim()) {
        return;
    }

    var preBlock = codeBlock.parentElement;
    if (!preBlock || preBlock.dataset.mermaidSourceAttached === 'true') {
        return;
    }

    var blockContainer = getMermaidBlockContainer(preBlock);
    if (!blockContainer) {
        return;
    }

    var toggle = document.createElement('a');
    toggle.href = '#';
    toggle.textContent = 'Show source';
    toggle.className = 'mermaid-source-toggle';

    var sourceBlock = document.createElement('pre');
    sourceBlock.className = 'mermaid-source';
    sourceBlock.hidden = true;

    var sourceCode = document.createElement('code');
    sourceCode.textContent = source;
    sourceCode.className = 'language-mermaid';
    sourceBlock.appendChild(sourceCode);

    toggle.addEventListener('click', (event) => {
        event.preventDefault();
        sourceBlock.hidden = !sourceBlock.hidden;
        toggle.textContent = sourceBlock.hidden ? 'Show source' : 'Hide source';
    });

    blockContainer.appendChild(toggle);
    toggle.insertAdjacentElement('afterend', sourceBlock);
    preBlock.dataset.mermaidSourceAttached = 'true';
}

var mermaidBlocks = document.querySelectorAll('.language-mermaid');
mermaidBlocks.forEach(createMermaidSourceToggle);

mermaid.initialize(config);
window.mermaid.init(undefined, mermaidBlocks);
