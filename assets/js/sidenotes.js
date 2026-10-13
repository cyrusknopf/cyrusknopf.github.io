// turns all [^X] footnotes to be sidenotes
(function () {
  function init() {
    const article = document.querySelector('.post article');
    if (!article) return;

    const refs = article.querySelectorAll('sup[id^="fnref"]');
    refs.forEach((sup, i) => {
      const link = sup.querySelector('a[href^="#fn"]');
      if (!link) return;
      const note = document.getElementById(link.getAttribute('href').slice(1));
      if (!note) return;

      note.querySelectorAll('a[role="doc-backlink"], a.reversefootnote')
          .forEach(a => a.remove());

      const span = document.createElement('span');
      span.className = 'sidenote';
      note.querySelectorAll(':scope > p').forEach((p, j) => {
        if (j > 0) span.appendChild(document.createElement('br'));
        while (p.firstChild) span.appendChild(p.firstChild);
      });

      const id = 'fn-sn-' + i;
      const label = document.createElement('label');
      label.htmlFor = id;
      label.className = 'sidenote-toggle sidenote-number';
      const input = document.createElement('input');
      input.type = 'checkbox';
      input.id = id;
      input.className = 'sidenote-toggle';

      sup.replaceWith(label, input, span);
    });

    const list = article.querySelector('.footnotes');
    if (list) list.remove();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
