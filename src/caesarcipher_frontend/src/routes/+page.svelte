<script>
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
      output = 'Encoded message: ' + result;
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
  <h1>Caesar Cipher Encoder/Decoder</h1>
  <form on:submit|preventDefault>
    <div>
      <label for="message">Message:</label>
      <input type="text" id="message" bind:value={message} />
    </div>
    <div>
      <label for="shift">Shift:</label>
      <input type="number" id="shift" bind:value={shift} />
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
    <button type="button" on:click={encodeMessage}>Encode</button>
    <button type="button" on:click={decodeMessage}>Decode</button>
  </form>
  <section id="output">{output}</section>
</main>