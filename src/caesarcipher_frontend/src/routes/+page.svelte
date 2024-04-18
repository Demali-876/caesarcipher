<script>
  import "../index.scss";
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

<main>
  <div class="brick viewer viewer-text" role="region" aria-label="Text viewer">
    <header class="brick__header">
      <ul class="brick__actions"> 
        <li class="brick__action-item">
          <span class="brick__action brick__action--active">View</span>
        </li>
      </ul>
      <button class="brick__title"><h3 class="brick__title-inner">Plaintext</h3><div class="brick__title-caret"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 6l5 5 5-5z"></path></svg></div></button>
      <button class="brick__btn-menu"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="2" r="1.5"></circle><circle cx="8" cy="8" r="1.5"></circle><circle cx="8" cy="14" r="1.5"></circle></svg></button>
    </header><div class="brick__settings"><div class="form"></div></div>
    <div class="brick__content">
      <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;" bind:value={message}></textarea>
    </div>
    <footer class="brick__status brick__status--hidden"><div class="brick__status-icon">
    </div>
    <div class="brick__status-message">
    </div></footer></div>
    <div class="pipe__part-brick pipe__part-brick--encoder" draggable="true">
      <div class="brick encoder" role="region" aria-label="Caesar cipher encoder">
        <header class="brick__header">
          <ul class="brick__actions">
            <button type="button" on:click={encodeMessage}>Encode</button>
            <button type="button" on:click={decodeMessage}>Decode</button>
          </ul>
          <button class="brick__title"><h3 class="brick__title-inner">Caesar cipher</h3>
            <div class="brick__title-caret">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 6l5 5 5-5z"></path></svg></div></button><button class="brick__btn-menu">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="2" r="1.5"></circle><circle cx="8" cy="8" r="1.5"></circle><circle cx="8" cy="14" r="1.5"></circle></svg>
          </button></header>
          <div class="brick__settings"><div class="form"><div class="field field-number field--first" data-width="12">
            <label class="field__label" for="u1">Shift</label>
            <div class="field-number__field">
              <button class="field-number__btn-step-down">Step Down</button>
              <div class="field-number__value"><input class="field-number__input" id="u1" type="number" bind:value={shift} >
                <div class="field-number__display field-number__display--enabled"><span class="field-number__display-value">7</span>
                  <span class="field-number__display-description">a→h</span></div></div>
                  <button class="field-number__btn-step-up">Step Up</button></div></div>
                  <div class="field field-text field--first" data-width="12">
                  </div>
                  <div>
                    <label for="foreignChar">Foreign Characters:</label>
                    <select id="foreignChar" on:change={(e) => updateVariantSelection(e, 'foreignChar')}>
                      <option value="Exclude">Exclude</option>
                      <option value="Include">Include</option>
                    </select>
                  </div>
                  <div>
                    <label for="sensitivity">Case Sensitivity:</label>
                    <select id="sensitivity" on:change={(e) => updateVariantSelection(e, 'sensitivity')}>
                      <option value="Ignore">Ignore</option>
                      <option value="MaintainCase">Maintain Case</option>
                    </select>
                  </div>
                </div>
              </div>
              <footer class="brick__status brick__status--forward"><div class="brick__status-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M16 7H3.83l3.58-3.59L6 2 0 8l6 6 1.41-1.41L3.83 9H16z"></path></svg>
              </div>
              <div class="brick__status-message">Encoded 169 chars</div>
            </footer>
          </div>
        </div>
              <div class="pipe__part-brick pipe__part-brick--viewer" draggable="true">
                        <div class="brick viewer viewer-text" role="region" aria-label="Text viewer">
                          <header class="brick__header">
                            <ul class="brick__actions">
                              <li class="brick__action-item">
                                <span class="brick__action brick__action--active">View</span>
                              </li>
                            </ul><button class="brick__title">
                              <h3 class="brick__title-inner">Text</h3>
                              <div class="brick__title-caret">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 6l5 5 5-5z"></path></svg>
                              </div></button>
                              <button class="brick__btn-menu"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
                                <circle cx="8" cy="2" r="1.5"></circle><circle cx="8" cy="8" r="1.5"></circle>
                                <circle cx="8" cy="14" r="1.5"></circle></svg>
                              </button>
                          </header>
                          <div class="brick__content">
                            <textarea class="viewer-text__textarea" aria-label="Content" spellcheck="false" style="height: 200px;">{output}
                            </textarea>
                          </div>
</main>

