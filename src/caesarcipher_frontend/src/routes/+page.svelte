<script>
  import "../index.css";
  import { backend } from '$lib/canisters';
  import { onMount } from 'svelte';


  let message = '';
  let shift = 0;
  let foreignChar = { Exclude: null };
  let sensitivity = { Ignore: null };
  let output = '';
  let outputLetter = 'a';
  let alphabet = 'abcdefghijklmnopqrstuvwxyz';
  let activeAction = 'encode';
  $: encodedChars = message.length;

  function updateVariantSelection(event, variantType) {
    if (variantType === 'foreignChar') {
      foreignChar = { [event.target.value]: null };
    } else if (variantType === 'sensitivity') {
      sensitivity = { [event.target.value]: null };
    }
  }
  function updateOutputLetter() {
    const alphabet = 'abcdefghijklmnopqrstuvwxyz';
    const index = (shift % 26 + 26) % 26;
    outputLetter = alphabet[index];
  }
  $: updateOutputLetter(), shift;
  function stepUp() {
    shift += 1;
  }

  function stepDown() {
    shift -= 1;
  }
  function clearMessage() {
    message = '';
  }
  function resetControl(){
    shift = 0;
    foreignChar = { Include: null };
    sensitivity = { MaintainCase: null };
  }
  async function encodeMessage() {
    activeAction = 'encode';
    try {
      const result = await backend.encode({
        message,
        shift,
        foreignChar,
        sensitivity
      });
      output = result;
    } catch (error) {
      console.error('Error encoding message:', error);
      output = 'Failed to encode message.';
    }
  }

  async function decodeMessage() {
    activeAction = 'decode';
    try {
      const result = await backend.decode({
        message,
        shift,
        foreignChar,
        sensitivity
      });
      output = result;
    } catch (error) {
      console.error('Error decoding message:', error);
      output = 'Failed to decode message.';
    }
  }
  onMount(() => {
    updateOutputLetter();
  });
