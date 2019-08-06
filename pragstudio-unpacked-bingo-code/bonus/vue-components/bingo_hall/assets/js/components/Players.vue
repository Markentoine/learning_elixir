<template>
  <ul id="players" class="list-group">
    <transition-group name="player-appear">
      <li class="list-group-item" 
          v-for="player in players"
          v-bind:key="player.name">
        <span class="player-color" 
              v-bind:style="{ background: player.color }"></span>
        <span class="player-name">{{ player.name }}</span>
        <span class="player-score">{{ player.score }}</span>
      </li>
    </transition-group>
  </ul>
</template>

<script>
  export default {
    props: {
      players: Array
    }
  }
</script>
