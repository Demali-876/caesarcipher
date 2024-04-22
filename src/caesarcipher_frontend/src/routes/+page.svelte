<script>
  import "../index.css";
  import { backend } from '$lib/canisters';
  import { onMount } from 'svelte';

  let utf8Mode = false; 
  let message = '';
  let shift = 3;
  let foreignChar = { Exclude: null };
  let sensitivity = { Ignore: null };
  let output = '';
  let outputLetter = 'a';
  let alphabet = 'abcdefghijklmnopqrstuvwxyz';
  let activeAction = 'encode';
  $: encodedChars = message.length;

  $: updateOutputLetter(), shift;

  onMount(() => {
    updateOutputLetter();
  });

  function toggleMode() {
    utf8Mode = !utf8Mode; 
  }

  function updateVariantSelection(event, variantType) {
    if (variantType === 'foreignChar') {
      foreignChar = { [event.target.value]: null };
    } else if (variantType === 'sensitivity') {
      sensitivity = { [event.target.value]: null };
    }
  }

  function updateOutputLetter() {
    const index = (shift % 26 + 26) % 26;
    outputLetter = alphabet[index];
  }

  function stepUp() {
    shift += 1;
  }

  function stepDown() {
    shift -= 1;
  }

  function clearMessage() {
    message = '';
    output ='';
  }

  function resetControl() {
    utf8Mode = false;
    shift = 0;
  }

  function preprocessMessage() {
    if (foreignChar.Exclude) {
      message = message.replace(/[^a-zA-Z0-9 ]/g, ''); 
    }
  }

  async function encodeMessageUnified() {
    try {
        if (utf8Mode) {
            await encodeUTF8Message();
        } else {
            await encodeMessage();
        }
    } catch (error) {
        console.error('Unified encoding error:', error);
        output = 'Failed to encode message in unified function.';
    }
  }

  async function decodeMessageUnified() {
    try {
        if (utf8Mode) {
            await decodeInput(); 
        } else {
            await decodeMessage();
        }
    } catch (error) {
        console.error('Unified decoding error:', error);
        output = 'Failed to decode message in unified function.';
    }
  }

  async function encodeMessage() {
    preprocessMessage();
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
    preprocessMessage();
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

  async function encodeUTF8Message() {
    try {
      const result = await backend.encodeUtf8(message);
      output = result; 
    } catch (error) {
      console.error('Error encoding UTF-8 message:', error);
      output = 'Failed to encode message in UTF-8.';
    }
  }

  async function decodeInput() {
    const byteArray = message.split(',').map(Number);
    const uint8Array = new Uint8Array(byteArray);

    await decodeUTF8Message(uint8Array); 
}

async function decodeUTF8Message(uint8Array) {
    try {
        const result = await backend.decodeUtf8(uint8Array);
        output = result;
    } catch (error) {
        console.error('Error decoding UTF-8 message:', error);
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
              <h3 class="brick__title-inner">{utf8Mode ? 'Text/Blob' : 'Plaintext'}</h3>
              
            </button>
            <button class="brick__btn-menu brick__action" on:click={clearMessage}>
            Clear
            </button>
            </header>
            <div class="brick__settings">
              <div class="form"></div>
            </div><div class="brick__content">
              <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;"bind:value={message} placeholder={utf8Mode ? 'Enter plaintext then click encode or enter a blob example: "104,101,108,108,111" and click decode to get the text.' : 'Enter ciphertext then click decode or enter plaintext, configure your shift, case and foreign character strategy and click encode to get the ciphertext.'}></textarea>
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
                  <a href="#" class="brick__action" class:brick__action--active={activeAction === 'encode'} draggable="false" on:click={encodeMessageUnified}>
                    Encode
                  </a>
                </li>
                <li class="brick__action-item">
                  <a href="#" class="brick__action" class:brick__action--active={activeAction === 'decode'} draggable="false" on:click={decodeMessageUnified}>
                    Decode
                  </a>
                </li>
              </ul>
              <button class="brick__title" on:click={toggleMode}>
                <h3 class="brick__title-inner">{utf8Mode ? 'UTF-8 Encoder' : 'Caesar Cipher'}</h3>
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
              <button class="brick__title"><h3 class="brick__title-inner">{utf8Mode ? 'Decoded Text/Blob' : 'Cipher Text'}</h3>
              </button>
              <button class="brick__btn-menu-canister brick__action ">
                Canister Interface</button>
            </header>
            <div class="brick__settings">
              <div class="form"></div>
            </div>
            <div class="brick__content">
              <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;" placeholder={utf8Mode ? 'Your encoded blob or decoded text will appear here.' : 'Your cipher text or plaintext will appear here.'}>{output}</textarea>
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
        <h1 class="pipe__title">Caesar Cipher: Encode and Decode Canister Service</h1>
        <p class="pipe__description">Named after Julius Caesar, who famously utilized it for secure communications, this method forms a foundational example of cryptographic practice. The implementation of this cipher as a canister service was achieved using the Motoko programming language, leveraging its text and char libraries to handle encoding and decoding operations efficiently.</p>
        <div class="badge">
            <a class="badge__link" href="https://internetcomputer.org/" target="_blank" rel="noopener">
              <img class="badge__image" alt="internet computer" width="196" height="56" src="logo2.svg" loading="lazy">
            </a>
          </div>
        <ul class="pipe__link-list link-list">
          <li class="link-list__item">
            <a class="link-list__link" href="https://oajhk-xaaaa-aaaap-qca7a-cai.icp0.io/" target="_blank" rel="noopener noreferrer">
              Creator
            </a>
          </li>
          <li class="link-list__item">
            <a class="link-list__link" href="https://twitter.com/demali_icp" target="_blank" rel="noopener noreferrer">
              Twitter
            </a>
          </li>
          <li class="link-list__item">
            <a class="link-list__link" href="https://internetcomputer.org/docs/current/motoko/main/base/Text#value-encodeutf8" target="_blank" rel="noopener noreferrer">
              UTF-8 Encoding
            </a>
          </li>
        </ul>
      </div>
    </header>
  </article>
</div>