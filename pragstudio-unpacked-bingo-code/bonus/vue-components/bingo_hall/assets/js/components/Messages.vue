<template>
  <ul id="messages" ref="messages" class="list-group">
    <li class="list-group-item"
        v-for="(message, index) in messages"
        v-bind:key="index">
      <span class="chat-message-name">{{ message.name }}:</span>
      <span class="chat-message-body">{{ message.body }}</span>
    </li>
  </ul>
</template>

<script>
  export default {
    props: {
      messages: Array
    },
    watch: {
      messages(newValue, oldValue) {
        this.$nextTick(() => {
          // DOM is now updated
          const messageList = this.$refs.messages
          messageList.scrollTop = messageList.scrollHeight
        })
      }
    }
  }
</script>