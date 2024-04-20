<script>
  import "../index.css";
  import { backend } from '$lib/canisters';

  let message = '';
  let shift = 0;
  let foreignChar = { Exclude: null };
  let sensitivity = { Ignore: null };
  let output = '';

  function updateVariantSelection(event, variantType) {
    if (variantType === 'foreignChar') {
      foreignChar = { [event.target.value]: null };
    } else if (variantType === 'sensitivity') {
      sensitivity = { [event.target.value]: null };
    }
  }

  async function encodeMessage() {
    try {
      const result = await backend.encode({
        message,
        shift,
        foreignChar,
        sensitivity
      });
      output = 'Encoded message :' + result;
    } catch (error) {
      console.error('Error encoding message:', error);
      output = 'Failed to encode message.';
    }
  }

  async function decodeMessage() {
    try {
      const result = await backend.decode({
        message,
        shift,
        foreignChar,
        sensitivity
      });
      output = 'Decoded message: ' + result;
    } catch (error) {
      console.error('Error decoding message:', error);
      output = 'Failed to decode message.';
    }
  }
</script>
<div class="app">
  <header class="app__header header">
    <div class="header__inner">
      <div class="header__item">
        <a class="header__brand" href="/">
          <!-- svelte-ignore a11y-missing-attribute -->
          <img width="125" height="200"  aria-labelledby="app_logo" src="logo.svg">
        </a>
      </div>
      

    </div>
  </header>

  <article class="app__pipe pipe">
    <header class="pipe__header">
      <div class="container">
        <h1 class="pipe__title">Caesar cipher: Encode and decode online</h1>
        <p class="pipe__description">Method in which each letter in the plaintext is replaced by a letter some fixed number of positions down the alphabet. The method is named after Julius Caesar, who used it in his private correspondence.</p>
        <div class="badge">
            <a class="badge__link" href="https://ciphereditor.com/explore/caesar-cipher?utm_campaign=badge_open_in_ciphereditor&amp;utm_source=cryptii&amp;utm_medium=referral" target="_blank" rel="noopener">
              <img class="badge__image" alt="internet computer" width="196" height="56" src="logo2.svg" loading="lazy">
            </a>
          </div>
        <ul class="pipe__link-list link-list">
          <li class="link-list__item">
              <a class="link-list__link" href="/pipes/decimal-text">
                Decimal to text
              </a>
            </li><li class="link-list__item">
              <a class="link-list__link" href="/pipes/urlencode">
                URL encode
              </a>
            </li><li class="link-list__item">
              <a class="link-list__link" href="/pipes/enigma-decoder">
                Enigma decoder
              </a>
        </ul>
      </div>
    </header>
    
  <div class="pipe__scrollable">
    <div class="pipe__content">
      <button class="pipe__part-pipe">
        <div class="pipe__btn-add">Add encoder or viewer</div>
        <div class="pipe__drop-handle"></div>
      </button>
      <div class="pipe__part-brick pipe__part-brick--viewer" draggable="true">
        <div class="brick viewer viewer-text" role="region" aria-label="Text viewer">
          <header class="brick__header">
            <ul class="brick__actions">
              <li class="brick__action-item">
                <span class="brick__action brick__action--active">View</span>
              </li>
            </ul>
            <button class="brick__title">
              <h3 class="brick__title-inner">Plaintext</h3>
              <div class="brick__title-caret">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 6l5 5 5-5z"></path></svg>
              </div>
            </button>
            <button class="brick__btn-menu">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="2" r="1.5"></circle><circle cx="8" cy="8" r="1.5"></circle><circle cx="8" cy="14" r="1.5"></circle></svg></button>
            </header>
            <div class="brick__settings">
              <div class="form"></div>
            </div><div class="brick__content">
              <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;"></textarea>
            </div>
            <footer class="brick__status brick__status--hidden">
              <div class="brick__status-icon"></div>
              <div class="brick__status-message">
              </div>
            </footer>
          </div>
        </div>
        <button class="pipe__part-pipe">
          <div class="pipe__btn-add">Add encoder or viewer</div>
          <div class="pipe__drop-handle">
          </div>
        </button>
        <div class="pipe__part-brick pipe__part-brick--encoder" draggable="true">
          <div class="brick encoder" role="region" aria-label="Caesar cipher encoder">
            <header class="brick__header">
              <!-- svelte-ignore a11y-invalid-attribute -->
              <ul class="brick__actions">
                <li class="brick__action-item">
                  <!-- svelte-ignore a11y-invalid-attribute -->
                  <a class="brick__action brick__action--active" href="#" draggable="false">Encode</a>
                </li>
                <li class="brick__action-item"><a class="brick__action" href="#" draggable="false">Decode</a>
                </li>
              </ul>
              <button class="brick__title"><h3 class="brick__title-inner">Caesar cipher</h3>
                <div class="brick__title-caret">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 6l5 5 5-5z"></path></svg>
                </div>
              </button>
              <button class="brick__btn-menu"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="2" r="1.5"></circle><circle cx="8" cy="8" r="1.5"></circle><circle cx="8" cy="14" r="1.5"></circle></svg>
              </button>
            </header>
            <div class="brick__settings">
              <div class="form">
                <div class="field field-number field--first" data-width="12">
                  <label class="field__label" for="u1">Shift</label>
                  <div class="field-number__field">
                    <button class="field-number__btn-step-down">Step Down</button>
                    <div class="field-number__value">
                      <input class="field-number__input" id="u1" type="number">
                      <div class="field-number__display field-number__display--enabled">
                        <span class="field-number__display-value">7</span>
                        <span class="field-number__display-description">a→h</span>
                      </div>
                    </div>
                    <button class="field-number__btn-step-up">Step Up</button>
                  </div>
                </div>
                <div class="field field-text field--first" data-width="12">
                  <label class="field__label" for="u2">Alphabet</label>
                  <div class="field-text__field">
                    <input class="field-text__input" id="u2" type="text" spellcheck="false">
                  </div>
                </div>
                <div class="field field-enum field-enum--default field--first" data-width="6">
                  <label class="field__label" for="u3">Case Strategy</label>
                  <div class="field-enum__field">
                    <select class="field-enum__select" id="u3">
                      <option value="0" title="">Maintain case</option>
                      <option value="1" title="">Ignore case</option>
                    </select>
                  </div>
                </div>
                <div class="field field-boolean" data-width="6">
                  <label class="field__label" for="u4">Foreign Chars</label>
                  <div class="field__field">
                    <input class="field-boolean__input" type="checkbox" id="u4">
                    <label class="field-boolean__toggle" for="u4"><span class="field-boolean__choice">Include</span>
                      <span class="field-boolean__choice">Ignore</span>
                    </label>
                  </div>
                </div>
              </div>
            </div>
            <footer class="brick__status brick__status--forward">
              <div class="brick__status-icon">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M16 7H3.83l3.58-3.59L6 2 0 8l6 6 1.41-1.41L3.83 9H16z"></path></svg>
              </div>
              <div class="brick__status-message">Encoded 163 chars</div>
            </footer>
          </div>
        </div>
        <button class="pipe__part-pipe">
          <div class="pipe__btn-add">Add encoder or viewer</div>
          <div class="pipe__drop-handle"></div>
        </button><div class="pipe__part-brick pipe__part-brick--viewer" draggable="true">
          <div class="brick viewer viewer-text" role="region" aria-label="Text viewer">
            <header class="brick__header">
              <ul class="brick__actions">
                <li class="brick__action-item">
                  <span class="brick__action brick__action--active">View</span>
                </li>
              </ul>
              <button class="brick__title"><h3 class="brick__title-inner">Ciphertext</h3>
                <div class="brick__title-caret">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 6l5 5 5-5z"></path></svg>
                </div>
              </button>
              <button class="brick__btn-menu">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="2" r="1.5"></circle><circle cx="8" cy="8" r="1.5"></circle><circle cx="8" cy="14" r="1.5"></circle></svg>
              </button>
            </header>
            <div class="brick__settings">
              <div class="form"></div>
            </div>
            <div class="brick__content">
              <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;"></textarea>
            </div>
            <footer class="brick__status brick__status--hidden">
              <div class="brick__status-icon"></div>
              <div class="brick__status-message"></div>
            </footer>
          </div>
        </div>
        <button class="pipe__part-pipe">
          <div class="pipe__btn-add">Add encoder or viewer</div>
          <div class="pipe__drop-handle"></div>
        </button>
      </div>
      <div class="pipe__scroll-handle pipe__scroll-handle--left pipe__scroll-handle--disabled"></div>
      <div class="pipe__scroll-handle pipe__scroll-handle--right pipe__scroll-handle--disabled"></div>
    </div>
  </article>
</div>