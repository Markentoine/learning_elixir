<template>
<div id="game">
  <div id="squares">
    <div class="row" 
          v-for="(rowOfSquares, index) in squares"
          v-bind:key="index">
      <div class="square"
           v-for="square in rowOfSquares"
           v-bind:key="square.phrase"
           v-bind:style="squareStyle(square)"
           v-on:click="$emit('send-mark', square)">
        <span class="phrase">{{ square.phrase }}</span>
        <span class="points">{{ square.points }}</span>
        <span class="name" v-if="square.marked_by">
          {{ square.marked_by.name }}
        </span>
      </div>
    </div>
  </div>
  <transition name="game-over-appear">
    <div id="game-over" v-if="winner">
      {{ winner.name }} won!
    </div>
  </transition>
</div>
</template>

<script>
  export default {
    props: {
      squares: Array,
      winner: Object
    },
    methods: {
      squareStyle(square) {
        const player = square.marked_by
        return player ? { backgroundColor: player.color } : { }
      }
    }
  }
</script>