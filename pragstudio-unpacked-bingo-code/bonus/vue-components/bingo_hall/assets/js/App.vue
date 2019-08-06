<template>
  <div id="game-container">
    <div id="content">
      <p id="error" class="alert alert-danger">
        {{ error }}
      </p>
      <div class="row">
        <div class="col-xs-8">          
          <Game v-bind:squares="squares"
                v-bind:winner="winner"
                v-on:send-mark="sendMark" />
        </div>
        <div class="col-xs-4">
          <div class="panel panel-default">
            <div class="panel-heading">Who's Playing</div>
            <div class="panel-body">
              <Players v-bind:players="players"/>
            </div>
          </div>
          <div class="panel panel-default">
            <div class="panel-heading">What's Up?</div>
            <div class="panel-body">
              <Messages v-bind:messages="messages"/>
            </div>
          </div>
          <ChatForm v-model="chatMessage" 
                    v-on:send-chat="sendChat"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import Game     from './components/Game.vue'
  import Players  from './components/Players.vue'
  import Messages from './components/Messages.vue'
  import ChatForm from './components/ChatForm.vue'
  import { Socket, Presence } from "phoenix"

  export default {
    components: { 
      Game, 
      Players, 
      Messages, 
      ChatForm 
    },
    data () {
      return {
        squares: [],
        scores: {},
        winner: null,
        messages: [],
        players: [],
        chatMessage: "",
        error: ""
      }
    },
    methods: {
      sendMark(square) {
        if (!square.marked_by) {
          this.channel.push("mark_square", { phrase: square.phrase })
        }
      },
      sendChat(event) {
        if (this.chatMessage) {
          this.channel.push("new_chat_message", { body: this.chatMessage })
          this.chatMessage = ""
        }
      },
      joinChannel(authToken, gameName) {
        const socket =
          new Socket("/socket", { params: { token: authToken } })

        socket.connect()

        this.channel = socket.channel(`games:${gameName}`, {})
        
        this.channel.on("game_summary", summary => {
          this.squares = summary.squares
          this.scores = summary.scores
          this.winner = summary.winner
          this.players = this.toPlayers(this.presences)
        })

        this.presences = {}

        this.channel.on('presence_state', state => {
          this.presences = Presence.syncState(this.presences, state)
          this.players = this.toPlayers(this.presences)
        })

        this.channel.on('presence_diff', diff => {
          this.presences = Presence.syncDiff(this.presences, diff)
          this.players = this.toPlayers(this.presences)
        })

        this.channel.on("new_chat_message", message => {
          this.messages.push(message)
        })

        this.channel
          .join()
          .receive("ok", response => {
            console.log(`Joined ${gameName} 😊`)
          })
          .receive("error", response => {
            this.error = `Joining ${gameName} failed 🙁`
            console.log(this.error, response)
          })
      },
      toPlayers(presences) {
        const listBy = (name, { metas: [first, ...rest] }) => {
          const score = this.scores[name] || 0
          return { name: name, color: first.color, score: score }
        }

        return Presence.list(presences, listBy)
      }
    },
    created: function () {
      const gameContainer = this.$parent.$el

      const { authToken, gameName } = gameContainer.dataset

      this.joinChannel(authToken, gameName)
    }
  }
</script>