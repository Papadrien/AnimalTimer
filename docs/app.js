// AnimalTimer — Privacy Policy Dynamic Renderer
// Source unique : fichiers ARB du repo sur la branche master
// Aucune duplication de contenu

(function () {
  'use strict';

  // Configuration
  var RAW_BASE = 'https://raw.githubusercontent.com/Papadrien/AnimalTimer/master/lib/l10n/';
  var SUPPORTED_LANGS = ['fr', 'en'];
  var DEFAULT_LANG = 'en';

  // Ordre fixe des sections (titre / contenu)
  var SECTIONS = [
    { title: 'policyIntro',      content: 'policyIntroContent' },
    { title: 'policyData',       content: 'policyDataContent' },
    { title: 'policyAds',        content: 'policyAdsContent' },
    { title: 'policyIAP',        content: 'policyIAPContent' },
    { title: 'policyCOPPA',      content: 'policyCOPPAContent' },
    { title: 'policyThirdParty', content: 'policyThirdPartyContent' },
    { title: 'policyGDPR',       content: 'policyGDPRContent' },
    { title: 'policyContact',    content: 'policyContactContent' }
  ];

  // Labels statiques (titre page + messages)
  var LABELS = {
    fr: {
      docTitle: 'AnimalTimer — Politique de confidentialité',
      loading: 'Chargement de la politique de confidentialité…',
      errorLoad: 'Impossible de charger la politique de confidentialité. Réessayez plus tard.',
      htmlLang: 'fr',
      sourceNote: 'Ce document est généré automatiquement à partir des fichiers de traduction officiels de l\'application.'
    },
    en: {
      docTitle: 'AnimalTimer — Privacy Policy',
      loading: 'Loading privacy policy…',
      errorLoad: 'Unable to load the privacy policy. Please try again later.',
      htmlLang: 'en',
      sourceNote: 'This document is automatically generated from the application\'s official translation files.'
    }
  };

  // Elements
  var statusEl = document.getElementById('status');
  var policyEl = document.getElementById('policy');
  var updateLine = document.getElementById('update-line');
  var sourceNote = document.getElementById('source-note');
  var langButtons = document.querySelectorAll('.lang-btn');

  // Cache for fetched ARBs
  var arbCache = {};

  // --- Helpers ---

  function detectLang() {
    var saved = null;
    try { saved = localStorage.getItem('animaltimer_lang'); } catch (e) {}
    if (saved && SUPPORTED_LANGS.indexOf(saved) !== -1) return saved;

    var nav = (navigator.language || navigator.userLanguage || DEFAULT_LANG).toLowerCase();
    for (var i = 0; i < SUPPORTED_LANGS.length; i++) {
      if (nav.indexOf(SUPPORTED_LANGS[i]) === 0) return SUPPORTED_LANGS[i];
    }
    return DEFAULT_LANG;
  }

  function saveLang(lang) {
    try { localStorage.setItem('animaltimer_lang', lang); } catch (e) {}
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  // Rend un paragraphe : echappe le HTML, transforme emails et URLs en liens
  function renderParagraph(text) {
    var safe = escapeHtml(text);
    // URLs http(s)
    safe = safe.replace(/(https?:\/\/[^\s]+)/g, function (m) {
      return '<a href="' + m + '" target="_blank" rel="noopener noreferrer">' + m + '</a>';
    });
    // Emails
    safe = safe.replace(/([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/g, function (m) {
      return '<a href="mailto:' + m + '">' + m + '</a>';
    });
    return safe;
  }

  function showStatus(message, isError) {
    statusEl.hidden = false;
    statusEl.textContent = message;
    statusEl.classList.toggle('error', !!isError);
    policyEl.hidden = true;
  }

  function hideStatus() {
    statusEl.hidden = true;
  }

  // --- Fetching ARB ---

  function fetchArb(lang) {
    if (arbCache[lang]) {
      return Promise.resolve(arbCache[lang]);
    }
    var url = RAW_BASE + 'app_' + lang + '.arb';
    return fetch(url, { cache: 'no-cache' })
      .then(function (res) {
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.json();
      })
      .then(function (data) {
        arbCache[lang] = data;
        return data;
      });
  }

  // --- Rendering ---

  function renderPolicy(lang, data) {
    // Titre document + attribut lang
    var labels = LABELS[lang];
    document.title = labels.docTitle;
    document.documentElement.lang = labels.htmlLang;
    sourceNote.textContent = labels.sourceNote;

    // Sections
    var html = '';
    for (var i = 0; i < SECTIONS.length; i++) {
      var s = SECTIONS[i];
      var titleKey = s.title;
      var contentKey = s.content;
      var title = data[titleKey];
      var content = data[contentKey];
      if (!title || !content) continue;

      html += '<section>';
      html += '<h2>' + escapeHtml(title) + '</h2>';
      html += '<p>' + renderParagraph(content) + '</p>';
      html += '</section>';
    }
    policyEl.innerHTML = html;

    // Ligne "mise a jour" en footer
    var updTitle = data['policyUpdate'] || '';
    var updContent = data['policyUpdateContent'] || '';
    updateLine.textContent = updTitle && updContent
      ? (updTitle + ' — ' + updContent)
      : (updContent || '');

    hideStatus();
    policyEl.hidden = false;
  }

  function setActiveLang(lang) {
    for (var i = 0; i < langButtons.length; i++) {
      var b = langButtons[i];
      var active = b.getAttribute('data-lang') === lang;
      b.classList.toggle('active', active);
      b.setAttribute('aria-pressed', active ? 'true' : 'false');
    }
  }

  function loadLang(lang) {
    if (SUPPORTED_LANGS.indexOf(lang) === -1) lang = DEFAULT_LANG;
    setActiveLang(lang);
    showStatus(LABELS[lang].loading, false);
    fetchArb(lang)
      .then(function (data) { renderPolicy(lang, data); })
      .catch(function (err) {
        console.error('Failed to load ARB for', lang, err);
        showStatus(LABELS[lang].errorLoad, true);
      });
  }

  // --- Events ---

  for (var i = 0; i < langButtons.length; i++) {
    langButtons[i].addEventListener('click', function (evt) {
      var lang = evt.currentTarget.getAttribute('data-lang');
      saveLang(lang);
      loadLang(lang);
    });
  }

  // --- Init ---

  loadLang(detectLang());
})();
