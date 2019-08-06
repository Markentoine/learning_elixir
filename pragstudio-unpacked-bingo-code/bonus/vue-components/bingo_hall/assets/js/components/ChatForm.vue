<template>
  <form id="chat-form" v-on:submit.prevent="$emit('send-chat')">
    <div class="input-group">
      <input id="chat-input"
              type="text"
              class="form-control"
              v-bind:value="value"
              v-on:input="$emit('input', $event.target.value)">
        <span class="input-group-btn">
          <button id="chat-button" 
                  class="btn btn-primary"
                  v-bind:disabled="!value"
                  v-on:click="$emit('send-chat')">
            <i class="fa fa-comment"></i>
          </button>
        </span>
    </div>
  </form>
</template>

<script>
  export default {
    props: {
      value: String
    }
  }
</script>