</script>
<div class="app">
  <header class="app__header header">
    <div class="header__inner">
      <div class="header__item">
        <a class="header__brand" href="/">
          <!-- svelte-ignore a11y-missing-attribute -->
          <img class=" small-on-mobile"width="125" height="150"  aria-labelledby="app_logo" src="logo.svg">
        </a>
      </div>
    </div>
  </header>
  <article class="app__pipe pipe">
  <div class="pipe__scrollable">
    <div class="pipe__content">
      <button class="pipe__part-pipe">
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
            <button class="brick__btn-menu brick__action" on:click={clearMessage}>
            Clear
            </button>
            </header>
            <div class="brick__settings">
              <div class="form"></div>
            </div><div class="brick__content">
              <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;"bind:value={message}></textarea>
            </div>
            <footer class="brick__status brick__status--hidden">
              <div class="brick__status-icon"></div>
              <div class="brick__status-message">
              </div>
            </footer>
          </div>
        </div>
        <button class="pipe__part-pipe">
        </button>
        <div class="pipe__part-brick pipe__part-brick--encoder" draggable="true">
          <div class="brick encoder" role="region" aria-label="Caesar cipher encoder">
            <header class="brick__header">
              <ul class="brick__actions">
                <li class="brick__action-item">
                  <a href="#" class="brick__action" class:brick__action--active={activeAction === 'encode'} draggable="false" on:click={encodeMessage}>
                    Encode
                  </a>
                </li>
                <li class="brick__action-item">
                  <a href="#" class="brick__action" class:brick__action--active={activeAction === 'decode'} draggable="false" on:click={decodeMessage}>
                    Decode
                  </a>
                </li>
              </ul>
              <button class="brick__title">
                <h3 class="brick__title-inner">Caesar cipher</h3>
                <div class="brick__title-caret">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 6l5 5 5-5z"></path></svg>
                </div>
              </button>
              <button class="brick__btn-menu brick__action " on:click={resetControl}>Reset</button>
            </header>
            <div class="brick__settings">
              <div class="form">
                <div class="field field-number field--first" data-width="12">
                  <label class="field__label" for="u1">Shift</label>
                  <div class="field-number__field">
                    <button class="field-number__btn-step-down" on:click={stepDown}>Step Down</button>
                    <div class="field-number__value">
                      <input class="field-number__input" id="u1" type="number" bind:value={shift} >
                      <div class="field-number__display field-number__display--enabled">
                        <span class="field-number__display-value">{shift}</span>
                        <span class="field-number__display-description">a→{outputLetter}</span>
                      </div>
                    </div>
                    <button class="field-number__btn-step-up" on:click={stepUp}>Step Up</button>
                  </div>
                </div>
                <div class="field field-text field--first" data-width="12">
                  <label class="field__label" for="u2">Alphabet</label>
                  <div class="field-text__field">
                    <input class="field-text__input" id="u2" type="text" bind:value={alphabet} spellcheck="false" readonly>
                  </div>
                </div>
                <div class="field field-enum field-enum--default field--first" data-width="6">
                  <label class="field__label" for="u3">Case Sensitivity</label>
                  <div class="field-enum__field">
                    <select class="field-enum__select" id="u3" on:change={(e) => updateVariantSelection(e, 'sensitivity')}>
                      <option value="MaintainCase" title="">Maintain case</option>
                      <option value="Ignore" title="">Ignore case</option>
                    </select>
                  </div>
                </div>
                <div class="field field-enum field-enum--default field--firs" data-width="6">
                  <label class="field__label" for="u3">Foreign Chars</label>
                  <div class="field-enum__field">
                    <select class="field-enum__select" id="u3" on:change={(e) => updateVariantSelection(e, 'foreignChar')}>
                      <option value="Include">Include</option>
                      <option value="Exclude">Exclude</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <footer class="brick__status brick__status--forward">
              <div class="brick__status-icon">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M16 7H3.83l3.58-3.59L6 2 0 8l6 6 1.41-1.41L3.83 9H16z"></path></svg>
              </div>
              <div class="brick__status-message">Encoded {encodedChars} chars</div>
            </footer>
          </div>
        </div>
        <button class="pipe__part-pipe">
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
              <button class="brick__btn-menu-canister brick__action ">
                Canister Interface</button>
            </header>
            <div class="brick__settings">
              <div class="form"></div>
            </div>
            <div class="brick__content">
              <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;">{output}</textarea>
            </div>
            <footer class="brick__status brick__status--hidden">
              <div class="brick__status-icon"></div>
              <div class="brick__status-message"></div>
            </footer>
          </div>
        </div>
        <button class="pipe__part-pipe">
        </button>
      </div>
      <div class="pipe__scroll-handle pipe__scroll-handle--left pipe__scroll-handle--disabled"></div>
      <div class="pipe__scroll-handle pipe__scroll-handle--right pipe__scroll-handle--disabled"></div>
    </div>
    <header class="pipe__header">
      <div class="container">
        <h1 class="pipe__title">Caesar cipher: Encode and decode canister service</h1>
        <p class="pipe__description">Method in which each letter in the plaintext is replaced by a letter some fixed number of positions down the alphabet. The method is named after Julius Caesar, who used it in his private correspondence.</p>
        <div class="badge">
            <a class="badge__link" href="https://internetcomputer.org/" target="_blank" rel="noopener">
              <img class="badge__image" alt="internet computer" width="196" height="56" src="logo2.svg" loading="lazy">
            </a>
          </div>
        <ul class="pipe__link-list link-list">
          <li class="link-list__item">
              <a class="link-list__link" href="https://oajhk-xaaaa-aaaap-qca7a-cai.icp0.io/">
                Creator
              </a>
            </li><li class="link-list__item">
              <a class="link-list__link" href="https://twitter.com/demali_icp">
                Twitter
              </a>
            </li>
        </ul>
      </div>
    </header>
  </article>
</div>